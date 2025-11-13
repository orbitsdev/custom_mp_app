
import 'package:custom_mp_app/app/data/models/products/product_model.dart';
import 'package:custom_mp_app/app/data/models/products/selected_attribute_option.dart';
import 'package:custom_mp_app/app/data/models/products/variant_model.dart';
import 'package:get/get.dart';



class SelectVariantController extends GetxController {
  static SelectVariantController get to => Get.find();
  late ProductModel product;
  List<VariantModel> variants = [];
 
}
