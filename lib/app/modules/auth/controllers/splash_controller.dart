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

    // Small UX delay (optional)
    await Future.delayed(const Duration(milliseconds: 800));

    // 🔑 Run auth check (will show loading only if token exists)
    await _auth.autoLogin();

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
