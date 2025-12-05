import 'package:equatable/equatable.dart';
import 'package:kakilima/core/user_role.dart';

class ProfileModel extends Equatable {
  final String id;
  final UserRole role;
  final String? fullName;
  final String? phone;
  final DateTime createdAt;

  const ProfileModel({
    required this.id,
    required this.role,
    this.fullName,
    this.phone,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, role, fullName, phone, createdAt];

  // Convert from JSON (Supabase profiles table)
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      role: UserRoleExtension.fromValue(json['role'] as String? ?? 'customer'),
      fullName: json['full_name'] as String?,
      phone: json['phone'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  // Convert to JSON (for Supabase inserts/updates)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role.value,
      'full_name': fullName,
      'phone': phone,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Convert to JSON for Supabase insert (exclude id and created_at for inserts)
  Map<String, dynamic> toJsonForInsert() {
    return {
      'role': role.value,
      'full_name': fullName,
      'phone': phone,
    };
  }

  // Convert to JSON for Supabase update (exclude id and created_at)
  Map<String, dynamic> toJsonForUpdate() {
    return {
      'role': role.value,
      'full_name': fullName,
      'phone': phone,
    };
  }

  // Create a copy with updated fields
  ProfileModel copyWith({
    String? id,
    UserRole? role,
    String? fullName,
    String? phone,
    DateTime? createdAt,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      role: role ?? this.role,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

