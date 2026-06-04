import 'dart:async';
import '../models/user_model.dart';

/// Abstract auth service interface — swap mock for Firebase later
abstract class AuthService {
  /// Stream of auth state changes
  Stream<UserModel?> authStateChanges();

  /// Get current user (null if not signed in)
  UserModel? get currentUser;

  /// Sign in with email + password
  Future<UserModel> signInWithEmail(String email, String password);

  /// Sign up with email + password + name
  Future<UserModel> signUpWithEmail(String email, String password, String name);

  /// Sign in with Google
  Future<UserModel> signInWithGoogle();

  /// Sign in with Apple
  Future<UserModel> signInWithApple();

  /// Sign out
  Future<void> signOut();

  /// Send password reset email
  Future<void> sendPasswordReset(String email);

  /// Update user profile
  Future<UserModel> updateProfile({
    String? name,
    String? phone,
    String? photoUrl,
    String? language,
    String? country,
  });

  /// Check in — confirm alive (Dead Man's Switch)
  Future<void> checkIn();
}

/// Mock implementation for development
class MockAuthService implements AuthService {
  final _authStateController = StreamController<UserModel?>.broadcast();
  UserModel? _currentUser;

  @override
  Stream<UserModel?> authStateChanges() => _authStateController.stream;

  @override
  UserModel? get currentUser => _currentUser;

  @override
  Future<UserModel> signInWithEmail(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    _currentUser = UserModel(
      id: 'user_001',
      name: 'Ahmed',
      email: email,
      phone: '+966501234567',
      language: 'en',
      country: 'SA',
      plan: UserPlan.free,
      trustedContactIds: ['tc_001'],
      lastCheckIn: DateTime.now().subtract(const Duration(days: 7)),
      createdAt: DateTime(2025, 1, 15),
    );
    _authStateController.add(_currentUser);
    return _currentUser!;
  }

  @override
  Future<UserModel> signUpWithEmail(
      String email, String password, String name) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    
    _currentUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      language: 'en',
      createdAt: DateTime.now(),
    );
    _authStateController.add(_currentUser);
    return _currentUser!;
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    return signInWithEmail('ahmed.google@example.com', '');
  }

  @override
  Future<UserModel> signInWithApple() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    return signInWithEmail('ahmed.apple@example.com', '');
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
    _authStateController.add(null);
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock: just succeed
  }

  @override
  Future<UserModel> updateProfile({
    String? name,
    String? phone,
    String? photoUrl,
    String? language,
    String? country,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    _currentUser = _currentUser?.copyWith(
      name: name,
      phone: phone,
      photoUrl: photoUrl,
      language: language,
      country: country,
    );
    _authStateController.add(_currentUser);
    return _currentUser!;
  }

  @override
  Future<void> checkIn() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    _currentUser = _currentUser?.copyWith(
      lastCheckIn: DateTime.now(),
    );
    _authStateController.add(_currentUser);
  }

  void dispose() {
    _authStateController.close();
  }
}
