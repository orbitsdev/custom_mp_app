import 'package:custom_mp_app/app/core/plugins/storage/secure_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// Centralized Dio client manager for both public and authenticated requests.
/// Adds a pretty logger for debugging API calls in dev mode.
class DioClient {
  static const String baseUrl = 'https://dev.avantefoods.com/api/';

  /// Public API instance (no auth header)
  static final Dio public = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      // connectTimeout: const Duration(seconds: 15),
      // receiveTimeout: const Duration(seconds: 15),
    ),
  )..interceptors.add(_dioLogger()); // 👈 attach logger

  /// Authenticated API instance (reads Bearer token from SecureStorage)
  static Future<Dio> get auth async {
    final token = await SecureStorageService.getToken();

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    dio.interceptors.add(_dioLogger()); 
    return dio;
  }

  /// Pretty Dio Logger for development
  static Interceptor _dioLogger() {
    return PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: false,
      responseBody: true,
      compact: true,
      maxWidth: 100,
      logPrint: (obj) => print('[📡 DIO LOG] $obj'),
    );
  }
}
