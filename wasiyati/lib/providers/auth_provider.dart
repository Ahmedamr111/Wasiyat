import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../data/mock_data.dart';

// ── Auth Service Provider ──
final authServiceProvider = Provider<AuthService>((ref) {
  return MockAuthService();
});

// ── Auth State Provider ──
// Tracks whether user is signed in and provides the current user
final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, AsyncValue<UserModel?>>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthStateNotifier(authService);
});

class AuthStateNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthService _authService;

  AuthStateNotifier(this._authService) : super(const AsyncValue.data(null)) {
    // Listen to auth state changes
    _authService.authStateChanges().listen((user) {
      state = AsyncValue.data(user);
    });
  }

  Future<void> signInWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authService.signInWithEmail(email, password);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
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
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      final user = await _authService.signInWithGoogle();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signInWithApple() async {
    state = const AsyncValue.loading();
    try {
      final user = await _authService.signInWithApple();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
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

  /// Quick login with mock data (for development)
  void loginWithMockData() {
    state = AsyncValue.data(MockData.currentUser);
  }
}

// ── Is Signed In Provider ──
final isSignedInProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.valueOrNull != null;
});

// ── Current User Provider (non-null, only valid when signed in) ──
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authStateProvider).valueOrNull;
});

// ── Is Premium Provider ──
final isPremiumProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.isPremium ?? false;
});
