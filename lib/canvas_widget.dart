import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // For Consumer
import './canvas_state.dart';
import './person_card_widget.dart';
import './person_model.dart';

// The main canvas widget
class CanvasWidget extends StatefulWidget {
  const CanvasWidget({Key? key}) : super(key: key);

  @override
  State<CanvasWidget> createState() => _CanvasWidgetState();
}

class _CanvasWidgetState extends State<CanvasWidget> {
  @override
  Widget build(BuildContext context) {
    // Use a Consumer to listen to CanvasState changes
    return Consumer<CanvasState>(
      builder: (context, canvasState, child) {
        return Stack(
          children: [
            // Custom painter for relationships (draws lines)
            // It should be below the cards so lines don't overlap cards.
            Positioned.fill(
              child: CustomPaint(
                painter: RelationshipPainter(
                  persons: canvasState.persons,
                  relationships: canvasState.relationships,
                  // We need a way to get Person by ID for the painter
                  getPersonById: canvasState.getPersonById,
                ),
              ),
            ),
            // Display each person as a draggable card
            ...canvasState.persons.map((person) {
              // Each card is wrapped in a Draggable and Positioned
              return Positioned(
                left: person.position.dx,
                top: person.position.dy,
                child: Draggable<String>( // Dragging the person's ID
                  data: person.id,
                  feedback: Material( // Material wrap for proper theme & shadow during drag
                    elevation: 4.0,
                    child: PersonCardWidget(person: person),
                  ),
                  childWhenDragging: Opacity( // Make original less visible when dragging
                    opacity: 0.5,
                    child: PersonCardWidget(person: person),
                  ),
                  onDragEnd: (details) {
                    // Get the render box of the Stack to convert global drag offset to local
                    final stackRenderBox = context.findRenderObject() as RenderBox?;
                    if (stackRenderBox != null) {
                      final localOffset = stackRenderBox.globalToLocal(details.offset);
                      canvasState.updatePersonPosition(person.id, localOffset);
                    } else {
                       // Fallback or error if RenderBox not found, though unlikely here
                       canvasState.updatePersonPosition(person.id, details.offset);
                    }
                  },
                  child: PersonCardWidget(person: person),
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }
}

// Custom painter for drawing lines between related persons
class RelationshipPainter extends CustomPainter {
  final List<Person> persons;
  final List<Relationship> relationships;
  final Person? Function(String id) getPersonById; // Function to get person by ID

  RelationshipPainter({
    required this.persons,
    required this.relationships,
    required this.getPersonById,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueGrey // Default line color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    for (var relationship in relationships) {
      final person1 = getPersonById(relationship.personId1);
      final person2 = getPersonById(relationship.personId2);

      if (person1 != null && person2 != null) {
        // Calculate centers of the cards (assuming PersonCardWidget is 150x200)
        // The position in Person object is top-left.
        Offset center1 = Offset(person1.position.dx + 150 / 2, person1.position.dy + 200 / 2);
        Offset center2 = Offset(person2.position.dx + 150 / 2, person2.position.dy + 200 / 2);

        // Customize line color/style based on relationship type if needed
        if (relationship.type == RelationshipType.spouse) {
          paint.color = Colors.pinkAccent;
        } else if (relationship.type == RelationshipType.parent) {
          paint.color = Colors.green;
           // Could draw arrows for parent/child
        } else { // child
          paint.color = Colors.lightBlue;
        }

        canvas.drawLine(center1, center2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant RelationshipPainter oldDelegate) {
    // Repaint if persons or relationships change
    return oldDelegate.persons != persons || oldDelegate.relationships != relationships;
  }
}
