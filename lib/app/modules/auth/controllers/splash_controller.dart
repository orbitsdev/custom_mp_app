import 'package:get/get.dart';
import 'package:custom_mp_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:custom_mp_app/app/global/widgets/modals/app_modal.dart';

class SplashController extends GetxController {
  final AuthController _auth = AuthController.instance;

  @override
  void onReady() {
    super.onReady();
    _startAppFlow();
  }

  Future<void> _startAppFlow() async {
    print('[SPLASH] Starting initialization...');
    
    // 🌀 Show loading modal
    AppModal.loading(title: "Checking your session...");
    
    // Small UX delay (optional)
    await Future.delayed(const Duration(milliseconds: 800));

    // 🔑 Run auth check
    await _auth.autoLogin();

    // Close modal before navigating
    AppModal.close();

    // 🔁 Route decision
    if (_auth.isAuthenticated.value) {
      print('[SPLASH] Authenticated → redirecting to home');
      Get.offAllNamed('/home');
    } else {
      print('[SPLASH] Not logged in → redirecting to login');
      Get.offAllNamed('/login');
    }
  }
}
