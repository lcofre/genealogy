import 'dart:ui'; // Required for Offset

class Person {
  final String id;
  String name;
  String description;
  String? imagePath; // Can be nullable if no image is provided
  Offset position;

  Person({
    required this.id,
    required this.name,
    this.description = '',
    this.imagePath,
    required this.position,
  });
}
