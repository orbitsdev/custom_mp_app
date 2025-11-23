import 'package:custom_mp_app/app/core/utils/typedefs.dart';

import 'package:custom_mp_app/app/data/models/errror/failure_model.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:custom_mp_app/app/core/plugins/dio/dio_client.dart';
import 'package:custom_mp_app/app/core/plugins/storage/secure_storage_service.dart';
import 'package:custom_mp_app/app/core/plugins/storage/get_storage_service.dart';
import 'package:custom_mp_app/app/data/models/user/user_model.dart';

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
      final response = await DioClient.public.post(
        'register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      final data = response.data['data'];
      final user = UserModel.fromMap(data['user']);
      final token = data['token'] as String;

      // Save both token and user data
      await SecureStorageService.saveToken(token);
      await SecureStorageService.saveUser(user.toJson());

      print('✅ Registration success for ${user.email}');
      return right(user);
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }

  /// Login existing user
  EitherModel<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await DioClient.public.post(
        'login',
        data: {'email': email, 'password': password},
      );

      final data = response.data['data'];
      final token = data['token'];
      final user = UserModel.fromMap(data['user']);

      // Save both token and user data
      await SecureStorageService.saveToken(token);
      await SecureStorageService.saveUser(user.toJson());

      return right(user);
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }

  /// Fetch authenticated user using stored token
  EitherModel<UserModel> getAuthenticatedUser() async {
    try {
      final dio = await DioClient.auth;
      final response = await dio.get('user');

      final data = response.data['data'];
      final user = UserModel.fromMap(data['user']);

      // Save to both storages
      await SecureStorageService.saveUser(user.toJson());
      _getStorage.saveUser(user.toMap());

      return right(user);
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }

  /// Logout user (invalidate token)
  EitherModel<bool> logout() async {
    try {
      final dio = await DioClient.auth;
      await dio.post('logout');

      // Clear all auth data
      await SecureStorageService.clearAuthData();
      _getStorage.clearUser();

      return right(true);
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }
}
