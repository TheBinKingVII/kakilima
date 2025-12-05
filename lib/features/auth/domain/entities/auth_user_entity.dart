import 'package:equatable/equatable.dart';
import 'package:kakilima/core/user_role.dart';

class AuthUserEntity extends Equatable {
  final String id;
  final String? email;
  final String? phone;
  final DateTime? emailConfirmedAt;
  final DateTime? lastSignInAt;
  final UserRole role;
  final String? fullName;
  final DateTime? createdAt;

  const AuthUserEntity({
    required this.id,
    this.email,
    this.phone,
    this.emailConfirmedAt,
    this.lastSignInAt,
    required this.role,
    this.fullName,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        phone,
        emailConfirmedAt,
        lastSignInAt,
        role,
        fullName,
        createdAt,
      ];

  bool get isVendor => role == UserRole.vendor;
  bool get isCustomer => role == UserRole.customer;
}
