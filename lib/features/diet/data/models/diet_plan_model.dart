import '../../domain/entities/diet_plan.dart';
import '../../domain/entities/meal.dart';
import 'meal_model.dart';

class DietPlanModel extends DietPlan {
  const DietPlanModel({
    required String id,
    required String name,
    required String description,
    required int totalCalories,
    required List<Meal> meals,
    required String imageUrl,
  }) : super(
          id: id,
          name: name,
          description: description,
          totalCalories: totalCalories,
          meals: meals,
          imageUrl: imageUrl,
        );

  factory DietPlanModel.fromMap(Map<String, dynamic> map, String id) {
    return DietPlanModel(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      totalCalories: map['totalCalories']?.toInt() ?? 0,
      meals: List<MealModel>.from(
        (map['meals'] as List<dynamic>? ?? []).map<MealModel>(
          (x) => MealModel.fromMap(x as Map<String, dynamic>, ''),
        ),
      ),
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'totalCalories': totalCalories,
      'meals': meals.map((x) => (x as MealModel).toMap()).toList(),
      'imageUrl': imageUrl,
    };
  }
}
