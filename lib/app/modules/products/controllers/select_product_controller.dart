import 'package:custom_mp_app/app/data/models/products/product_model.dart';
import 'package:custom_mp_app/app/data/repositories/product_repository.dart';
import 'package:custom_mp_app/app/global/widgets/modals/app_modal.dart';
import 'package:custom_mp_app/app/global/widgets/toasts/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectProductController extends GetxController {
  static SelectProductController get to => Get.find();
  final ProductRepository _productRepository = ProductRepository();
  final selectedProduct = Rxn<ProductModel>();
  final isLoading = false.obs;
  final selectedImage = ''.obs;
  // for tbas
  ScrollController scrollController = ScrollController();
  var tabIndex = 0.obs;

  void selecTab(int index) {
    tabIndex.value = index;
    // scrollController.animateTo(
    //   0,
    //   duration: const Duration(milliseconds: 300),
    //   curve: Curves.easeOut,
    // );
  }

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments is ProductModel) {
      selectedProduct.value = Get.arguments as ProductModel;
    }
  }

  List<String> get fullGallery {
    final product = selectedProduct.value;
    if (product == null) return [];
    final allImages = <String>[];

    // Always include thumbnail first (if not already in gallery)
    if (product.thumbnail.isNotEmpty) {
      allImages.add(product.thumbnail);
    }

    if (product.gallery.isNotEmpty) {
      for (final img in product.gallery) {
        if (!allImages.contains(img)) allImages.add(img);
      }
    }

    return allImages;
  }

  void setProduct(ProductModel product) {
    selectedProduct.value = product;
  }

   Future<void> refreshProduct() async {
    final product = selectedProduct.value;
    if (product == null || product.slug.isEmpty) return;

    isLoading.value = true;
    final result = await _productRepository.fetchProductBySlug(product.slug);
    isLoading.value = false;

    result.fold(
      (failure) {
        print('❌ Product refresh failed: ${failure.message}');
        AppToast.error('Failed to refresh product: ${failure.message}');
      },
      (updatedProduct) {
        selectedProduct.value = updatedProduct;
        print('🔄 Product updated: ${updatedProduct.name}');
      },
    );
  }

  void selectImage(String imageUrl) {
    selectedImage.value = imageUrl;
  }

 
}
