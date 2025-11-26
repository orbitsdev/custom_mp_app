import 'package:custom_mp_app/app/core/utils/typedefs.dart';
import 'package:custom_mp_app/app/data/models/errror/failure_model.dart';
import 'package:custom_mp_app/app/data/models/user_device/user_device_model.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:custom_mp_app/app/core/plugins/dio/dio_client.dart';

class UserDeviceRepository {
  /// Register or update a device for push notifications
  ///
  /// If device_id already exists for current user, it will be updated
  /// If device_id exists for different user, previous registration will be deleted
  EitherModel<UserDeviceModel> registerDevice({
    required String deviceId,
    required String fcmToken,
    required String platform,
    String? deviceModel,
    String? appVersion,
  }) async {
    try {
      final dio = await DioClient.auth;
      final response = await dio.post(
        'device/register',
        data: {
          'device_id': deviceId,
          'fcm_token': fcmToken,
          'platform': platform,
          if (deviceModel != null) 'device_model': deviceModel,
          if (appVersion != null) 'app_version': appVersion,
        },
      );

      final data = response.data['data'];
      final device = UserDeviceModel.fromMap(data);

      print('✅ Device registered successfully: $deviceId');
      return right(device);
    } on DioException catch (e) {
      print('❌ Device registration failed: ${e.message}');
      return left(FailureModel.fromDio(e));
    } catch (e) {
      print('❌ Device registration error: $e');
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }

  /// Logout device - deactivate to stop receiving push notifications
  /// Sets is_active to false without deleting the device record
  EitherModel<bool> logoutDevice({
    required String deviceId,
  }) async {
    try {
      final dio = await DioClient.auth;
      await dio.post(
        'devices/logout',
        data: {
          'device_id': deviceId,
        },
      );

      print('✅ Device logged out successfully: $deviceId');
      return right(true);
    } on DioException catch (e) {
      print('❌ Device logout failed: ${e.message}');
      return left(FailureModel.fromDio(e));
    } catch (e) {
      print('❌ Device logout error: $e');
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }

  /// Get all registered devices for the authenticated user
  /// Returns both active and inactive devices sorted by most recent
  EitherModel<List<UserDeviceModel>> listDevices() async {
    try {
      final dio = await DioClient.auth;
      final response = await dio.get('mobile/user-devices');

      final data = response.data['data'] as List;
      final devices = data.map((e) => UserDeviceModel.fromMap(e)).toList();

      print('✅ Retrieved ${devices.length} devices');
      return right(devices);
    } on DioException catch (e) {
      print('❌ List devices failed: ${e.message}');
      return left(FailureModel.fromDio(e));
    } catch (e) {
      print('❌ List devices error: $e');
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }
}
