const expect = require('chai').expect;

let {db, Person} = require('../persistence');

describe('Mongoose Person Model Usage', () => {
    let alice, bob, charles, david;
    describe('Person Creation', () => {
        it('should allow creation with required field', () => {
            alice = new Person({name: 'Alice'})
            expect(alice.name).to.equal('Alice');

            bob = new Person({fullName: 'Bob Brown'});
            expect(bob.name).to.equal('Bob')
        });
        it('should allow to complete all fields', () => {
            charles = new Person({
                fullName: 'Charles Brown',
                photosURLs: ['https://bit.ly/34Kvbsh'],
                yearBorn: 1922,
                notes: 'Famous blues singer and pianist. Parent were made up.',
                mother: alice._id,
                father: bob._id,
            });
            expect(charles.name).to.equal('Charles');
        });
        it('should allow saving and retrieving back', async () => {
            await alice.save();
            await bob.save();
            await charles.save();
            retrievedPerson = await Person.findOne({name: 'Charles'}).exec();
            expect(charles.fullName).to.equals(retrievedPerson.fullName);
            expect(alice.fullName).to.equal(retrievedPerson.mother.fullName);
            expect(bob.fullName).to.equal(retrievedPerson.father.fullName);

        });
    });
    describe('Person Update', () => {
        it('should allow to set a property', () => {
            alice.surname = 'Adams';
            expect(alice.fullName).to.equal('Alice Adams');
        });
        it('should allow to change an existing value', () => {
            charles.photosURLs.push('https://bit.ly/2QJCnMV');
            expect(charles.photosURLs.length).to.equal(2);
        });
        it('should allow saving and retrieving back', async () => {
            await alice.save();
            await charles.save();
            dbAlice = await Person.findOne({name: 'Alice'}).exec();
            dbCharles = await Person.findOne({name: 'Charles'}).exec();
            expect(alice.fullName).to.equal(dbAlice.fullName);
            expect(charles.photosURLs[1]).to.equal(dbCharles.photosURLs[1]);
        });
    });
    describe('Person Retrieval', () => {
        it('should allow to get one Person with parents populated', async () => {
            david = new Person({fullName: 'David Brown', father: charles._id});
            await david.save();
            dbDavid = await Person.findOne({name: 'David'}).exec();
            expect(david.fullName).to.equal(dbDavid.fullName);
            expect(dbDavid.father.fullName).to.equal(charles.fullName);
        });
        it('should allow to get all saved Persons', async () => {
            let all = await Person.find({}).exec();
            expect(all.length).to.equal(4);
        });
    });
    describe('Person Deletion', () => {
        it('should allow to delete one Person', async () => {
            await Person.deleteOne({name: 'David'});
            let person = await Person.findOne({name: 'David'}).exec();
            expect(person).to.be.null;
        });
        it('should allow to deleted all saved Persons', async () => {
            await Person.deleteMany({}).exec();
            let all = await Person.find({}).exec();
            expect(all.length).to.equal(0);
        });
    });
});

after(() => {  
  db.disconnect()
})