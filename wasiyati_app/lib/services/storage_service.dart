import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

/// Storage service for media files (voice, photo, video, documents)
abstract class StorageService {
  /// Upload a local file and return its download URL
  Future<String> uploadFile(String filePath, String storagePath);

  /// Upload raw bytes and return its download URL
  Future<String> uploadBytes(List<int> bytes, String storagePath,
      {String? contentType});

  /// Download a file to local path
  Future<String> downloadFile(String url, String localPath);

  /// Delete a file from storage
  Future<void> deleteFile(String storagePath);

  /// Get a download URL for an existing storage path
  Future<String> getDownloadUrl(String storagePath);
}

/// Firebase Storage implementation
class FirebaseStorageService implements StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Future<String> uploadFile(String filePath, String storagePath) async {
    final file = File(filePath);
    final ref = _storage.ref(storagePath);
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  @override
  Future<String> uploadBytes(List<int> bytes, String storagePath,
      {String? contentType}) async {
    final ref = _storage.ref(storagePath);
    final metadata = contentType != null
        ? SettableMetadata(contentType: contentType)
        : null;
    await ref.putData(Uint8List.fromList(bytes), metadata);
    return await ref.getDownloadURL();
  }

  @override
  Future<String> downloadFile(String url, String localPath) async {
    final file = File(localPath);
    await _storage.refFromURL(url).writeToFile(file);
    return localPath;
  }

  @override
  Future<void> deleteFile(String storagePath) async {
    await _storage.ref(storagePath).delete();
  }

  @override
  Future<String> getDownloadUrl(String storagePath) async {
    return await _storage.ref(storagePath).getDownloadURL();
  }
}

/// Mock implementation kept for tests / offline fallback
class MockStorageService implements StorageService {
  @override
  Future<String> uploadFile(String filePath, String storagePath) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return 'https://storage.wasiyati.mock/$storagePath';
  }

  @override
  Future<String> uploadBytes(List<int> bytes, String storagePath,
      {String? contentType}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return 'https://storage.wasiyati.mock/$storagePath';
  }

  @override
  Future<String> downloadFile(String url, String localPath) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return localPath;
  }

  @override
  Future<void> deleteFile(String storagePath) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<String> getDownloadUrl(String storagePath) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return 'https://storage.wasiyati.mock/$storagePath?token=mock_token';
  }
}
