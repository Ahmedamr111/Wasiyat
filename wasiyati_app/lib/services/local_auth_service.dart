import 'dart:convert';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalAuthService {
  final LocalAuthentication _auth = LocalAuthentication();
  SharedPreferences? _prefs;

  static const String _keyPinEnabled = 'wasiyati_pin_enabled';
  static const String _keyBiometricEnabled = 'wasiyati_biometric_enabled';
  static const String _keyPinHash = 'wasiyati_pin_hash';

  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Ensure initialized
  void _checkInit() {
    if (_prefs == null) {
      throw Exception('LocalAuthService not initialized. Call init() first.');
    }
  }

  // Check if PIN lock is enabled
  bool isPinLockEnabled() {
    _checkInit();
    return _prefs!.getBool(_keyPinEnabled) ?? false;
  }

  // Set PIN lock enabled/disabled
  Future<void> setPinLockEnabled(bool enabled) async {
    _checkInit();
    await _prefs!.setBool(_keyPinEnabled, enabled);
    if (!enabled) {
      // Clear PIN hash when disabling PIN lock
      await _prefs!.remove(_keyPinHash);
      await _prefs!.setBool(_keyBiometricEnabled, false);
    }
  }

  // Check if biometric unlock is enabled
  bool isBiometricEnabled() {
    _checkInit();
    return _prefs!.getBool(_keyBiometricEnabled) ?? false;
  }

  // Set biometric unlock enabled/disabled
  Future<void> setBiometricEnabled(bool enabled) async {
    _checkInit();
    await _prefs!.setBool(_keyBiometricEnabled, enabled);
  }

  // Get current PIN hash
  String? getPinHash() {
    _checkInit();
    return _prefs!.getString(_keyPinHash);
  }

  // Save new PIN (stores FNV-1a hash of PIN + salt)
  Future<void> setPin(String pin) async {
    _checkInit();
    final hash = _hashPin(pin);
    await _prefs!.setString(_keyPinHash, hash);
  }

  // Verify entered PIN against stored hash
  bool verifyPin(String enteredPin) {
    _checkInit();
    final storedHash = getPinHash();
    if (storedHash == null) return false;
    return _hashPin(enteredPin) == storedHash;
  }

  // Helper to hash PIN
  String _hashPin(String pin) {
    const salt = "wasiyati_secure_salt_2026";
    final bytes = utf8.encode(pin + salt);
    var hash = 0xcbf29ce484222325; // FNV-1a 64-bit init offset
    for (var b in bytes) {
      hash ^= b;
      hash *= 0x100000001b3; // FNV-1a prime
    }
    return hash.toRadixString(16);
  }

  // Check if biometric hardware is available and supported
  Future<bool> isBiometricsAvailable() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
      return canAuthenticate;
    } catch (_) {
      return false;
    }
  }

  // Trigger Biometric authentication (FaceID/Fingerprint)
  Future<bool> authenticateBiometric(String reason) async {
    try {
      final available = await isBiometricsAvailable();
      if (!available) return false;

      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}
