import 'package:custom_mp_app/app/modules/reviews/controllers/submit_review_controller.dart';
import 'package:get/get.dart';

class SubmitReviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubmitReviewController>(() => SubmitReviewController());
  }
}
