import 'package:custom_mp_app/app/modules/cart/controllers/cart_controller.dart';
import 'package:custom_mp_app/app/modules/category/controllers/category_controller.dart';
import 'package:custom_mp_app/app/modules/home/controllers/home_controller.dart';
import 'package:custom_mp_app/app/modules/products/controllers/product_controller.dart';
import 'package:custom_mp_app/app/modules/orders/controllers/orders_controller.dart';
import 'package:custom_mp_app/app/modules/myprofile/controllers/profile_controller.dart';
import 'package:custom_mp_app/app/modules/notifications/controllers/notification_controller.dart';
import 'package:get/get.dart';

import 'package:custom_mp_app/app/modules/shippinaddress/controllers/shipping_address_controller.dart';

import 'package:custom_mp_app/app/data/repositories/shipping_address_repository.dart';
import 'package:custom_mp_app/app/data/repositories/psgc_repository.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Core Controllers
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.put<CategoryController>(CategoryController(), permanent: true);
    Get.put<ProductController>(ProductController(), permanent: true);

    // Global State Controllers
    Get.put<CartController>(CartController(), permanent: true);
    Get.put<OrdersController>(OrdersController(), permanent: true);
    Get.put<NotificationController>(NotificationController(), permanent: true);

    // ProfileController - lazy loaded, will fetch fresh data each time profile is opened
    Get.lazyPut<ProfileController>(() => ProfileController());

    // Repositories
    Get.put<PSGCRepository>(PSGCRepository(), permanent: true);
    Get.put<ShippingAddressRepository>(
      ShippingAddressRepository(),
      permanent: true,
    );

    // Address Controller
    Get.put<ShippingAddressController>(
      ShippingAddressController(Get.find<ShippingAddressRepository>()),
      permanent: true,
    );
  }
}
