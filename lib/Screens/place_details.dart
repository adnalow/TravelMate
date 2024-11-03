import 'package:flutter/material.dart';
import 'package:travel_mate/Screens/dialogbox_widget/add_review.dart';
import 'review_list.dart'; // Import the ReviewList widget

class DetailPage extends StatelessWidget {
  final String name;
  final String description;
  final String? imageUrl;
  final String id;

  const DetailPage({
    super.key,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (imageUrl != null)
                    Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                    )
                  else
                    const Icon(
                      Icons.image_not_supported,
                      size: 100,
                      color: Colors.grey,
                    ),
                  const SizedBox(height: 16),
                  Text(
                    name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Reviews",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 300, // Set a fixed height for the reviews section
                    child: ReviewList(documentId: id),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: () async {
                if (id.isNotEmpty) {
                  await reviewDialog(context, id);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("No valid document found to add a review."),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(350, 60),
                backgroundColor: Colors.green,
              ),
              child: const Text(
                'Write a Review',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
