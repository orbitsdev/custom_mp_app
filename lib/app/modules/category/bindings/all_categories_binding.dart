import 'package:custom_mp_app/app/modules/category/controllers/category_controller.dart';
import 'package:get/get.dart';

/// All Categories Binding
///
/// Note: CategoryController is already in HomeBinding as permanent,
/// so we just need to ensure it's available (it will be found via Get.find)
class AllCategoriesBinding extends Bindings {
  @override
  void dependencies() {
    // CategoryController is already in HomeBinding as permanent
    // No need to create it again, Get.find will locate it
    // This binding is here for consistency and future additions
  }
}
