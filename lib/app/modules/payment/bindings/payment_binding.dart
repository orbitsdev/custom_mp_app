import 'package:custom_mp_app/app/modules/payment/controllers/payment_status_controller.dart';
import 'package:custom_mp_app/app/modules/payment/controllers/payment_webview_controller.dart';
import 'package:get/get.dart';

class PaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PaymentWebviewController());
    Get.lazyPut(() => PaymentStatusController());
  }
}
