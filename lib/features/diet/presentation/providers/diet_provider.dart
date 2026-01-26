import 'package:flutter/material.dart';
import '../../domain/entities/diet_plan.dart';
import '../../domain/repositories/diet_repository.dart';
import '../../data/repositories/diet_repository_impl.dart';

class DietProvider with ChangeNotifier {
  final DietRepository _dietRepository;

  DietProvider({DietRepository? dietRepository})
      : _dietRepository = dietRepository ?? DietRepositoryImpl();

  List<DietPlan> _dietPlans = [];
  DietPlan? _selectedPlan;
  bool _isLoading = false;
  String? _errorMessage;

  List<DietPlan> get dietPlans => _dietPlans;
  DietPlan? get selectedPlan => _selectedPlan;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadDietPlans() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _dietRepository.getDietPlans();

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
      },
      (plans) {
        _dietPlans = plans;
        _isLoading = false;
      },
    );
    notifyListeners();
  }

  void selectPlan(DietPlan plan) {
    _selectedPlan = plan;
    notifyListeners();
  }
}
