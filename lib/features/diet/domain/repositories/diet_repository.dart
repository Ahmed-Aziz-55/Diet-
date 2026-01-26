import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/diet_plan.dart';


abstract class DietRepository {
  Future<Either<Failure, List<DietPlan>>> getDietPlans();
  Future<Either<Failure, DietPlan>> getDietPlanById(String id);
}
