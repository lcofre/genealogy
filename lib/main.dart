import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui'; // For Offset

import './canvas_state.dart';
import './canvas_widget.dart';
import './person_model.dart';

void main() {
  // Create an instance of CanvasState
  final canvasState = CanvasState();

  // Add some sample data for initial display
  final person1 = Person(id: 'p1', name: 'John Doe', description: 'Father', position: const Offset(50, 50));
  final person2 = Person(id: 'p2', name: 'Jane Doe', description: 'Mother', position: const Offset(250, 50));
  final person3 = Person(id: 'p3', name: 'Alice Doe', description: 'Daughter', position: const Offset(150, 250));

  canvasState.addPerson(person1);
  canvasState.addPerson(person2);
  canvasState.addPerson(person3);

  canvasState.addRelationship(person1.id, person2.id, RelationshipType.spouse);
  canvasState.addRelationship(person1.id, person3.id, RelationshipType.parent);
  canvasState.addRelationship(person2.id, person3.id, RelationshipType.parent);
  canvasState.addRelationship(person3.id, person1.id, RelationshipType.child); // Example child relationship
  canvasState.addRelationship(person3.id, person2.id, RelationshipType.child);


  runApp(
    ChangeNotifierProvider.value(
      value: canvasState, // Use .value constructor when instance is already created
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Family Tree Canvas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Scaffold(
        appBar: AppBar(
          title: Text('Family Tree Canvas'),
        ),
        body: CanvasWidget(),
      ),
      debugShowCheckedModeBanner: false, // Hides the debug banner
    );
  }
}
