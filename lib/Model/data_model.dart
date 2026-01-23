// Create a new file: user_data_model.dart
class UserData {
  String? gender;
  double? height; // in cm
  double? weight; // in kg
  DateTime? birthDate;
  int? age;
  String? username;
  String? goal; // weight gain, loss, maintain
  String? activityLevel;
  double? dailyCalories;

  UserData({
    this.gender,
    this.height,
    this.weight,
    this.birthDate,
    this.age,
    this.username,
    this.goal,
    this.activityLevel,
    this.dailyCalories,
  });

  // Convert to Map for saving to SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'gender': gender,
      'height': height,
      'weight': weight,
      'birthDate': birthDate?.toIso8601String(),
      'age': age,
      'username': username,
      'goal': goal,
      'activityLevel': activityLevel,
      'dailyCalories': dailyCalories,
    };
  }

  // Create from Map
  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      gender: map['gender'],
      height: map['height'],
      weight: map['weight'],
      birthDate: map['birthDate'] != null
          ? DateTime.parse(map['birthDate'])
          : null,
      age: map['age'],
      username: map['username'],
      goal: map['goal'],
      activityLevel: map['activityLevel'],
      dailyCalories: map['dailyCalories'],
    );
  }
}