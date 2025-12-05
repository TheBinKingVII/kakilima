import 'package:dartz/dartz.dart';
import 'package:kakilima/core/failures/base_failure.dart';
import 'package:kakilima/features/auth/domain/entities/auth_user_entity.dart';
import 'package:kakilima/features/auth/domain/repositories/auth_repository.dart';
import 'package:kakilima/core/user_role.dart';

class AuthUsecase
{
  final AuthRepository _authRepository;

  AuthUsecase(this._authRepository);

  Future<Either<Failure, AuthUserEntity>> vendorSignInWithEmail({
    required String email,
    required String password,
  }) async {
    return _authRepository.signInWithEmail(email: email, password: password);
  }

  Future<Either<Failure, AuthUserEntity>> customerSignInWithEmail({
    required String email,
    required String password
  }) async {
    return _authRepository.signInWithEmail(email: email, password: password);
  }

  Future<Either<Failure, AuthUserEntity>> vendorSignUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    return _authRepository.signUpWithEmail(email: email, password: password, role: UserRole.vendor, fullName: fullName, phone: phone);
  }

  Future<Either<Failure, AuthUserEntity>> customerSignUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    return _authRepository.signUpWithEmail(email: email, password: password, role: UserRole.customer, fullName: fullName, phone: phone);
  }

  Future<Either<Failure, AuthUserEntity?>> getCurrentUser() async {
    return _authRepository.getCurrentUser();
  }

  Future<Either<Failure, void>> signOut() async {
    return _authRepository.signOut();
  }
  
}
