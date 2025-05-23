import 'package:flutter/material.dart';
import '../models/person.dart';
import '../models/relationship.dart';

class RelationshipPainter extends CustomPainter {
  final List<Person> persons;
  final List<Relationship> relationships;
  final BuildContext context; // For accessing theme

  RelationshipPainter({required this.persons, required this.relationships, required this.context});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2.0;

    for (var relationship in relationships) {
      final fromPerson = persons.firstWhere((p) => p.id == relationship.fromPersonId, orElse: () => Person(id: '', name: '', position: Offset.zero));
      final toPerson = persons.firstWhere((p) => p.id == relationship.toPersonId, orElse: () => Person(id: '', name: '', position: Offset.zero));

      if (fromPerson.id.isEmpty || toPerson.id.isEmpty) continue;

      final Offset fromCenter = fromPerson.position + Offset(75, 50); // Placeholder center
      final Offset toCenter = toPerson.position + Offset(75, 50);   // Placeholder center

      switch (relationship.type) {
        case RelationshipType.parentChild:
          paint.color = Theme.of(context).colorScheme.primary.withOpacity(0.7); // Using theme color
          break;
        case RelationshipType.spouse:
          paint.color = Theme.of(context).colorScheme.secondary.withOpacity(0.7); // Using theme color
          break;
        default:
          paint.color = Colors.grey.withOpacity(0.7);
      }

      canvas.drawLine(fromCenter, toCenter, paint);
    }
  }

  @override
  bool shouldRepaint(covariant RelationshipPainter oldDelegate) {
    return oldDelegate.persons != persons || 
           oldDelegate.relationships != relationships ||
           oldDelegate.context != context; // Context change might imply theme change
  }
}
