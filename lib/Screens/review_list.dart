import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ReviewList extends StatelessWidget {
  final String documentId;

  const ReviewList({
    super.key,
    required this.documentId,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('reviews')
          .where('id', isEqualTo: documentId)
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        // Check for connection states
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Check if there's an error
        if (snapshot.hasError) {
          return const Center(child: Text("An error occurred. Please try again."));
        }

        // Check if the snapshot has data and is not empty
        if (snapshot.hasData && snapshot.data != null) {
          final reviews = snapshot.data!.docs;
          
          if (reviews.isEmpty) {
            return const Center(child: Text("No reviews yet."));
          }

          // Build the list of reviews
          return ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final reviewData = reviews[index];
              final reviewText = reviewData['review'];
              final reviewDate = (reviewData['date'] as Timestamp).toDate();
              final formattedDate = DateFormat.yMMMd().format(reviewDate);

              return ListTile(
                title: Text(reviewText),
                subtitle: Text(formattedDate),
                leading: const Icon(Icons.comment, color: Colors.green),
              );
            },
          );
        }

        // Default case when there's no data available
        return const Center(child: Text("No data available."));
      },
    );
  }
}
