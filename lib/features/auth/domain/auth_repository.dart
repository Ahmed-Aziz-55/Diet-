import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Stream<User?> get authStateChanges;
  User? get currentUser;
  Future<Either<Failure, UserCredential>> signIn(String email, String password);
  Future<Either<Failure, UserCredential>> signUp(String email, String password);
  Future<Either<Failure, void>> signOut();
}
