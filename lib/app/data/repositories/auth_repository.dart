import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:custom_mp_app/app/core/plugins/dio/dio_client.dart';
import 'package:custom_mp_app/app/core/plugins/storage/secure_storage_service.dart';
import 'package:custom_mp_app/app/core/plugins/storage/get_storage_service.dart';
import 'package:custom_mp_app/app/data/models/user/user_model.dart';

/// Common functional type alias:
/// Either<FailureMessage, ResultData>
typedef EitherModel<T> = Future<Either<String, T>>;

/// Repository for handling authentication-related API requests.
/// Uses Dio for HTTP calls and SecureStorage for token management.
class AuthRepository {
  final _getStorage = LocalStorageService();

  /// Register a new user
  EitherModel<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await DioClient.public.post('register', data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      });

      final data = response.data['data'];
      final user = UserModel.fromMap(data['user']);
      final token = data['token'] as String;

      // Store token securely
      await SecureStorageService.saveToken(token);

      // Cache user locally
      _getStorage.saveUser(user.toMap());

      return right(user);
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Registration failed';
      return left(message);
    } catch (e) {
      return left('Unexpected error occurred');
    }
  }

  /// Login existing user
  Future<Either<String, UserModel>> login({
  required String email,
  required String password,
}) async {
  try {
    final response = await DioClient.public.post(
      'login',
      data: {'email': email, 'password': password},
    );

    final data = response.data;
    final token = data['data']['token'];
    await SecureStorageService.saveToken(token);

    // ✅ FIXED: use fromMap instead of fromJson
    final user = UserModel.fromMap(data['data']['user']);

    return Right(user);
  } on DioException catch (e) {
    final error = e.response?.data?['message'] ?? e.message;
    print('❌ Login error: $error');
    return Left(error ?? 'Login failed');
  } catch (e) {
    return Left('Unexpected error: $e');
  }
}


  /// Fetch authenticated user using stored token
  EitherModel<UserModel> getAuthenticatedUser() async {
    try {
      final dio = await DioClient.auth;
      final response = await dio.get('user');

      final data = response.data['data'];
      final user = UserModel.fromMap(data['user']);

      // Cache user data
      _getStorage.saveUser(user.toMap());

      return right(user);
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Failed to load user';
      return left(message);
    } catch (e) {
      return left('Unexpected error occurred');
    }
  }

  /// Logout user (invalidate token)
  EitherModel<bool> logout() async {
    try {
      final dio = await DioClient.auth;
      await dio.post('logout');

      await SecureStorageService.deleteToken();
      _getStorage.clearUser();

      return right(true);
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Logout failed';
      return left(message);
    } catch (e) {
      return left('Unexpected error occurred');
    }
  }
}
