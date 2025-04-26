import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';

class UserProvider with ChangeNotifier {
  UserProfile? _userProfile;

  UserProfile? get userProfile => _userProfile;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> fetchUserProfile() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        final doc = await _firestore.collection('users').doc(userId).get();
        if (doc.exists) {
          _userProfile = UserProfile.fromMap(doc.data()!);
          notifyListeners();
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        await _firestore.collection('users').doc(userId).set(profile.toMap());
        _userProfile = profile;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }
}