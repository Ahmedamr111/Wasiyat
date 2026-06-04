/// Storage service for media files (voice, photo, video, documents)
/// Mock implementation — swap for Firebase Storage later
abstract class StorageService {
  /// Upload a file and return its URL
  Future<String> uploadFile(String filePath, String storagePath);

  /// Download a file to local path
  Future<String> downloadFile(String url, String localPath);

  /// Delete a file from storage
  Future<void> deleteFile(String url);

  /// Get a temporary download URL
  Future<String> getDownloadUrl(String storagePath);
}

class MockStorageService implements StorageService {
  @override
  Future<String> uploadFile(String filePath, String storagePath) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Mock: return a fake URL
    return 'https://storage.wasiyati.mock/$storagePath';
  }

  @override
  Future<String> downloadFile(String url, String localPath) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return localPath;
  }

  @override
  Future<void> deleteFile(String url) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<String> getDownloadUrl(String storagePath) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return 'https://storage.wasiyati.mock/$storagePath?token=mock_token';
  }
}
