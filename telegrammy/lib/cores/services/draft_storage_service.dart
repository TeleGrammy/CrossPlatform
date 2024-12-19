import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureDraftStorageService {
  final _storage = const FlutterSecureStorage();

  // Save draft securely
  Future<void> saveDraft(String chatId, String draftContent) async {
    await _storage.write(key: 'draft_$chatId', value: draftContent);
  }

  // Load draft securely
  Future<String?> loadDraft(String chatId) async {
    return await _storage.read(key: 'draft_$chatId');
  }

  // Clear draft securely
  Future<void> clearDraft(String chatId) async {
    await _storage.delete(key: 'draft_$chatId');
  }
}
