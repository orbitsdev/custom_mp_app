import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  // Token storage
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
  }

  // User data storage (cached)
  static Future<void> saveUser(String userJson) async {
    await _storage.write(key: 'user', value: userJson);
  }

  static Future<String?> getUser() async {
    return await _storage.read(key: 'user');
  }

  static Future<void> deleteUser() async {
    await _storage.delete(key: 'user');
  }

  // Clear all auth data
  static Future<void> clearAuthData() async {
    await deleteToken();
    await deleteUser();
  }
}
