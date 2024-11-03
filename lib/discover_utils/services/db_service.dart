import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_mate/discover_utils/models/featured_place.dart';

const String DB_COLLECTION_REF = "featured_place";

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late final CollectionReference<TravelmateDB> _featuredPlaceRef;

  DatabaseService() {
    _featuredPlaceRef = _firestore.collection(DB_COLLECTION_REF).withConverter<TravelmateDB>(
      fromFirestore: (snapshot, _) => TravelmateDB.fromJson(snapshot.data()!),
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

  

}
