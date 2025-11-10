import 'package:get/get.dart';
import 'package:custom_mp_app/app/data/models/user/user_model.dart';
import 'package:custom_mp_app/app/data/repositories/auth_repository.dart';
import 'package:custom_mp_app/app/core/plugins/storage/secure_storage_service.dart';
import 'package:custom_mp_app/app/core/routes/routes.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  final AuthRepository _authRepo = AuthRepository();
  final user = Rxn<UserModel>();

  final isAuthenticated = false.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // autoLogin();
  }

  Future<void> autoLogin() async {
    isLoading.value = true;

    final token = await SecureStorageService.getToken();
    if (token == null) {
      isAuthenticated.value = false;
      isLoading.value = false;
      return;
    }

    final result = await _authRepo.getAuthenticatedUser();
    result.fold(
      (failure) {
        print('❌ Auto-login failed: $failure');
        isAuthenticated.value = false;
      },
      (userData) {
        user.value = userData;
        isAuthenticated.value = true;
        print('✅ Auto-login success: ${userData.email}');
      },
    );

    isLoading.value = false;
  }

  Future<void> logout() async {
    isLoading.value = true;
    await _authRepo.logout();
    user.value = null;
    isAuthenticated.value = false;
    isLoading.value = false;
    Get.offAllNamed(Routes.loginPage);
  }
}
