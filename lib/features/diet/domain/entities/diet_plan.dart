import 'meal.dart';

class DietPlan {
  final String id;
  final String name;
  final String description;
  final int totalCalories;
  final List<Meal> meals;
  final String imageUrl;

  const DietPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.totalCalories,
    required this.meals,
    required this.imageUrl,
  });
}
