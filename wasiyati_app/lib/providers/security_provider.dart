import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/local_auth_service.dart';

class SecurityState {
  final bool isPinEnabled;
  final bool isBiometricEnabled;
  final bool hasPinSet;
  final bool isVaultUnlocked;

  const SecurityState({
    required this.isPinEnabled,
    required this.isBiometricEnabled,
    required this.hasPinSet,
    this.isVaultUnlocked = false,
  });

  SecurityState copyWith({
    bool? isPinEnabled,
    bool? isBiometricEnabled,
    bool? hasPinSet,
    bool? isVaultUnlocked,
  }) {
    return SecurityState(
      isPinEnabled: isPinEnabled ?? this.isPinEnabled,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      hasPinSet: hasPinSet ?? this.hasPinSet,
      isVaultUnlocked: isVaultUnlocked ?? this.isVaultUnlocked,
    );
  }
}

class SecurityNotifier extends StateNotifier<SecurityState> {
  final LocalAuthService _service;

  SecurityNotifier(this._service)
      : super(SecurityState(
          isPinEnabled: _service.isPinLockEnabled(),
          isBiometricEnabled: _service.isBiometricEnabled(),
          hasPinSet: _service.getPinHash() != null,
          isVaultUnlocked: false,
        ));

  Future<void> enablePin(String pin) async {
    await _service.setPin(pin);
    await _service.setPinLockEnabled(true);
    state = state.copyWith(
      isPinEnabled: true,
      hasPinSet: true,
    );
  }

  Future<void> disablePin() async {
    await _service.setPinLockEnabled(false);
    state = state.copyWith(
      isPinEnabled: false,
      hasPinSet: false,
      isBiometricEnabled: false,
      isVaultUnlocked: false,
    );
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    await _service.setBiometricEnabled(enabled);
    state = state.copyWith(isBiometricEnabled: enabled);
  }

  void lockVault() {
    state = state.copyWith(isVaultUnlocked: false);
  }

  void unlockVault() {
    state = state.copyWith(isVaultUnlocked: true);
  }

  bool verifyPin(String pin) {
    return _service.verifyPin(pin);
  }

  Future<bool> authenticateBiometric(String reason) async {
    final success = await _service.authenticateBiometric(reason);
    if (success) {
      unlockVault();
    }
    return success;
  }
}

// Service provider (overridden in main.dart)
final localAuthServiceProvider = Provider<LocalAuthService>((ref) {
  throw UnimplementedError('Override localAuthServiceProvider in main.dart');
});

// Security state provider
final securityProvider =
    StateNotifierProvider<SecurityNotifier, SecurityState>((ref) {
  final service = ref.watch(localAuthServiceProvider);
  return SecurityNotifier(service);
});
