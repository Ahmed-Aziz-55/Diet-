import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';

abstract class UserRepository {
  Future<Either<Failure, void>> saveUserData(String uid, Map<String, dynamic> data);
  Future<Either<Failure, Map<String, dynamic>>> getUserData(String uid);
}
