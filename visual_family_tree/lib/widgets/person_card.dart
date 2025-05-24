import 'package:flutter/material.dart';
import '../models/person.dart'; // Assuming models are in visual_family_tree/lib/models/

class PersonCard extends StatelessWidget {
  final Person person;
  final bool isSelected; // New property for highlighting

  const PersonCard({
    Key? key,
    required this.person,
    this.isSelected = false, // Default to false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Card's elevation and shape are now primarily controlled by CardTheme in main.dart
    return Card(
      // elevation: 4.0, // Can be overridden if needed, but theme provides default
      // shape: RoundedRectangleBorder(...), // Theme provides default
      shape: RoundedRectangleBorder( // Still need to define shape here if we want the conditional border
        borderRadius: BorderRadius.circular(12.0), // Match theme or define specifically
        side: BorderSide(
          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[300],
              child: person.imagePath != null && person.imagePath!.isNotEmpty
                  ? ClipOval(child: Image.asset(person.imagePath!, fit: BoxFit.cover, width: 60, height: 60,))
                  : Icon(Icons.person, size: 30, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              person.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold), // Using theme typography
            ),
            SizedBox(height: 5),
            Text(
              person.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]), // Using theme typography
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
