
import 'package:custom_mp_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:get/get.dart';

class AppBinding  extends Bindings{
  @override
  void dependencies(){

    Get.put(AuthController(),permanent: true);
  }

}