import 'package:custom_mp_app/app/modules/auth/controllers/login_controller.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
     Get.lazyPut<LoginController>(() => LoginController());
    
  }

}