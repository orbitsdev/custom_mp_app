import 'package:custom_mp_app/app/data/models/products/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectProductController extends GetxController {

  static SelectProductController get to => Get.find();
  final selectedProduct = Rxn<ProductModel>();
  final isLoading = false.obs;


  // for tbas 
    ScrollController scrollController = ScrollController();
  var tabIndex = 0.obs;

  @override
  void onInit() {

    super.onInit();

     if (Get.arguments != null && Get.arguments is ProductModel) {
      selectedProduct.value = Get.arguments as ProductModel;
    }
  }
  void setProduct(ProductModel product) {
    selectedProduct.value = product;
  }

  Future<void> refreshProductDetails() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));
    isLoading.value = false;
  }

  void selecTab(int index) {
    tabIndex(index);

    scrollToTab(index);
    update();
  }

  void scrollToTab(int index) {
    double position = index * 100.0;
    scrollController.animateTo(
      position,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }


}
