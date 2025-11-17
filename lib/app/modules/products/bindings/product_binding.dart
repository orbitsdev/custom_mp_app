import 'package:custom_mp_app/app/modules/products/controllers/product_controller.dart';
import 'package:custom_mp_app/app/modules/products/controllers/select_product_controller.dart';
import 'package:custom_mp_app/app/modules/products/controllers/select_variant_controller.dart';

import 'package:get/get.dart';


class ProductBinding extends Bindings {
  @override
  void dependencies() {
      Get.put(SelectProductController());
       Get.put(SelectVariantController());   // 
  }

}
