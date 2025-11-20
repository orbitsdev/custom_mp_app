import 'package:get/get.dart';
import '../controllers/order_preparation_controller.dart';

class OrderPreparationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<OrderPreparationController>(OrderPreparationController());
  }
}
