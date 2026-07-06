import 'package:dartz/dartz.dart';
import 'package:travelmateai/core/errors/failures.dart';
import 'package:travelmateai/features/auth/domain/entities/app_user.dart';

/// Auth repository contract (domain layer).
abstract class AuthRepository {
  Stream<AppUser?> get authStateChanges;
  AppUser? get currentUser;

  Future<Either<Failure, AppUser>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, AppUser>> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  });

  Future<Either<Failure, AppUser>> signInWithGoogle();
  Future<Either<Failure, AppUser>> signInAnonymously();
  Future<Either<Failure, void>> sendPasswordResetEmail(String email);
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, void>> deleteAccount();
}
