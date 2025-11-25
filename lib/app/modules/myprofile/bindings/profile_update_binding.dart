import 'package:custom_mp_app/app/modules/myprofile/controllers/profile_update_controller.dart';
import 'package:get/get.dart';

class ProfileUpdateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileUpdateController>(() => ProfileUpdateController(), fenix: true);
  }
}
