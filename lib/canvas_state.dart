import 'package:flutter/material.dart'; // For ChangeNotifier and Offset
import './person_model.dart'; // Import the Person model

// Define the type of relationship
enum RelationshipType {
  parent,
  child,
  spouse,
}

// Define the Relationship class
class Relationship {
  final String id; // Unique ID for the relationship itself
  final String personId1;
  final String personId2;
  final RelationshipType type;

  Relationship({
    required this.id,
    required this.personId1,
    required this.personId2,
    required this.type,
  });
}

class CanvasState extends ChangeNotifier {
  final List<Person> _persons = [];
  final List<Relationship> _relationships = [];

  List<Person> get persons => _persons;
  List<Relationship> get relationships => _relationships;

  // Method to add a new person
  void addPerson(Person person) {
    _persons.add(person);
    notifyListeners();
  }

  // Method to update a person's position
  void updatePersonPosition(String personId, Offset newPosition) {
    try {
      final person = _persons.firstWhere((p) => p.id == personId);
      person.position = newPosition;
      notifyListeners();
    } catch (e) {
      // Optionally handle the case where the person is not found
      debugPrint("Person with ID \$personId not found for position update.");
    }
  }

  // Method to add a relationship
  // Ensures no duplicate relationships (p1-p2 is same as p2-p1 for spouse)
  void addRelationship(String personId1, String personId2, RelationshipType type) {
    if (personId1 == personId2) return; // Cannot relate a person to themselves

    // Check for existing relationship (especially for spouse to avoid duplicates)
    bool exists = _relationships.any((r) {
      if (r.type == RelationshipType.spouse) {
        return ((r.personId1 == personId1 && r.personId2 == personId2) ||
                (r.personId1 == personId2 && r.personId2 == personId1));
      }
      // For parent/child, direction matters
      return (r.personId1 == personId1 && r.personId2 == personId2 && r.type == type);
    });

    if (!exists) {
      final newRelationship = Relationship(
        // Simple ID generation for now, consider UUID for more robustness
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        personId1: personId1,
        personId2: personId2,
        type: type,
      );
      _relationships.add(newRelationship);
      notifyListeners();
    }
  }

  // Method to remove a person (and their relationships)
  void removePerson(String personId) {
    _persons.removeWhere((p) => p.id == personId);
    _relationships.removeWhere((r) => r.personId1 == personId || r.personId2 == personId);
    notifyListeners();
  }

  // Method to remove a relationship
  void removeRelationship(String relationshipId) {
    _relationships.removeWhere((r) => r.id == relationshipId);
    notifyListeners();
  }

  // Helper to get a person by ID (used by painter)
  Person? getPersonById(String id) {
    try {
      return _persons.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}
