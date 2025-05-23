import 'package:flutter/material.dart';
import '../models/person.dart';
import '../models/relationship.dart';
import './person_card.dart'; 
import './relationship_painter.dart';
import 'dart:math'; // For Random

class FamilyCanvas extends StatefulWidget {
  const FamilyCanvas({Key? key}) : super(key: key);

  @override
  _FamilyCanvasState createState() => _FamilyCanvasState();
}

class _FamilyCanvasState extends State<FamilyCanvas> {
  final List<Person> _persons = [];
  final List<Relationship> _relationships = [];
  final Random _random = Random();

  Person? _selectedPersonForRelationship; 
  bool _isSelectingRelationshipMode = false;

  @override
  void initState() {
    super.initState();
    _addSamplePersonsAndRelationships();
  }

  void _addSamplePersonsAndRelationships() {
    _persons.addAll([
      Person(id: '1', name: 'John Doe', description: 'Father of Jane.', position: Offset(50, 50)),
      Person(id: '2', name: 'Jane Doe', description: 'Daughter of John.', position: Offset(250, 150)),
      Person(id: '3', name: 'Peter Smith', description: 'A family friend.', position: Offset(100, 250)),
      Person(id: '4', name: 'Mary Doe', description: 'Spouse of John.', position: Offset(50, 150)),
    ]);
    _relationships.addAll([
      Relationship(id: 'r1', fromPersonId: '1', toPersonId: '2', type: RelationshipType.parentChild),
      Relationship(id: 'r2', fromPersonId: '1', toPersonId: '4', type: RelationshipType.spouse),
    ]);
  }

  void _addPerson() async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Add New Person'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
                autofocus: true,
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  Navigator.of(dialogContext).pop({
                    'name': nameController.text,
                    'description': descriptionController.text,
                  });
                }
              },
            ),
          ],
        );
      },
    );

    if (result != null && result['name'] != null) {
      final newId = DateTime.now().millisecondsSinceEpoch.toString();
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;

      final newPerson = Person(
        id: newId,
        name: result['name']!,
        description: result['description'] ?? '',
        position: Offset(
          _random.nextDouble() * (screenWidth - 150), 
          _random.nextDouble() * (screenHeight - 250), 
        ),
      );
      setState(() {
        _persons.add(newPerson);
      });
    }
  }

  void _handlePersonTap(Person tappedPerson) {
    if (!_isSelectingRelationshipMode) return;

    setState(() {
      if (_selectedPersonForRelationship == null) {
        _selectedPersonForRelationship = tappedPerson;
      } else if (_selectedPersonForRelationship!.id != tappedPerson.id) {
        _showRelationshipTypeDialog(_selectedPersonForRelationship!, tappedPerson);
      }
    });
  }

  void _showRelationshipTypeDialog(Person fromPerson, Person toPerson) async {
    final RelationshipType? selectedType = await showDialog<RelationshipType>(
      context: context,
      builder: (BuildContext dialogContext) {
        return SimpleDialog(
          title: Text('Select Relationship Type'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () { Navigator.of(dialogContext).pop(RelationshipType.parentChild); },
              child: const Text('Parent-Child'),
            ),
            SimpleDialogOption(
              onPressed: () { Navigator.of(dialogContext).pop(RelationshipType.spouse); },
              child: const Text('Spouse'),
            ),
          ],
        );
      },
    );

    if (selectedType != null) {
      final newRelationshipId = DateTime.now().millisecondsSinceEpoch.toString();
      final newRelationship = Relationship(
        id: newRelationshipId,
        fromPersonId: fromPerson.id,
        toPersonId: toPerson.id,
        type: selectedType,
      );
      setState(() {
        _relationships.add(newRelationship);
        _selectedPersonForRelationship = null; 
      });
    } else {
       setState(() {
        _selectedPersonForRelationship = null;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    // The AppBar's appearance will be influenced by appBarTheme in main.dart
    return Scaffold(
      appBar: AppBar(
        title: Text('Visual Family Tree'),
        actions: [
          IconButton(
            icon: Icon(Icons.link),
            color: _isSelectingRelationshipMode 
                   ? Theme.of(context).colorScheme.secondary // Active color from theme
                   : null, // Default color (from AppBarTheme or iconTheme)
            tooltip: 'Create Relationship',
            onPressed: () {
              setState(() {
                _isSelectingRelationshipMode = !_isSelectingRelationshipMode;
                _selectedPersonForRelationship = null; 
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          CustomPaint(
            painter: RelationshipPainter(persons: _persons, relationships: _relationships, context: context),
            child: Container(),
            size: Size.infinite,
          ),
          ..._persons.map((person) {
            return Positioned(
              left: person.position.dx,
              top: person.position.dy,
              child: GestureDetector(
                onTap: () => _handlePersonTap(person),
                child: Draggable<Person>(
                  data: person,
                  feedback: Material(
                    child: PersonCard(person: person, isSelected: (_selectedPersonForRelationship?.id == person.id && _isSelectingRelationshipMode)),
                    elevation: 4.0,
                    color: Colors.transparent,
                  ),
                  childWhenDragging: Container(),
                  onDragEnd: (details) {
                    setState(() {
                      final index = _persons.indexWhere((p) => p.id == person.id);
                      if (index != -1) {
                         _persons[index].position = details.offset;
                      }
                    });
                  },
                  child: PersonCard(
                    person: person, 
                    isSelected: (_selectedPersonForRelationship?.id == person.id && _isSelectingRelationshipMode)
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPerson,
        tooltip: 'Add Person',
        child: Icon(Icons.add),
        // The FAB's color will be influenced by floatingActionButtonTheme in main.dart
      ),
    );
  }
}
