import 'package:custom_mp_app/app/modules/auth/controllers/sign_up_controller.dart';
import 'package:get/get.dart';
import 'package:custom_mp_app/app/modules/auth/controllers/login_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
        
    Get.put(LoginController());
    Get.put(SignupController());
  }
}
