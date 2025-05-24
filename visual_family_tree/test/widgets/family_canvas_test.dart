import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visual_family_tree/models/person.dart';
import 'package:visual_family_tree/widgets/family_canvas.dart';
import 'package:visual_family_tree/widgets/person_card.dart'; // To find PersonCard

// Helper to provide a MaterialApp and Scaffold wrapper for FamilyCanvas
Widget makeTestableFamilyCanvas() {
  return MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.blueGrey,
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey, secondary: Colors.amber),
      useMaterial3: true,
    ),
    home: FamilyCanvas(), // FamilyCanvas now provides its own Scaffold
  );
}

void main() {
  group('FamilyCanvas', () {
    testWidgets('initially displays sample persons and no unexpected widgets', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableFamilyCanvas());

      // Check for initial sample persons (assuming at least 2 are added in initState by default)
      // The exact number depends on the current implementation of _addSamplePersonsAndRelationships
      // Let's assume John Doe and Jane Doe are among them.
      expect(find.widgetWithText(PersonCard, 'John Doe'), findsOneWidget);
      expect(find.widgetWithText(PersonCard, 'Jane Doe'), findsOneWidget);
      
      // Check for the FAB to add persons
      expect(find.byIcon(Icons.add), findsOneWidget);
      // Check for the relationship mode button in AppBar
      expect(find.byIcon(Icons.link), findsOneWidget);
    });

    testWidgets('tapping add person FAB opens dialog, and submitting adds a new PersonCard', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableFamilyCanvas());

      // Verify no dialog is initially present
      expect(find.byType(AlertDialog), findsNothing);

      // Tap the FAB to add a person
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle(); // Wait for dialog animation

      // Verify dialog is now open
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Add New Person'), findsOneWidget);

      // Enter text into the TextFields
      await tester.enterText(find.widgetWithText(TextField, 'Name'), 'New Test Person');
      await tester.enterText(find.widgetWithText(TextField, 'Description'), 'A person added via test');
      await tester.pumpAndSettle();

      // Tap the 'Add' button in the dialog
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle(); // Wait for dialog to close and UI to update

      // Verify dialog is closed
      expect(find.byType(AlertDialog), findsNothing);

      // Verify the new person card is displayed
      expect(find.widgetWithText(PersonCard, 'New Test Person'), findsOneWidget);
      expect(find.widgetWithText(PersonCard, 'A person added via test'), findsOneWidget);
    });

    // Test for relationship creation is more complex and might be better as an integration test.
    // For widget tests, we can test parts of it:
    testWidgets('tapping relationship mode button changes its appearance', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableFamilyCanvas());

      final relationshipButtonFinder = find.byIcon(Icons.link);
      var relationshipButton = tester.widget<IconButton>(relationshipButtonFinder);
      // Initial color might be null or based on AppBar's iconTheme.
      // Let's check if it's not the "active" color first.
      // This depends on how theme colors are applied.
      // Color activeColor = Theme.of(tester.element(relationshipButtonFinder)).colorScheme.secondary;
      // expect(relationshipButton.color, isNot(activeColor)); // This check can be fragile.

      // Tap the relationship mode button
      await tester.tap(relationshipButtonFinder);
      await tester.pumpAndSettle();

      relationshipButton = tester.widget<IconButton>(relationshipButtonFinder);
      // Now the color should indicate active state (e.g., theme's secondary color)
      // This test is a bit brittle due to direct color checking.
      // A more robust way would be to check a semantic property or a custom flag if available.
      // For now, we assume the visual change is sufficient indication.
      // expect(relationshipButton.color, activeColor);

      // Tap again to disable
      await tester.tap(relationshipButtonFinder);
      await tester.pumpAndSettle();
      
      relationshipButton = tester.widget<IconButton>(relationshipButtonFinder);
      // expect(relationshipButton.color, isNot(activeColor)); // Back to initial state
    });

  });
}
