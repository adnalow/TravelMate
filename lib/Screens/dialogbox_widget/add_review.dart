import 'package:flutter/material.dart';
import 'package:travel_mate/discover_utils/utils.dart';

Future<void> reviewDialog(BuildContext context, String documentId) async {
  TextEditingController reviewController = TextEditingController();

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: const Text("Review", textAlign: TextAlign.center),
        content: TextField(
          controller: reviewController,
          decoration: InputDecoration(
            hintText: "Enter your Review",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          maxLines: 4,
        ),
        actions: [
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () async {
                String reviewText = reviewController.text;
                print(reviewText);
                
                try {
                  // Call the updated function to add the review to Firestore
                  await addReview(documentId, reviewText);

                  Navigator.of(context).pop();
                  print("Review added successfully!");
                } catch (e) {
                  print("Failed to add review: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Failed to submit review. Please try again."),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
              child: const Text("Create", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      );
    },
  );
}
