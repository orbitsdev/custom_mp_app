import 'package:custom_mp_app/app/modules/auth/controllers/sign_up_controller.dart';
import 'package:custom_mp_app/app/modules/cart/controllers/cart_controller.dart';
import 'package:custom_mp_app/app/modules/category/controllers/category_controller.dart';
import 'package:custom_mp_app/app/modules/home/controllers/home_controller.dart';
import 'package:custom_mp_app/app/modules/products/controllers/product_controller.dart';
import 'package:get/get.dart';
import 'package:custom_mp_app/app/modules/auth/controllers/login_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
        
     Get.put<HomeController>(HomeController(), permanent: true);
     Get.put<CategoryController>(CategoryController(), permanent: true);
     Get.put<ProductController>(ProductController(), permanent: true);
     Get.put<CartController>(CartController(), permanent: true);
   
  }
} 
