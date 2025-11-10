import 'package:custom_mp_app/app/core/plugins/storage/secure_storage_service.dart';
import 'package:dio/dio.dart';

/// Centralized Dio client manager for both public and authenticated requests.
/// 
/// Usage:
///   - `DioClient.public` → no token (for login/register)
///   - `await DioClient.auth` → with bearer token (for protected endpoints)
class DioClient {
  /// Public API instance (no auth header)
  static final Dio public = Dio(
    BaseOptions(
      baseUrl: 'https://your-api-domain.com/api/web/',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  /// Authenticated API instance (reads Bearer token from SecureStorage)
  static Future<Dio> get auth async {
    final token = await SecureStorageService.getToken();

    return Dio(
      BaseOptions(
        baseUrl: 'https://your-api-domain.com/api/web/',
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );
  }
}
