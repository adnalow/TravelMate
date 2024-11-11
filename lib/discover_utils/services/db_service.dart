import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_mate/discover_utils/models/featured_place.dart';

const String DB_COLLECTION_REF = "featured_place";
const String userDB = "users";

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
        // Delete each document that matches the `id`
        for (var doc in querySnapshot.docs) {
          await doc.reference.delete();
          print("Document with id $id deleted successfully");
        }
      } else {
        print("No document found with id $id");
      }
    } catch (e) {
      print("Error deleting featured place: $e");
    }
  }
}
