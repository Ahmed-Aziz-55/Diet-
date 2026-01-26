import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/diet_plan.dart';
import '../../domain/repositories/diet_repository.dart';
import '../models/diet_plan_model.dart';

class DietRepositoryImpl implements DietRepository {
  final FirebaseFirestore _firestore;

  DietRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Either<Failure, List<DietPlan>>> getDietPlans() async {
    try {
      final snapshot = await _firestore.collection('diet_plans').get();
      final plans = snapshot.docs
          .map((doc) => DietPlanModel.fromMap(doc.data(), doc.id))
          .toList();
      return Right(plans);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DietPlan>> getDietPlanById(String id) async {
    try {
      final doc = await _firestore.collection('diet_plans').doc(id).get();
      if (doc.exists) {
        return Right(DietPlanModel.fromMap(doc.data()!, doc.id));
      } else {
        return Left(ServerFailure('Diet plan not found'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
