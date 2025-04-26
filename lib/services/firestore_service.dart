import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createOrUpdateProfile(String userId, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(userId).set(data);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchProfile(String userId) {
    return _firestore.collection('users').doc(userId).get();
  }
}