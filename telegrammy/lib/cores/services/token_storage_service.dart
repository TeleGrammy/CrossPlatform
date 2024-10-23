import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Keys used for secure storage
  static const String _tokenKey = 'token';
  static const String _captchaTokenKey = 'token';

  // Save token to secure storage
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  // Save captcha token to secure storage
  Future<void> saveCaptchaToken(String captchaToken) async {
    await _secureStorage.write(key: _captchaTokenKey, value: captchaToken);
  }

  // Retrieve token from secure storage
  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  // Retrieve captcha token from secure storage
  Future<String?> getCaptchaToken() async {
    return await _secureStorage.read(key: _captchaTokenKey);
  }

  // Delete token from secure storage
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  // Delete captcha token from secure storage
  Future<void> deleteCaptchaToken() async {
    await _secureStorage.delete(key: _captchaTokenKey);
  }
}
