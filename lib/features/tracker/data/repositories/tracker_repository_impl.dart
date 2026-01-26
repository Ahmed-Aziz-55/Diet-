import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../diet/data/models/meal_model.dart';
import '../../../diet/domain/entities/meal.dart';
import '../../domain/entities/daily_log.dart';
import '../../domain/repositories/tracker_repository.dart';
import '../models/daily_log_model.dart';

class TrackerRepositoryImpl implements TrackerRepository {
  final FirebaseFirestore _firestore;

  TrackerRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  String _getDateId(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Future<Either<Failure, DailyLog>> getDailyLog(String userId, DateTime date) async {
    try {
      final dateId = _getDateId(date);
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('daily_logs')
          .doc(dateId)
          .get();

      if (doc.exists) {
        return Right(DailyLogModel.fromMap(doc.data()!, doc.id));
      } else {
        // Return empty log if not exists
        return Right(DailyLog(
          id: dateId,
          userId: userId,
          date: date,
          meals: [],
          totalCalories: 0,
          totalProtein: 0,
          totalCarbs: 0,
          totalFats: 0,
        ));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addMeal(String userId, DateTime date, Meal meal) async {
    try {
      final dateId = _getDateId(date);
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('daily_logs')
          .doc(dateId);

      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);

        if (!snapshot.exists) {
           final newLog = DailyLogModel(
            id: dateId,
            userId: userId,
            date: date,
            meals: [meal],
            totalCalories: meal.calories,
            totalProtein: meal.protein,
            totalCarbs: meal.carbs,
            totalFats: meal.fats,
          );
          transaction.set(docRef, newLog.toMap());
        } else {
          final data = snapshot.data()!;
          List<dynamic> currentMeals = data['meals'] ?? [];
          currentMeals.add((meal as MealModel).toMap());

          transaction.update(docRef, {
            'meals': currentMeals,
            'totalCalories': FieldValue.increment(meal.calories),
            'totalProtein': FieldValue.increment(meal.protein),
            'totalCarbs': FieldValue.increment(meal.carbs),
            'totalFats': FieldValue.increment(meal.fats),
          });
        }
      });

      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeMeal(String userId, DateTime date, String mealId) async {
    // Implementation for removing meal if needed, keeping simple for now
    return Right(null);
  }
}
