import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../domain/auth_repository.dart';
import '../data/auth_repository_impl.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository;

  AuthProvider({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepositoryImpl();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _authRepository.currentUser;

  Future<bool> signIn(String email, String password) async {
    print('DEBUG: Start signIn for $email');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authRepository.signIn(email, password);

      bool success = false;
      result.fold(
        (failure) {
          print('DEBUG: signIn failed: ${failure.message}');
          _errorMessage = failure.message;
          success = false;
        },
        (userCredential) {
          print('DEBUG: signIn success: ${userCredential.user?.uid}');
          success = true;
          // _authRepository.currentUser should be updated by the repository or we can fetch it.
          // Assuming repository updates the user state or we rely on stream,
          // but for immediate UI check we can rely on return value.
        },
      );
      return success;
    } catch (e) {
      print('DEBUG: signIn exception: $e');
      _errorMessage = 'An unexpected error occurred: $e';
      return false;
    } finally {
      _isLoading = false;
      print('DEBUG: End signIn, isLoading set to false');
      notifyListeners();
    }
  }

  Future<bool> signUp(String email, String password) async {
    print('DEBUG: Start signUp for $email');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authRepository.signUp(email, password);

      bool success = false;
      result.fold(
        (failure) {
          print('DEBUG: signUp failed: ${failure.message}');
          _errorMessage = failure.message;
          success = false;
        },
        (userCredential) {
          print('DEBUG: signUp success: ${userCredential.user?.uid}');
          success = true;
        },
      );
      return success;
    } catch (e) {
      print('DEBUG: signUp exception: $e');
      _errorMessage = 'An unexpected error occurred: $e';
      return false;
    } finally {
      _isLoading = false;
      print('DEBUG: End signUp, isLoading set to false');
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    print('DEBUG: Start signOut');
    try {
      await _authRepository.signOut();
    } catch (e) {
      print('DEBUG: signOut exception: $e');
    } finally {
      print('DEBUG: End signOut');
      notifyListeners();
    }
  }
}
