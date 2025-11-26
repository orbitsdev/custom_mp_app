import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

/// Manages persistent device ID for user device registration
/// Generates UUID on first launch and stores in secure storage
class DeviceIdService {
  static const _storage = FlutterSecureStorage();
  static const _deviceIdKey = 'device_id';
  static String? _cachedDeviceId;

  /// Get persistent device ID (generates if not exists)
  static Future<String> getDeviceId() async {
    // Return cached value if available
    if (_cachedDeviceId != null) {
      return _cachedDeviceId!;
    }

    // Try to read from storage
    String? storedDeviceId = await _storage.read(key: _deviceIdKey);

    if (storedDeviceId != null && storedDeviceId.isNotEmpty) {
      _cachedDeviceId = storedDeviceId;
      return storedDeviceId;
    }

    // Generate new UUID if not exists
    final newDeviceId = const Uuid().v4();
    await _storage.write(key: _deviceIdKey, value: newDeviceId);
    _cachedDeviceId = newDeviceId;

    return newDeviceId;
  }

  /// Clear device ID (useful for testing)
  static Future<void> clearDeviceId() async {
    await _storage.delete(key: _deviceIdKey);
    _cachedDeviceId = null;
  }
}
