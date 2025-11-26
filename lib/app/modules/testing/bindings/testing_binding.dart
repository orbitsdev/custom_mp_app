import 'package:custom_mp_app/app/modules/testing/controllers/testing_controller.dart';
import 'package:get/get.dart';

class TestingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TestingController>(() => TestingController());
  }
}
