import 'package:flutter/material.dart';
import '../domain/user_repository.dart';
import '../data/user_repository_impl.dart';

class DashboardProvider with ChangeNotifier {
  final UserRepository _userRepository;

  DashboardProvider({UserRepository? userRepository})
      : _userRepository = userRepository ?? UserRepositoryImpl();

  Map<String, dynamic>? _userData;
  bool _isLoading = false;
  String? _errorMessage;

  Map<String, dynamic>? get userData => _userData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadUserData(String uid) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _userRepository.getUserData(uid);

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
      },
      (data) {
        _userData = data;
        _isLoading = false;
      },
    );
    notifyListeners();
  }
  
  // Method to save user data (used during signup)
  Future<bool> saveUserData(String uid, Map<String, dynamic> data) async {
    _isLoading = true; 
    notifyListeners(); 
    
    final result = await _userRepository.saveUserData(uid, data);
    
    bool success = false;
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        success = false;
      },
      (_) {
        success = true;
      },
    );
    
    _isLoading = false;
    notifyListeners();
    return success;
  }
}
