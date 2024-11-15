import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:travel_mate/discover_utils/models/featured_place.dart';

const String DB_COLLECTION_REF = "featured_place";
const String userDB = "users";
const String reviewsDB = "reviews";

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  late final CollectionReference<TravelmateDB> _featuredPlaceRef;

  DatabaseService() {
    _featuredPlaceRef =
        _firestore.collection(DB_COLLECTION_REF).withConverter<TravelmateDB>(
              fromFirestore: (snapshot, _) =>
                  TravelmateDB.fromJson(snapshot.data()!),
              toFirestore: (featuredPlace, _) => featuredPlace.toJson(),
            );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getFeaturedPlaces() {
    return _firestore.collection(DB_COLLECTION_REF).snapshots();
  }

  Future<void> addFeaturedPlace(TravelmateDB travelmateDB) async {
    try {
      await _featuredPlaceRef.add(travelmateDB);
    } catch (e) {
      print("Error adding featured place: $e");
    }
  }

  Future<void> deleteFeaturedPlace(String id) async {
    try {
      // Query Firestore to find the document with the specified `id` field
      final querySnapshot = await _firestore
          .collection(DB_COLLECTION_REF)
          .where('id', isEqualTo: id)
          .get();

      // Check if a document with the given `id` exists
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          // Get the image URL from the document
          String imageUrl = doc['image_url'];

          // Delete the document from Firestore
          await doc.reference.delete();
          print("Document with id $id deleted successfully");

          // Delete the image from Firebase Storage
          if (imageUrl.isNotEmpty) {
            try {
              // Create a reference to the file to delete
              await _storage.refFromURL(imageUrl).delete();
              print("Image at $imageUrl deleted successfully");
            } catch (storageError) {
              print("Error deleting image from Storage: $storageError");
            }
          }

          // Delete associated reviews
          final reviewQuerySnapshot = await _firestore
              .collection(reviewsDB)
              .where('id', isEqualTo: id)
              .get();

          if (reviewQuerySnapshot.docs.isNotEmpty) {
            for (var reviewDoc in reviewQuerySnapshot.docs) {
              await reviewDoc.reference.delete();
              print("Review with id $id deleted successfully");
            }
          } else {
            print("No reviews found with id $id");
          }
        }
      } else {
        print("No document found with id $id");
      }
    } catch (e) {
      print("Error deleting featured place: $e");
    }
  }
}
