enum RelationshipType {
  parentChild,
  spouse,
  // Add other types as needed
}

class Relationship {
  String id;
  String fromPersonId;
  String toPersonId;
  RelationshipType type;

  Relationship({
    required this.id,
    required this.fromPersonId,
    required this.toPersonId,
    required this.type,
  });
}
