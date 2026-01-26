import 'package:diet/features/auth/presentation/auth_provider.dart';
import 'package:diet/features/home/presentation/dashboard_provider.dart';
import 'package:diet/screens/welcome_animation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:diet/features/diet/presentation/providers/diet_provider.dart';
import 'package:diet/features/tracker/presentation/providers/tracker_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform specific options
  // Initialize Firebase with platform specific options
  try {
    await Firebase.initializeApp();
    print('DEBUG: Firebase initialized successfully');
  } catch (e) {
    print('DEBUG: Firebase initialization failed: $e');
    // Log error to crashlytics in production
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => DietProvider()),
        ChangeNotifierProvider(create: (_) => TrackerProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calorigram', // Updated title
      theme: ThemeData(
        brightness: Brightness.dark, // Set default brightness to dark for better foundation
        primaryColor: Colors.orange,
        scaffoldBackgroundColor: Color(0xff1a1a1a),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: Welcomeanimation(),
    );
  }
}
