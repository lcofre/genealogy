import 'package:flutter_test/flutter_test.dart';
import 'package:visual_family_tree/models/relationship.dart';

void main() {
  group('Relationship', () {
    test('constructor assigns properties correctly', () {
      final relationship = Relationship(
        id: 'r1',
        fromPersonId: 'p1',
        toPersonId: 'p2',
        type: RelationshipType.parentChild,
      );

      expect(relationship.id, 'r1');
      expect(relationship.fromPersonId, 'p1');
      expect(relationship.toPersonId, 'p2');
      expect(relationship.type, RelationshipType.parentChild);
    });
  });
}
