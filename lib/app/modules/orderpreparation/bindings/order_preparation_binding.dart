import 'package:custom_mp_app/app/data/repositories/payment_repository.dart';
import 'package:get/get.dart';
import '../controllers/order_preparation_controller.dart';

class OrderPreparationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<PaymentRepository>(PaymentRepository());
    Get.put<OrderPreparationController>(OrderPreparationController());
  }
}
