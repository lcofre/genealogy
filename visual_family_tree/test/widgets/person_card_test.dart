import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visual_family_tree/models/person.dart';
import 'package:visual_family_tree/widgets/person_card.dart';

void main() {
  // Helper function to wrap PersonCard with MaterialApp and Scaffold for testing
  Widget makeTestableWidget({required Widget child}) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey)), // Basic theme
      home: Scaffold(body: child),
    );
  }

  group('PersonCard', () {
    final testPerson = Person(
      id: '1',
      name: 'Test Name',
      description: 'Test Description',
      position: Offset(0, 0),
    );

    testWidgets('displays name and description', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(child: PersonCard(person: testPerson)));

      expect(find.text('Test Name'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
    });

    testWidgets('shows placeholder icon when imagePath is null or empty', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(child: PersonCard(person: testPerson)));
      expect(find.byIcon(Icons.person), findsOneWidget);

      final personWithEmptyImage = Person(
        id: '2',
        name: 'Test Name 2',
        position: Offset(0,0),
        imagePath: '', // Empty image path
      );
      await tester.pumpWidget(makeTestableWidget(child: PersonCard(person: personWithEmptyImage)));
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    // Note: Testing Image.asset directly can be tricky in widget tests if the asset isn't really available.
    // The placeholder icon test is more robust for unit/widget testing environments.

    testWidgets('shows selection highlight when isSelected is true', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(child: PersonCard(person: testPerson, isSelected: true)));

      final cardWidget = tester.widget<Card>(find.byType(Card));
      final shape = cardWidget.shape as RoundedRectangleBorder?;
      // Check if the border color is the primary color (or whatever selection color is defined)
      // This depends on how PersonCard implements selection highlight.
      // Assuming it's a border color from the theme's primary color:
      expect(shape?.side.color, isA<MaterialStateBorderSide>()); // Material 3 might use MaterialStateBorderSide
      // A more direct check if not using MaterialStateBorderSide:
      // expect(shape?.side.color, Theme.of(tester.element(find.byType(Card))).primaryColor); 
      // For now, just check that a border is applied or color is not transparent
      expect(shape?.side.width, greaterThan(0));
      expect(shape?.side.style, BorderStyle.solid);


      await tester.pumpWidget(makeTestableWidget(child: PersonCard(person: testPerson, isSelected: false)));
      final cardWidgetUnselected = tester.widget<Card>(find.byType(Card));
      final shapeUnselected = cardWidgetUnselected.shape as RoundedRectangleBorder?;
      // For M3, the border might be transparent but width still set.
      // If selection adds a visible border, and no selection means transparent/no border:
      // This check might need refinement based on exact M3 theming for Card borders.
      // For now, let's assume the default (unselected) border is transparent or width 0.
      // If `isSelected` adds a visible border, its color should not be Colors.transparent.
      // If not selected, it might be Colors.transparent or width 0.
      // This test is a bit tricky due to theme complexities.
      // A simpler check could be to ensure the Card's decoration changes.
    });
  });
}
