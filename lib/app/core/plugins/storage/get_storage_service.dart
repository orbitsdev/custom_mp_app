import 'package:get_storage/get_storage.dart';

class LocalStorageService {
  LocalStorageService() : _box = GetStorage();
  final GetStorage _box;

  static const _userKey = 'user';

  // Save user map (from UserModel.toMap())
  void saveUser(Map<String, dynamic> user) => _box.write(_userKey, user);

  // Read user as Map<String, dynamic>?
  Map<String, dynamic>? getUser() {
    final data = _box.read(_userKey);
    if (data is Map) return Map<String, dynamic>.from(data);
    return null;
  }

  // Remove only the cached user
  void clearUser() => _box.remove(_userKey);

  // Wipe everything stored in GetStorage (use with caution)
  void clearAll() => _box.erase();

  // Optional helpers
  bool get hasUser => _box.hasData(_userKey);
}