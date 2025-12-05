import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kakilima/core/user_role.dart';
import 'package:kakilima/features/auth/domain/entities/auth_user_entity.dart';
import 'package:kakilima/features/auth/data/models/profile_model.dart';

class AuthUserModel extends Equatable {
  final String id;
  final String? email;
  final String? phone;
  final DateTime? emailConfirmedAt;
  final DateTime? lastSignInAt;
  final ProfileModel? profile;

  const AuthUserModel({
    required this.id,
    this.email,
    this.phone,
    this.emailConfirmedAt,
    this.lastSignInAt,
    this.profile,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        phone,
        emailConfirmedAt,
        lastSignInAt,
        profile,
      ];

  // Convert from Supabase User
  factory AuthUserModel.fromSupabaseUser(User user, {ProfileModel? profile}) {
    DateTime? parseDateTime(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return value;
      if (value is String) return DateTime.tryParse(value);
      return null;
    }

    return AuthUserModel(
      id: user.id,
      email: user.email,
      phone: user.phone,
      emailConfirmedAt: parseDateTime(user.emailConfirmedAt),
      lastSignInAt: parseDateTime(user.lastSignInAt),
      profile: profile,
    );
  }

  // Convert from JSON (for API responses)
  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      emailConfirmedAt: json['email_confirmed_at'] != null
          ? DateTime.parse(json['email_confirmed_at'] as String)
          : null,
      lastSignInAt: json['last_sign_in_at'] != null
          ? DateTime.parse(json['last_sign_in_at'] as String)
          : null,
      profile: json['profile'] != null
          ? ProfileModel.fromJson(json['profile'] as Map<String, dynamic>)
          : null,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'email_confirmed_at': emailConfirmedAt?.toIso8601String(),
      'last_sign_in_at': lastSignInAt?.toIso8601String(),
      'profile': profile?.toJson(),
    };
  }

  // Convert to domain entity
  AuthUserEntity toEntity() {
    return AuthUserEntity(
      id: id,
      email: email,
      phone: phone,
      emailConfirmedAt: emailConfirmedAt,
      lastSignInAt: lastSignInAt,
      role: profile?.role ?? UserRole.customer,
      fullName: profile?.fullName,
      createdAt: profile?.createdAt,
    );
  }

  // Create from entity (useful for testing)
  factory AuthUserModel.fromEntity(AuthUserEntity entity) {
    return AuthUserModel(
      id: entity.id,
      email: entity.email,
      phone: entity.phone,
      emailConfirmedAt: entity.emailConfirmedAt,
      lastSignInAt: entity.lastSignInAt,
      profile: entity.createdAt != null
          ? ProfileModel(
              id: entity.id,
              role: entity.role,
              fullName: entity.fullName,
              phone: entity.phone,
              createdAt: entity.createdAt!,
            )
          : null,
    );
  }
}
