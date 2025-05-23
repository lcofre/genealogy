import 'package:flutter/material.dart'; // For Offset
import 'package:flutter_test/flutter_test.dart';
import 'package:visual_family_tree/models/person.dart';

void main() {
  group('Person', () {
    test('constructor assigns properties correctly', () {
      final person = Person(
        id: '1',
        name: 'John Doe',
        description: 'Father',
        position: Offset(10, 20),
        imagePath: 'assets/images/john.png',
      );

      expect(person.id, '1');
      expect(person.name, 'John Doe');
      expect(person.description, 'Father');
      expect(person.position, Offset(10, 20));
      expect(person.imagePath, 'assets/images/john.png');
    });

    test('default description is empty string if not provided', () {
      final person = Person(
        id: '2',
        name: 'Jane Doe',
        position: Offset(30, 40),
      );
      expect(person.description, '');
    });
  });
}
