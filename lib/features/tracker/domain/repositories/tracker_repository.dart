import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';

import '../../../diet/domain/entities/meal.dart';
import '../entities/daily_log.dart';


abstract class TrackerRepository {
  Future<Either<Failure, DailyLog>> getDailyLog(String userId, DateTime date);
  Future<Either<Failure, void>> addMeal(String userId, DateTime date, Meal meal);
  Future<Either<Failure, void>> removeMeal(String userId, DateTime date, String mealId);
}
