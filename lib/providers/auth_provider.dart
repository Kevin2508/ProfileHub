import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final SharedPreferences _prefs;

  UserModel? _user;
  bool _isLoading = false;

  AuthProvider(this._prefs);

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _auth.currentUser != null;

  Future<void> checkCurrentUser() async {
    _isLoading = true;
    notifyListeners();

    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      _user = UserModel(
        uid: currentUser.uid,
        email: currentUser.email ?? '',
        displayName: currentUser.displayName,
        photoUrl: currentUser.photoURL,
      );

      // Check if user exists in Firestore, if not create entry
      await _createUserInFirestoreIfNeeded(currentUser);

      await _prefs.setBool('isLoggedIn', true);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        _user = UserModel(
          uid: userCredential.user!.uid,
          email: userCredential.user!.email ?? '',
          displayName: userCredential.user!.displayName,
          photoUrl: userCredential.user!.photoURL,
        );

        // Check if user exists in Firestore, if not create entry
        await _createUserInFirestoreIfNeeded(userCredential.user!);

        await _prefs.setBool('isLoggedIn', true);
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      _isLoading = true;
      notifyListeners();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        _user = UserModel(
          uid: userCredential.user!.uid,
          email: userCredential.user!.email ?? '',
          displayName: userCredential.user!.displayName,
          photoUrl: userCredential.user!.photoURL,
        );

        // Check if user exists in Firestore, if not create entry
        await _createUserInFirestoreIfNeeded(userCredential.user!);

        await _prefs.setBool('isLoggedIn', true);
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Create user document in Firestore if it doesn't exist
  Future<void> _createUserInFirestoreIfNeeded(User firebaseUser) async {
    // Reference to Firestore collection
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .get();

    if (!userDoc.exists) {
      // If user doesn't exist in Firestore, create a new document
      final now = DateTime.now();
      final String memberSince = '${_getMonthName(now.month)} ${now.year}';

      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .set({
        'uid': firebaseUser.uid,
        'email': firebaseUser.email ?? '',
        'username': firebaseUser.displayName ?? 'User',
        'photoUrl': firebaseUser.photoURL ?? '',
        'memberSince': memberSince,
        'phone': '',
        'address': '',
        'website': '',
        'aboutMe': 'Flutter developer with a passion for creating beautiful and functional mobile applications.',
        'createdAt': Timestamp.now(),
      });
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await _prefs.setBool('isLoggedIn', false);
    _user = null;
    notifyListeners();
  }
}