import 'package:flutter/material.dart';
import '../../domain/entities/daily_log.dart';
import '../../domain/repositories/tracker_repository.dart';
import '../../data/repositories/tracker_repository_impl.dart';
import '../../../diet/domain/entities/meal.dart';

class TrackerProvider with ChangeNotifier {
  final TrackerRepository _trackerRepository;

  TrackerProvider({TrackerRepository? trackerRepository})
      : _trackerRepository = trackerRepository ?? TrackerRepositoryImpl();

  DailyLog? _todayLog;
  bool _isLoading = false;
  String? _errorMessage;

  DailyLog? get todayLog => _todayLog;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadDailyLog(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _trackerRepository.getDailyLog(userId, DateTime.now());

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
      },
      (log) {
        _todayLog = log;
        _isLoading = false;
      },
    );
    notifyListeners();
  }

  Future<bool> addMeal(String userId, Meal meal) async {
    _isLoading = true;
    notifyListeners();

    final result = await _trackerRepository.addMeal(userId, DateTime.now(), meal);
    
    bool success = false;
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        success = false;
      },
      (_) {
        success = true;
        // Reload log to update UI
        loadDailyLog(userId);
      },
    );

    _isLoading = false;
    notifyListeners();
    return success;
  }
}
