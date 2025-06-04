import 'package:flutter/material.dart';
import './person_model.dart'; // Assuming person_model.dart is in the same lib directory

class PersonCardWidget extends StatelessWidget {
  final Person person;

  const PersonCardWidget({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 200,
      child: Card(
        elevation: 4.0,
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Image placeholder/display
              (person.imagePath != null && person.imagePath!.isNotEmpty)
                  ? Image.network(
                      person.imagePath!,
                      height: 80, // Fixed height for the image area
                      width: double.infinity,
                      fit: BoxFit.cover,
                      // Error builder for network image
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 80);
                      },
                      // Loading builder for network image
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    )
                  : const Icon(Icons.person, size: 80), // Placeholder if no image
              const SizedBox(height: 8),
              // Name
              Text(
                person.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // Description
              Expanded(
                child: Text(
                  person.description,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
