import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth to get current user
import 'package:flutter/material.dart';
import 'package:travel_mate/Widgets/custom_Button.dart';
import 'package:travel_mate/discover_utils/utils.dart';

Future<void> reviewDialog(BuildContext context, String documentId) async {
  TextEditingController reviewController = TextEditingController();

  // Get the current user's email
  final String? userEmail = FirebaseAuth.instance.currentUser?.email;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        titlePadding: const EdgeInsets.fromLTRB(10, 5, 5, 0),
        contentPadding: const EdgeInsets.all(15),
        actionsPadding: const EdgeInsets.only(right: 15, bottom: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        title: Stack(
          alignment: Alignment.center,
          children: [
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'Review',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.close_sharp),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 300,
          child: TextField(
            controller: reviewController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: "Enter your review",
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF57CC99)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            ),
          ),
        ),
        actions: [
          reusableElevatedButton(
            onPressed: () async {
              String reviewText = reviewController.text;

              try {
                // Ensure email is not null before adding the review
                if (userEmail != null) {
                  await addReview(documentId, reviewText, userEmail);
                  Navigator.of(context).pop();
                  print("Review added successfully!");
                } else {
                  print("User not logged in.");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text("You need to be logged in to submit a review."),
                    ),
                  );
                }
              } catch (e) {
                print("Failed to add review: $e");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Failed to submit review. Please try again."),
                  ),
                );
              }
            },
            text: 'Create',
          ),
        ],
      );
    },
  );
}
