import 'package:custom_mp_app/app/global/widgets/toasts/app_toast.dart';
import 'package:get/get.dart';
import 'package:custom_mp_app/app/data/repositories/auth_repository.dart';
import 'package:custom_mp_app/app/data/models/user/user_model.dart';
import 'package:custom_mp_app/app/core/plugins/storage/secure_storage_service.dart';
import 'package:custom_mp_app/app/modules/user_device/controllers/user_device_controller.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  final AuthRepository _authRepo = AuthRepository();

  final isAuthenticated = false.obs;
  final isLoading = false.obs;
  final user = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    _setupAppLifecycleListener();
  }

  /// Listen for app resume to refresh user data
  void _setupAppLifecycleListener() {
    // Optional: Refresh user data when app resumes from background
    // Uncomment if you want to sync user data on app resume
    /*
    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(
        resumeCallBack: () async {
          if (isAuthenticated.value) {
            await refreshUserData();
          }
        },
      ),
    );
    */
  }


Future<void> autoLogin() async {
  print('🔍 [AuthController] Starting autoLogin()');
  isLoading.value = true;

  // 1. Check for token
  final token = await SecureStorageService.getToken();
  print('🔑 [AuthController] Retrieved token: ${token != null ? "exists" : "null"}');

  if (token == null || token.isEmpty) {
    print('🚫 No saved token found');
    isAuthenticated.value = false;
    isLoading.value = false;
    return;
  }

  // 2. Load cached user data from storage
  final cachedUserJson = await SecureStorageService.getUser();
  print('👤 [AuthController] Cached user: ${cachedUserJson != null ? "exists" : "null"}');

  if (cachedUserJson != null && cachedUserJson.isNotEmpty) {
    try {
      // Use cached user data immediately
      final cachedUser = UserModel.fromJson(cachedUserJson);
      user.value = cachedUser;
      isAuthenticated.value = true;
      print('✅ Using cached user data: ${cachedUser.email}');
    } catch (e) {
      print('⚠️ Failed to parse cached user data: $e');
    }
  }

  // 3. Try to refresh user data from API (background sync)
  print('🔄 Attempting to refresh user data from API...');
  final result = await _authRepo.getAuthenticatedUser();

  result.fold(
    (failure) async {
      print('❌ API refresh failed: ${failure.message}');

      // Only logout if token is actually invalid (401, 403)
      // Keep cached user for network errors
      if (failure.statusCode == 401 || failure.statusCode == 403) {
        print('🔒 Token is invalid/expired - logging out');
        await SecureStorageService.clearAuthData();
        isAuthenticated.value = false;
        user.value = null;
        AppToast.error('Session expired. Please login again.');
      } else if (failure.isNetworkError) {
        print('📡 Network error - keeping cached user data');
        // Keep user logged in with cached data
        if (user.value == null) {
          // No cached user, but has token - show error but don't logout
          AppToast.error('No internet connection. Using offline mode.');
        }
      } else {
        // Other backend errors - keep cached user
        print('⚠️ Backend error - keeping cached user data');
        print('Backend error details: ${failure.message}');
        // Show user-friendly error instead of technical backend error
        AppToast.error('Unable to sync data. Using cached information. ${failure.message}', );
      }
    },
    (userData) async {
      print('✅ User data refreshed from API: ${userData.email}');
      user.value = userData;
      isAuthenticated.value = true;

      // Re-register device (backend updates if FCM token changed)
      print('📱 Re-registering device on app startup...');
      await UserDeviceController.instance.registerDevice();
    },
  );

  isLoading.value = false;
}




  /// Silently refresh user data from API (no loading indicator)
  /// Useful for background sync when app resumes
  Future<void> refreshUserData() async {
    if (!isAuthenticated.value) return;

    print('🔄 Silently refreshing user data...');
    final result = await _authRepo.getAuthenticatedUser();

    result.fold(
      (failure) {
        print('⚠️ Silent refresh failed: ${failure.message}');
        // Don't show error to user - just log it
        if (failure.statusCode == 401 || failure.statusCode == 403) {
          // Token expired - logout
          logout();
        }
      },
      (userData) {
        print('✅ User data refreshed: ${userData.email}');
        user.value = userData;
      },
    );
  }

  Future<void> logout() async {
    print('🚪 [AuthController] Starting logout...');

    // 1. Logout device (stop receiving notifications)
    await UserDeviceController.instance.logoutDevice();

    // 2. Logout from backend
    await _authRepo.logout();

    // 3. Clear local auth data
    await SecureStorageService.clearAuthData();

    // 4. Clear controller state
    user.value = null;
    isAuthenticated.value = false;

    // 5. Navigate to login
    Get.offAllNamed('/login');
    print('✅ [AuthController] Logout complete');
  }
}
