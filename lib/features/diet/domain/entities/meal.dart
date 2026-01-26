class Meal {
  final String id;
  final String name;
  final int calories;
  final int protein;
  final int carbs;
  final int fats;
  final String type; // breakfast, lunch, dinner, snack
  final String description;

  const Meal({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.type,
    required this.description,
  });
}
