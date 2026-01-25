import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Add to AuthService class
  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if profile is complete
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(result.user!.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        bool profileComplete = userData['profileComplete'] ?? false;

        if (!profileComplete) {
          // Navigate to profile completion
          // You can handle this in your navigation logic
        }
      }

      return result.user;
    } catch (e) {
      print("Login Error: $e");
      throw e; // Re-throw for error handling in UI
    }
  }

  // Sign Up with Email & Password
  Future<User?> signUpWithEmailAndPassword(
      String email,
      String password,
      String username
      ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document in Firestore
      await _firestore.collection('users').doc(result.user!.uid).set({
        'uid': result.user!.uid,
        'email': email,
        'username': username,
        'createdAt': DateTime.now(),
        'profileComplete': false,
      });

      return result.user;
    } catch (e) {
      print("Sign Up Error: $e");
      return null;
    }
  }

  // Sign In with Email & Password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print("Sign In Error: $e");
      return null;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Check if user exists
  Stream<User?> get user {
    return _auth.authStateChanges();
  }
}