let mongoose = require('mongoose');

mongoose.connect('mongodb://localhost:27017/genealogy', {useNewUrlParser: true, useUnifiedTopology: true});

const urlPattern = /(http|https):\/\/(\w+:{0,1}\w*#)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%#!\-/]))?/;
const urlRegExp = new RegExp(urlPattern);

let PersonSchema = new mongoose.Schema({
  name:  { type: String, index: true, required: true },
  surname:  { type: String, index: true },
  photosURLs: [
    {
      type: String,
      validate: {
        validator: function(value) {
          return value.match(urlRegExp);
        },
        message: props => `${props.value} is not a valid URL`
      }
    }
  ],
  yearBorn: { type: Number, min: -5000, max: (new Date).getFullYear() },
  notes: { type: String, minlength: 5 },
  mother: { type: mongoose.Schema.Types.ObjectId, ref: 'Person' },
  father: { type: mongoose.Schema.Types.ObjectId, ref: 'Person' },
});

PersonSchema.virtual('fullName').
  get(function() { 
    if(this.surname)
      return this.name + ' ' + this.surname; 
    return this.name;
  }).
  set(function(fullName) {
    fullName = fullName.split(' ');
    this.name = fullName[0];
    this.surname = fullName[1];
  });

PersonSchema.pre('findOne', function(next) {
  this.populate('mother').populate('father');
  next();
});

module.exports.db = mongoose;
module.exports.Person = mongoose.model('Person', PersonSchema);