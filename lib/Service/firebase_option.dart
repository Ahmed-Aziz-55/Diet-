// lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return FirebaseOptions(
      apiKey: 'AIzaSy...',  // Firebase Console se API key
      appId: '1:123456789012:android:abc123def456',  // App ID
      messagingSenderId: '123456789012',  // Sender ID
      projectId: 'diet-app-12345',  // Project ID
      storageBucket: 'diet-app-12345.appspot.com',  // Storage bucket
    );
  }
}