import '../../../diet/data/models/meal_model.dart';
import '../../../diet/domain/entities/meal.dart';

import '../../domain/entities/daily_log.dart';

class DailyLogModel extends DailyLog {
  const DailyLogModel({
    required String id,
    required String userId,
    required DateTime date,
    required List<Meal> meals,
    required int totalCalories,
    required int totalProtein,
    required int totalCarbs,
    required int totalFats,
  }) : super(
          id: id,
          userId: userId,
          date: date,
          meals: meals,
          totalCalories: totalCalories,
          totalProtein: totalProtein,
          totalCarbs: totalCarbs,
          totalFats: totalFats,
        );

  factory DailyLogModel.fromMap(Map<String, dynamic> map, String id) {
    return DailyLogModel(
      id: id,
      userId: map['userId'] ?? '',
      date: DateTime.parse(map['date']),
      meals: List<MealModel>.from(
        (map['meals'] as List<dynamic>? ?? []).map<MealModel>(
          (x) => MealModel.fromMap(x as Map<String, dynamic>, ''),
        ),
      ),
      totalCalories: map['totalCalories']?.toInt() ?? 0,
      totalProtein: map['totalProtein']?.toInt() ?? 0,
      totalCarbs: map['totalCarbs']?.toInt() ?? 0,
      totalFats: map['totalFats']?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'date': date.toIso8601String(),
      'meals': meals.map((x) => (x as MealModel).toMap()).toList(),
      'totalCalories': totalCalories,
      'totalProtein': totalProtein,
      'totalCarbs': totalCarbs,
      'totalFats': totalFats,
    };
  }
}
