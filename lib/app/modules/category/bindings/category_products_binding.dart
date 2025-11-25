import 'package:custom_mp_app/app/modules/category/controllers/category_products_controller.dart';
import 'package:get/get.dart';

class CategoryProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryProductsController>(() => CategoryProductsController());
  }
}
