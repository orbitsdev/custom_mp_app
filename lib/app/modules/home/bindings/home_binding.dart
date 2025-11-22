import 'package:custom_mp_app/app/modules/cart/controllers/cart_controller.dart';
import 'package:custom_mp_app/app/modules/category/controllers/category_controller.dart';
import 'package:custom_mp_app/app/modules/home/controllers/home_controller.dart';
import 'package:custom_mp_app/app/modules/products/controllers/product_controller.dart';
import 'package:get/get.dart';

import 'package:custom_mp_app/app/modules/shippinaddress/controllers/shipping_address_controller.dart';

import 'package:custom_mp_app/app/data/repositories/shipping_address_repository.dart';
import 'package:custom_mp_app/app/data/repositories/psgc_repository.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.put<CategoryController>(CategoryController(), permanent: true);
    Get.put<ProductController>(ProductController(), permanent: true);
    Get.put<CartController>(CartController(), permanent: true);

    Get.put<PSGCRepository>(PSGCRepository(), permanent: true);
    Get.put<ShippingAddressRepository>(
      ShippingAddressRepository(),
      permanent: true,
    );
    Get.put<ShippingAddressController>(
      ShippingAddressController(Get.find<ShippingAddressRepository>()),
      permanent: true,
    );
  }
}
