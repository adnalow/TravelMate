import 'package:cloud_firestore/cloud_firestore.dart';

class Reviews {
  String id;
  String review;
  DateTime date;

  Reviews({
    required this.id,
    required this.review,
    required this.date,
  });

  // Factory constructor to create a Reviews object from JSON
  factory Reviews.fromJson(Map<String, dynamic> json) {
    return Reviews(
      id: json['id'],
      review: json['review'],
      date: (json['date'] as Timestamp).toDate(), // Assuming date is a Timestamp from Firebase
    );
  }

  // Method to convert Reviews object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'review': review,
      'date': Timestamp.fromDate(date), // Convert DateTime to Firebase Timestamp
    };
  }
}
