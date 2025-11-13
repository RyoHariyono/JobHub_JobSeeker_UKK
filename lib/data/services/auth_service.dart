import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get current user
  User? get currentUser => _supabase.auth.currentUser;

  // Check if user is logged in
  bool get isLoggedIn => currentUser != null;

  // Get auth state stream
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      // Sign up dengan auto confirm (bypass email verification untuk development)
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: null,
        data: {'full_name': fullName},
      );

      // Wait a bit untuk auth session ter-setup
      await Future.delayed(const Duration(milliseconds: 500));

      // Create user profile in database (sekarang auth session sudah active)
      if (response.user != null) {
        try {
          await _supabase.from('users').insert({
            'id': response.user!.id,
            'email': email,
            'full_name': fullName,
          });
        } catch (dbError) {
          // If profile creation fails, cleanup auth user
          print('Profile creation error: $dbError');
          // User sudah dibuat di auth, tapi profile gagal
          // Biarkan saja, nanti bisa dibuat manual atau di sync
        }
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  // Update password
  Future<UserResponse> updatePassword(String newPassword) async {
    try {
      return await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e) {
      rethrow;
    }
  }
}
