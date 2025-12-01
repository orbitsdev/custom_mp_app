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

  /// Update user profile details
  /// Accepts any combination of fields:
  /// - name, email, password, password_confirmation
  /// - account_information.full_name, phone_number, gender, date_of_birth
  EitherModel<UserModel> updateUserDetails(Map<String, dynamic> body) async {
    try {
      final dio = await DioClient.auth;
      final response = await dio.patch('profile/details', data: body);

      final data = response.data['data'];
      final user = UserModel.fromMap(data);

      // Update stored user data
      await SecureStorageService.saveUser(user.toJson());
      _getStorage.saveUser(user.toMap());

      return right(user);
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }

  /// Upload user avatar with progress tracking
  /// Returns updated user model with new avatar URL
  EitherModel<UserModel> uploadAvatar(
    String filePath, {
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final dio = await DioClient.auth;

      // Create FormData with the file
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(filePath),
      });

      final response = await dio.post(
        'profile/avatar',
        data: formData,
        onSendProgress: onSendProgress,
      );

      final data = response.data['data'];
      final user = UserModel.fromMap(data);

      // Update stored user data
      await SecureStorageService.saveUser(user.toJson());
      _getStorage.saveUser(user.toMap());

      return right(user);
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }

  /// Delete user avatar
  /// Returns user model with fallback UI Avatars URL
  EitherModel<UserModel> deleteAvatar() async {
    try {
      final dio = await DioClient.auth;
      final response = await dio.delete('profile/avatar');

      final data = response.data['data'];
      final user = UserModel.fromMap(data);

      // Update stored user data
      await SecureStorageService.saveUser(user.toJson());
      _getStorage.saveUser(user.toMap());

      return right(user);
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }

  /// Sign in with Google (OAuth)
  /// Sends Google ID token to backend for authentication
  /// Returns user and token if successful
  EitherModel<UserModel> signInWithGoogle({
    required String googleToken,
  }) async {
    try {
      final response = await DioClient.public.post(
        'sign-in-with-google',
        data: {'token': googleToken},
      );

      final data = response.data['data'];
      final user = UserModel.fromMap(data['user']);
      final token = data['token'] as String;

      // Save both token and user data
      await SecureStorageService.saveToken(token);
      await SecureStorageService.saveUser(user.toJson());

      print('✅ Google Sign-In success for ${user.email}');
      return right(user);
    } on DioException catch (e) {
      return left(FailureModel.fromDio(e));
    } catch (e) {
      return left(FailureModel.manual('Unexpected error: $e'));
    }
  }
}
