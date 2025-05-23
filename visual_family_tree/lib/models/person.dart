import 'package:flutter/foundation.dart'; // For Offset
import 'package:flutter/material.dart'; // For Offset, if not using foundation

class Person {
  String id;
  String name;
  String description;
  String? imagePath; // Nullable if image is optional
  Offset position;

  Person({
    required this.id,
    required this.name,
    this.description = '',
    this.imagePath,
    required this.position,
  });
}
