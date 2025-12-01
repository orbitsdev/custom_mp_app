import 'package:custom_mp_app/app/modules/reviews/controllers/write_review_controller.dart';
import 'package:get/get.dart';

class WriteReviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WriteReviewController>(() => WriteReviewController());
  }
}
