import 'package:get/get.dart';
import 'package:custom_mp_app/app/modules/reviews/controllers/all_reviews_controller.dart';

class AllReviewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllReviewsController>(() => AllReviewsController());
  }
}
