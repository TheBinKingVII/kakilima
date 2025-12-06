import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kakilima/core/user_role.dart';
import 'package:kakilima/features/auth/data/models/profile_model.dart';

class AuthRemoteDatasource {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<User> signInWithEmail(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.user!;
    } catch (e) {
      throw Exception("Failed to sign in with email: $e");
    }
  }

  Future<User> signUpWithEmail({
    required String email,
    required String password,
    UserRole role = UserRole.customer,
    required String fullName,
    required String phone,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'role': role.value,
          'full_name': fullName,
          'phone': phone,
        },
      );
      return response.user!;
    } catch (e) {
      throw Exception('Failed to sign up with email: $e');
    }
  }


  Future<User?> getCurrentUser() async {
    try {
      return _supabase.auth.currentUser;
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }
  // TODO: Move to Use Case

  Future<ProfileModel?> getProfile(String userId) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return ProfileModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }
}