import 'package:custom_mp_app/app/global/widgets/toasts/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:custom_mp_app/app/data/repositories/auth_repository.dart';
import 'package:custom_mp_app/app/data/models/user/user_model.dart';
import 'package:custom_mp_app/app/core/plugins/storage/secure_storage_service.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  final AuthRepository _authRepo = AuthRepository();

  final isAuthenticated = false.obs;
  final isLoading = false.obs;
  final user = Rxn<UserModel>();

    // --- 🧭 Route & Action Tracking ---
  String? _pendingRoute;
  VoidCallback? _pendingAction;

 void setPendingAction(VoidCallback action) {
    _pendingAction = action;
  }

  /// Clear pending data
  void _clearPending() {
    _pendingRoute = null;
    _pendingAction = null;
  }

  /// Execute last action or redirect
  void resumeAfterLogin() {
    if (_pendingAction != null) {
      _pendingAction!(); // Execute stored callback
    } else if (_pendingRoute != null) {
      Get.offAllNamed(_pendingRoute!);
    } else {
      Get.offAllNamed('/home');
    }
    _clearPending();
  }


 Future<void> autoLogin() async {
  print('🔍 [AuthController] Starting autoLogin()');
  isLoading.value = true;

  final token = await SecureStorageService.getToken();
  print('🔑 [AuthController] Retrieved token: $token');

  if (token == null || token.isEmpty) {
    print('🚫 No saved token found');
    isAuthenticated.value = false;
    isLoading.value = false;
    return;
  }

  final result = await _authRepo.getAuthenticatedUser();

  result.fold(
    (failure) async {
      print('❌ Auto-login failed: ${failure.message}');

      // 🧹 If failure message suggests token invalid/expired, clear it
      final msg = failure.message.toLowerCase();

      if (msg.contains('unauthenticated') ||
          msg.contains('expired') ||
          msg.contains('invalid')) {
        await SecureStorageService.deleteToken();
        print('🧹 Deleted expired/invalid token');
      }

      isAuthenticated.value = false;
      user.value = null;
      AppToast.error(failure.message);
    },
    (userData) {
      print('✅ Auto-login success: ${userData.email}');
      user.value = userData;
      isAuthenticated.value = true;
    },
  );

  isLoading.value = false;
}




  Future<void> logout() async {
    await _authRepo.logout();
    await SecureStorageService.deleteToken();
    user.value = null;
    isAuthenticated.value = false;
    Get.offAllNamed('/login');
  }
}
