import 'package:custom_mp_app/app/global/widgets/toasts/app_toast.dart';
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

  @override
  void onInit() {
    super.onInit();
    // autoLogin();
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
      print('❌ Auto-login failed: $failure');

      // 🧹 If failure means token invalid or expired — clear it
      if (failure.contains('Unauthenticated') ||
          failure.contains('expired') ||
          failure.contains('invalid')) {
        await SecureStorageService.deleteToken();
        print('🧹 Deleted expired/invalid token');
      }

      isAuthenticated.value = false;
      user.value = null;
      AppToast.error('Something went wrong. Please login again.');
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
