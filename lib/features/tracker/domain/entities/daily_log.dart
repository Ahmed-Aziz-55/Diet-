import '../../../diet/domain/entities/meal.dart';


class DailyLog {
  final String id;
  final String userId;
  final DateTime date;
  final List<Meal> meals;
  final int totalCalories;
  final int totalProtein;
  final int totalCarbs;
  final int totalFats;

  const DailyLog({
    required this.id,
    required this.userId,
    required this.date,
    required this.meals,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFats,
  });
}
