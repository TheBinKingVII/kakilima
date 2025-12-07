import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kakilima/core/user_role.dart';
import 'package:kakilima/features/auth/data/models/profile_model.dart';

class AuthRemoteDatasource {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<User> signInWithEmail(String email, String password) async {
    try {
      // TESTING: Normalize email format to bypass validation issues
      final normalizedEmail = _normalizeEmailForTesting(email);
      
      final response = await _supabase.auth.signInWithPassword(
        email: normalizedEmail,
        password: password,
      );
      return response.user!;
    } catch (e) {
      // PROTOTYPING: Auto-confirm email if sign-in fails due to unconfirmed email
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('email') && 
          (errorString.contains('confirm') || 
           errorString.contains('not confirmed') ||
           errorString.contains('unconfirmed'))) {
        try {
          // Call database function to auto-confirm email
          final normalizedEmail = _normalizeEmailForTesting(email);
          await _supabase.rpc('auto_confirm_email', params: {'user_email': normalizedEmail});
          // Retry sign-in after confirming email
          final retryResponse = await _supabase.auth.signInWithPassword(
            email: normalizedEmail,
            password: password,
          );
          return retryResponse.user!;
        } catch (retryError) {
          throw Exception("Failed to sign in with email after auto-confirmation: $retryError");
        }
      }
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
      // TESTING: Normalize email format to bypass validation issues
      final normalizedEmail = _normalizeEmailForTesting(email);
      
      final response = await _supabase.auth.signUp(
        email: normalizedEmail,
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

  /// TESTING: Normalize email to ensure valid format
  /// Removes spaces, converts to lowercase, and ensures basic email format
  String _normalizeEmailForTesting(String email) {
    // Remove all spaces and convert to lowercase
    String normalized = email.trim().toLowerCase().replaceAll(' ', '');
    
    // If email doesn't contain @, add a default domain for testing
    if (!normalized.contains('@')) {
      normalized = '$normalized@test.com';
    }
    
    // If email doesn't have a domain after @, add default domain
    final parts = normalized.split('@');
    if (parts.length == 2 && parts[1].isEmpty) {
      normalized = '${parts[0]}@test.com';
    }
    
    // Ensure email has at least one character before @
    if (normalized.startsWith('@')) {
      normalized = 'test$normalized';
    }
    
    return normalized;
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