import 'package:dartz/dartz.dart';
import 'package:kakilima/core/failures/base_failure.dart';
import 'package:kakilima/core/user_role.dart';
import 'package:kakilima/features/auth/domain/entities/auth_user_entity.dart';

abstract class AuthRepository {
  /// Sign in with email and password
  /// Returns [AuthUserEntity] on success, [Failure] on error
  Future<Either<Failure, AuthUserEntity>> signInWithEmail({
    required String email,
    required String password,
  });

  /// Sign up with email and password
  /// Returns [AuthUserEntity] on success, [Failure] on error
  Future<Either<Failure, AuthUserEntity>> signUpWithEmail({
    required String email,
    required String password,
    required UserRole role,
    required String fullName,
    required String phone,
  });

  /// Get the current authenticated user
  /// Returns [AuthUserEntity] if logged in, null if not authenticated
  Future<Either<Failure, AuthUserEntity?>> getCurrentUser();

  // Map User to AuthUserEntity

  /// Sign out the current user
  /// Returns void on success, [Failure] on error
  Future<Either<Failure, void>> signOut();
}
