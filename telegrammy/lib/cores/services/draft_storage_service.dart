import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureDraftStorageService {
  final _storage = const FlutterSecureStorage();

  // Save draft securely
  Future<void> saveDraft( bool isAdmin) async {
    await _storage.write(key: 'isAdmin', value: isAdmin?'true':'false');
  }

  // Load draft securely
  Future<String?> loadDraft() async {
    return await _storage.read(key: 'isAdmin');
  }

  // Clear draft securely
  Future<void> clearDraft(String chatId) async {
    await _storage.delete(key: 'isAdmin');
  }
}
