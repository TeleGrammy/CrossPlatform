import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class TokenStorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Keys used for secure storage
  static const String _tokenKey = 'token';
  static const String _emailKey = 'emil';

  // Save token to secure storage
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  // Save captcha token to secure storage
  Future<void> saveEmail(String email) async {
    await _secureStorage.write(key: _emailKey, value: email);
  }

  // Retrieve token from secure storage
  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  // Retrieve captcha token from secure storage
  Future<String?> getEmail() async {
    return await _secureStorage.read(key: _emailKey);
  }

  // Delete token from secure storage
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  // Delete captcha token from secure storage
  Future<void> deleteEmail() async {
    await _secureStorage.delete(key: _emailKey);
  }
}
