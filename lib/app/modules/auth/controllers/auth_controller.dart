import 'package:get/get.dart';
import 'package:custom_mp_app/app/data/models/user/user_model.dart';
import 'package:custom_mp_app/app/data/repositories/auth_repository.dart';
import 'package:custom_mp_app/app/core/plugins/storage/secure_storage_service.dart';
import 'package:custom_mp_app/app/core/routes/routes.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  final AuthRepository _authRepo = AuthRepository();

  final isAuthenticated = false.obs;
  final isLoading = false.obs;
  final user = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    autoLogin();
  }

  Future<void> autoLogin() async {
    isLoading.value = true;

    final token = await SecureStorageService.getToken();

    if (token == null) {
      // No token stored
      isAuthenticated.value = false;
      isLoading.value = false;
      Get.offAllNamed(Routes.loginPage);
      return;
    }

    // Validate token by fetching /user
    final result = await _authRepo.getAuthenticatedUser();
    result.fold(
      (error) {
        // Token invalid or expired
        isAuthenticated.value = false;
        SecureStorageService.deleteToken();
        Get.offAllNamed(Routes.loginPage);
      },
      (userData) {
        user.value = userData;
        isAuthenticated.value = true;
        Get.offAllNamed(Routes.homePage); // Go to main/home
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
