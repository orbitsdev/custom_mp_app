import 'package:custom_mp_app/app/data/models/products/attrvm.dart';
import 'package:custom_mp_app/app/data/models/products/product_model.dart';
import 'package:custom_mp_app/app/data/models/products/variant_model.dart';
import 'package:custom_mp_app/app/data/repositories/product_repository.dart';
import 'package:custom_mp_app/app/global/widgets/toasts/app_toast.dart';
import 'package:custom_mp_app/app/modules/products/controllers/select_variant_controller.dart';
import 'package:custom_mp_app/app/modules/products/views/product_options_sheet.dart' hide SelectVariantController;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectProductController extends GetxController {
  static SelectProductController get to => Get.find();
  final ProductRepository _productRepository = ProductRepository();
  final selectedProduct = Rxn<ProductModel>();
  final isLoading = false.obs;
  final selectedImage = ''.obs;

  final selectedOptions = <int, int>{}.obs; // attributeId -> optionId
  final selectedVariant = Rxn<VariantModel>();
  final qty = 1.obs;

  ScrollController scrollController = ScrollController();
  var tabIndex = 0.obs;

  void selecTab(int index) {
    tabIndex.value = index;
   
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

  Map<String, List<String>> getGroupedOptions() {
  final product = selectedProduct.value;
  if (product == null) return {};

  final Map<String, Set<String>> grouped = {};

  for (final variant in product.variants) {
    for (final option in variant.options) {
      final attr = option.attributeName ?? "Option";

      grouped.putIfAbsent(attr, () => <String>{});
      grouped[attr]!.add(option.name);
    }
  }

  return grouped.map((key, value) => MapEntry(key, value.toList()));
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

  Map<int, AttrVM> get attributesVM {
  final map = <int, AttrVM>{};
  final p = selectedProduct.value;
  if (p == null) return map;

  for (final v in p.variants) {
    for (final opt in v.options ?? []) {
      final attr = opt.attribute;
      if (attr == null) continue;
      map.putIfAbsent(attr.id, () => AttrVM(attrId: attr.id, attrName: attr.name, options: {}));
      map[attr.id]!.options[opt.id] = opt.name;
    }
  }
  // sort options per attribute (optional)
  return map;
}

// When user selects an option
void pickOption(int attributeId, int optionId) {
  selectedOptions[attributeId] = optionId;
  _resolveVariant();
}

// Find matching variant for currently selected option set
void _resolveVariant() {
  final p = selectedProduct.value;
  if (p == null) return;

  // All selected optionIds
  final chosen = selectedOptions.values.toSet();

  VariantModel? match;
  for (final v in p.variants) {
    final ids = (v.optionIds ?? const []).toSet();
    if (chosen.length == ids.length && chosen.containsAll(ids)) {
      match = v;
      break;
    }
  }
  selectedVariant.value = match;
  if (match?.media.isNotEmpty == true) {
    // show variant image if present
    selectImage(match!.media);
  }
}

// Helpers
bool get isSelectionComplete {
  final need = attributesVM.length;
  final have = selectedOptions.length;
  return need > 0 && have == need && selectedVariant.value != null;
}

void resetPicker() {
  selectedOptions.clear();
  selectedVariant.value = null;
  qty.value = 1;
}

void showProductOptionsSheet() {
  final variantCtrl = Get.put(SelectVariantController());

  // send product
  variantCtrl.init(selectedProduct.value!);

  Get.bottomSheet(
    const ProductOptionsSheet(),
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
  );
}





}
