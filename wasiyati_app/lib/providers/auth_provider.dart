import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/firebase_auth_service.dart';

// ── Auth Service Provider ──────────────────────────────────────────────────
// Swap between FirebaseAuthService (real) and MockAuthService (tests)
final authServiceProvider = Provider<AuthService>((ref) {
  return FirebaseAuthService();
});

// ── Auth State Provider ────────────────────────────────────────────────────
// Tracks whether user is signed in and provides the current user
final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, AsyncValue<UserModel?>>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthStateNotifier(authService);
});

class AuthStateNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthService _authService;

  AuthStateNotifier(this._authService) : super(const AsyncValue.loading()) {
    // Listen to real-time auth state changes from Firebase
    _authService.authStateChanges().listen(
      (user) => state = AsyncValue.data(user),
      onError: (e, st) => state = AsyncValue.error(e, st),
    );
  }

  Future<void> signInWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authService.signInWithEmail(email, password);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signUpWithEmail(
      String email, String password, String name) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authService.signUpWithEmail(email, password, name);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      final user = await _authService.signInWithGoogle();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signInWithApple() async {
    state = const AsyncValue.loading();
    try {
      final user = await _authService.signInWithApple();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    state = const AsyncValue.data(null);
  }

  Future<void> sendPasswordReset(String email) async {
    await _authService.sendPasswordReset(email);
  }

  Future<void> checkIn() async {
    await _authService.checkIn();
  }

  Future<void> updateProfile({
    String? name,
    String? phone,
    String? photoUrl,
    String? language,
    String? country,
    String? securityPhraseHash,
  }) async {
    final currentState = state;
    try {
      final updated = await _authService.updateProfile(
        name: name,
        phone: phone,
        photoUrl: photoUrl,
        language: language,
        country: country,
        securityPhraseHash: securityPhraseHash,
      );
      state = AsyncValue.data(updated);
    } catch (e) {
      state = currentState; // Keep user logged in despite update error
      rethrow; // Rethrow to let the UI display the error toast
    }
  }
}

// ── Is Signed In Provider ──────────────────────────────────────────────────
final isSignedInProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.valueOrNull != null;
});

// ── Current User Provider (non-null, only valid when signed in) ────────────
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authStateProvider).valueOrNull;
});

// ── Is Premium Provider ────────────────────────────────────────────────────
final isPremiumProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.isPremium ?? false;
});
