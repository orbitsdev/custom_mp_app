import 'package:custom_mp_app/app/modules/shippinaddress/controllers/shipping_address_controller.dart';
import 'package:get/get.dart';
import 'package:custom_mp_app/app/data/repositories/shipping_address_repository.dart';
import 'package:custom_mp_app/app/data/repositories/psgc_repository.dart';


class ShippingAddressBinding extends Bindings {
  @override
  void dependencies() {
    // PSGC repo (for region/province/municipality/barangay)
    Get.lazyPut<PSGCRepository>(() => PSGCRepository(), fenix: true);
    // Shipping address repo
    Get.lazyPut<ShippingAddressRepository>(() => ShippingAddressRepository() , fenix: true);
    // Shipping address controller
    Get.lazyPut<ShippingAddressController>(     () => ShippingAddressController(Get.find<ShippingAddressRepository>()), fenix: true);
  }
}
