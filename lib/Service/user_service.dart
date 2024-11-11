import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  Future<String?> fetchUserIdByEmail(String email) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id; // Return the user ID (document ID)
      } else {
        print('No user found with the given email.');
        return null;
      }
    } catch (e) {
      print('Error fetching user ID: $e');
      return null;
    }
  }
}
