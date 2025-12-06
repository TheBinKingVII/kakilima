import 'package:dartz/dartz.dart';
import 'package:kakilima/core/failures/base_failure.dart';
import 'package:kakilima/core/user_role.dart';
import 'package:kakilima/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:kakilima/features/auth/data/models/auth_user_model.dart';
import 'package:kakilima/features/auth/data/models/profile_model.dart';
import 'package:kakilima/features/auth/domain/entities/auth_user_entity.dart';
import 'package:kakilima/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _datasource;

  AuthRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, AuthUserEntity>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _datasource.signInWithEmail(email, password);
      
      // Fetch profile data
      ProfileModel? profile;
      try {
        profile = await _datasource.getProfile(user.id);
      } catch (e) {
        // Profile might not exist yet, continue without it
      }

      final authUserModel = AuthUserModel.fromSupabaseUser(user, profile: profile);
      return Right(authUserModel.toEntity());
    } on Exception catch (e) {
      return Left(AuthFailure(e.toString()));
    } catch (e) {
      return Left(ServerFailure('Unexpected error during sign in: $e'));
    }
  }

  @override
  Future<Either<Failure, AuthUserEntity>> signUpWithEmail({
    required String email,
    required String password,
    required UserRole role,
    required String fullName,
    required String phone,
  }) async {
    try {
      final user = await _datasource.signUpWithEmail(
        email: email,
        password: password,
        role: role,
        fullName: fullName,
        phone: phone,
      );

      // Fetch profile data (should exist after signup trigger)
      ProfileModel? profile;
      try {
        // Wait a bit for the trigger to create the profile
        await Future.delayed(const Duration(milliseconds: 500));
        profile = await _datasource.getProfile(user.id);
      } catch (e) {
        // Profile might not exist yet, continue without it
      }

      final authUserModel = AuthUserModel.fromSupabaseUser(user, profile: profile);
      return Right(authUserModel.toEntity());
    } on Exception catch (e) {
      return Left(AuthFailure(e.toString()));
    } catch (e) {
      return Left(ServerFailure('Unexpected error during sign up: $e'));
    }
  }

  @override
  Future<Either<Failure, AuthUserEntity?>> getCurrentUser() async {
    try {
      final user = await _datasource.getCurrentUser();
      
      if (user == null) {
        return const Right(null);
      }

      // Fetch profile data
      ProfileModel? profile;
      try {
        profile = await _datasource.getProfile(user.id);
      } catch (e) {
        // Profile might not exist, continue without it
      }

      final authUserModel = AuthUserModel.fromSupabaseUser(user, profile: profile);
      return Right(authUserModel.toEntity());
    } on Exception catch (e) {
      return Left(AuthFailure(e.toString()));
    } catch (e) {
      return Left(ServerFailure('Unexpected error getting current user: $e'));
    }
  }

  

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _datasource.signOut();
      return const Right(null);
    } on Exception catch (e) {
      return Left(AuthFailure(e.toString()));
    } catch (e) {
      return Left(ServerFailure('Unexpected error during sign out: $e'));
    }
  }
}
