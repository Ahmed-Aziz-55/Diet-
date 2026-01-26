import '../../domain/entities/meal.dart';

class MealModel extends Meal {
  const MealModel({
    required String id,
    required String name,
    required int calories,
    required int protein,
    required int carbs,
    required int fats,
    required String type,
    required String description,
  }) : super(
          id: id,
          name: name,
          calories: calories,
          protein: protein,
          carbs: carbs,
          fats: fats,
          type: type,
          description: description,
        );

  factory MealModel.fromMap(Map<String, dynamic> map, String id) {
    return MealModel(
      id: id,
      name: map['name'] ?? '',
      calories: map['calories']?.toInt() ?? 0,
      protein: map['protein']?.toInt() ?? 0,
      carbs: map['carbs']?.toInt() ?? 0,
      fats: map['fats']?.toInt() ?? 0,
      type: map['type'] ?? 'snack',
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'type': type,
      'description': description,
    };
  }
}
