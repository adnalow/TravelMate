import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> signInUserAnon() async {
  try {
    final userCredential = await FirebaseAuth.instance.signInAnonymously();
    print("Signed in with temporary account. UID: ${userCredential.user?.uid}");
  } catch (e) {
    print(e);
  }
}

Future<File?> getImageFromGallery(BuildContext context) async {
  final ImagePicker picker = ImagePicker();
  try {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return File(image.path); // Return the selected image file
    }
  } catch (e) {
    print(e); // Handle any errors that occur during the picking process
  }
  return null; // Return null if no image was selected
}

Future<String?> uploadFileForUser(File file) async {
  try {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final storageRef = FirebaseStorage.instance.ref();
    final fileName = file.path.split("/").last;
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final uploadRef = storageRef.child("$userId/uploads/$timestamp-$fileName");
    await uploadRef.putFile(file);

    // Get the download URL of the uploaded file
    String downloadURL = await uploadRef.getDownloadURL();
    return downloadURL;
  } catch (e) {
    print("Error uploading file: $e");
  }
  return null; // Return null if upload fails
}

String generateId(int length) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  Random rnd = Random();
  return List.generate(length, (index) => chars[rnd.nextInt(chars.length)]).join();
}

// Function to add a review with date to Firestore
Future<void> addReview(String documentId, String reviewText) async {
  // Get the current date and time
  DateTime currentDate = DateTime.now();

  // Reference to the Firestore collection 'reviews'
  CollectionReference reviewsCollection = FirebaseFirestore.instance.collection('reviews');

  try {
    // Add a new document with review, date, and documentId (link to TravelmateDB)
    await reviewsCollection.add({
      'id': documentId, // Link to the associated TravelmateDB entry
      'review': reviewText,
      'date': Timestamp.fromDate(currentDate),
    });

    print("Review added with date successfully!");
  } catch (e) {
    print("Error adding review: $e");
    throw e;
  }
}

