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
            return const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  "No reviews yet.",
                  style: TextStyle(fontSize: 16, color: Color(0xFF808080)),
                ),
              ),
            );
          }
          
          // Replace ListView.builder with a Column to avoid height issues
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int index = 0; index < reviews.length; index++) ...[
                Text(
                  reviews[index]['review'],
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  DateFormat.yMMMd().format(
                      (reviews[index]['date'] as Timestamp).toDate(),
                  ),
                  style: const TextStyle(color: Color(0xFF808080)),
                ),
                if (index < reviews.length - 1) const Divider(thickness: 0.5),
              ],
            ],
          );
        }

        // Default case when there's no data available
        return const Center(child: Text("No data available."));
      },
    );
  }
}
