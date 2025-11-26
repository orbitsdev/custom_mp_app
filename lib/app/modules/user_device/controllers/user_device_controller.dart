import 'package:custom_mp_app/app/core/plugins/deviceinfoplus/device_info_service.dart';
import 'package:custom_mp_app/app/data/repositories/user_device_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Manages device registration for push notifications
/// Simple pattern: Always call backend, let backend handle updates
class UserDeviceController extends GetxController {
  static UserDeviceController get instance => Get.find();

  final UserDeviceRepository _repository = UserDeviceRepository();
  final isRegistering = false.obs;

  /// Register device with backend
  /// Called on: login success, app startup, app resume, FCM token refresh
  /// Backend handles: create if new, update if exists
  Future<bool> registerDevice() async {
    try {
      isRegistering.value = true;
      print('📱 [UserDeviceController] Registering device...');

      // 1. Get device ID from DeviceInfoService
      final deviceInfo = DeviceInfoService.info;
      if (deviceInfo == null || deviceInfo['device_id'] == null) {
        print('❌ Device info or device_id is null');
        return false;
      }

      final deviceId = deviceInfo['device_id'] as String;
      final platform = deviceInfo['platform'] as String;
      final deviceModel = _getDeviceModel(deviceInfo);

      // 2. Get FCM token
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken == null) {
        print('❌ FCM token is null');
        return false;
      }

      // 3. Get app version
      final packageInfo = await PackageInfo.fromPlatform();
      final appVersion = packageInfo.version;

      print('🔑 Device ID: $deviceId');
      print('📱 Platform: $platform, Model: $deviceModel');
      print('🔔 FCM Token: ${fcmToken.substring(0, 20)}...');
      print('📦 App Version: $appVersion');

      // 4. Call backend - backend handles create/update logic
      final result = await _repository.registerDevice(
        deviceId: deviceId,
        fcmToken: fcmToken,
        platform: platform,
        deviceModel: deviceModel,
        appVersion: appVersion,
      );

      return result.fold(
        (failure) {
          print('❌ Device registration failed: ${failure.message}');
          return false;
        },
        (device) {
          print('✅ Device registered successfully: ${device.id}');
          return true;
        },
      );
    } catch (e) {
      print('❌ Device registration error: $e');
      return false;
    } finally {
      isRegistering.value = false;
    }
  }

  /// Logout device - deactivate in backend
  /// Called when user logs out
  Future<bool> logoutDevice() async {
    try {
      print('📱 [UserDeviceController] Logging out device...');

      final deviceInfo = DeviceInfoService.info;
      if (deviceInfo == null || deviceInfo['device_id'] == null) {
        print('❌ Device info or device_id is null');
        return false;
      }

      final deviceId = deviceInfo['device_id'] as String;
      print('🔑 Device ID: $deviceId');

      final result = await _repository.logoutDevice(deviceId: deviceId);

      return result.fold(
        (failure) {
          print('❌ Device logout failed: ${failure.message}');
          return false;
        },
        (success) {
          print('✅ Device logged out successfully');
          return true;
        },
      );
    } catch (e) {
      print('❌ Device logout error: $e');
      return false;
    }
  }

  /// Extract device model from device info
  String? _getDeviceModel(Map<String, dynamic> deviceInfo) {
    final platform = deviceInfo['platform'] as String;

    if (platform == 'android') {
      final brand = deviceInfo['brand'] ?? '';
      final model = deviceInfo['model'] ?? '';
      return '$brand $model'.trim();
    } else if (platform == 'ios') {
      return deviceInfo['model'] as String?;
    }

    return null;
  }
}
