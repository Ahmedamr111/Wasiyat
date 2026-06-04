import 'dart:convert';

/// Encryption service for AES-256 message encryption
/// Mock implementation — use 'encrypt' package for real encryption
abstract class EncryptionService {
  /// Encrypt plaintext content
  String encrypt(String plaintext, String key);

  /// Decrypt encrypted content
  String decrypt(String ciphertext, String key);

  /// Hash a security phrase (for trusted contact verification)
  String hashPhrase(String phrase);

  /// Verify a phrase against its hash
  bool verifyPhrase(String phrase, String hash);
}

class MockEncryptionService implements EncryptionService {
  @override
  String encrypt(String plaintext, String key) {
    // Mock: just base64 encode (NOT secure — use encrypt package in production)
    return base64Encode(utf8.encode(plaintext));
  }

  @override
  String decrypt(String ciphertext, String key) {
    // Mock: just base64 decode
    return utf8.decode(base64Decode(ciphertext));
  }

  @override
  String hashPhrase(String phrase) {
    // Mock: simple hash (use bcrypt or similar in production)
    return base64Encode(utf8.encode('hashed_$phrase'));
  }

  @override
  bool verifyPhrase(String phrase, String hash) {
    return hashPhrase(phrase) == hash;
  }
}
