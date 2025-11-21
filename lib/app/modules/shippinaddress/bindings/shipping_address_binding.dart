import 'package:get/get.dart';
import 'package:custom_mp_app/app/data/repositories/shipping_address_repository.dart';
import '../controllers/shipping_address_controller.dart';

class ShippingAddressBinding extends Bindings {
  @override
  void dependencies() {
    // Register repository first
    Get.lazyPut<ShippingAddressRepository>(
      () => ShippingAddressRepository(),
    );

    // Register controller with injected repository
    Get.lazyPut<ShippingAddressController>(
      () => ShippingAddressController(Get.find<ShippingAddressRepository>()),
    );
  }
}
