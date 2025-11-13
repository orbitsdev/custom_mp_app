import 'package:custom_mp_app/app/data/models/products/product_model.dart';
import 'package:custom_mp_app/app/data/models/products/variant_model.dart';
import 'package:get/get.dart';
import 'package:custom_mp_app/app/data/models/product/product_model.dart';
import 'package:custom_mp_app/app/data/models/variant/variant_model.dart';

/// Helper model to track selected option per attribute
class SelectedAttributeOption {
  final int attributeId;
  String optionId;

  SelectedAttributeOption({
    required this.attributeId,
    required this.optionId,
  });
}

class SelectVariantController extends GetxController {
  /// Product and variants
  late ProductModel product;
  List<VariantModel> variants = [];
  List<AttributeModel> attributes = []; // if applicable (attribute model)

  /// Selection states
  var selectedAttributeOptions = <SelectedAttributeOption>[].obs;
  var selectedOptionIds = <String>[].obs;

  /// Valid option IDs after partial selection (unionOptionIds from web)
  var unionOptionIds = <String>[].obs;

  /// Active variant
  Rx<VariantModel?> activeVariant = Rx<VariantModel?>(null);

  /// Active display image
  RxString activeImage = "".obs;

  /// Quantity
  RxInt quantity = 1.obs;

  // ---------------------------------------------------------------------------
  // INITIALIZATION
  // ---------------------------------------------------------------------------
  void initialize(ProductModel productData) {
    product = productData;

    variants = productData.variants;
    attributes = productData.attributes ?? []; // optional if using attributes

    // Default values
    activeVariant.value = variants.isNotEmpty ? variants.first : null;

    // Default image = product thumbnail
    activeImage.value = product.thumbnail ?? "";

    quantity.value = 1;

    selectedAttributeOptions.clear();
    selectedOptionIds.clear();
    unionOptionIds.clear();
  }

  // ---------------------------------------------------------------------------
  // TOGGLE OPTION (user selects an option)
  // ---------------------------------------------------------------------------
  void toggleOption(int attributeId, String optionId) {
    // remove or update existing selected option for this attribute
    int existingIndex = selectedAttributeOptions.indexWhere(
      (e) => e.attributeId == attributeId,
    );

    if (existingIndex != -1) {
      // If user clicked same option again → remove
      if (selectedAttributeOptions[existingIndex].optionId == optionId) {
        selectedAttributeOptions.removeAt(existingIndex);
        selectedOptionIds.remove(optionId);
      } else {
        // Replace option for this attribute
        String previousId = selectedAttributeOptions[existingIndex].optionId;
        selectedOptionIds.remove(previousId);

        selectedAttributeOptions[existingIndex].optionId = optionId;
        selectedOptionIds.add(optionId);
      }
    } else {
      // Add new selection
      selectedAttributeOptions.add(
        SelectedAttributeOption(attributeId: attributeId, optionId: optionId),
      );
      selectedOptionIds.add(optionId);
    }

    // Remove duplicates
    selectedOptionIds.assignAll(selectedOptionIds.toSet().toList());

    _updateVariantSelection();
  }

  // ---------------------------------------------------------------------------
  // INTERNAL: Update variant + union options
  // ---------------------------------------------------------------------------
  void _updateVariantSelection() {
    _computeUnionOptionIds();
    _findAndSetActiveVariant();
    _updateActiveImage();
  }

  // ---------------------------------------------------------------------------
  // FIND MATCHING VARIANT (like the web version)
  // ---------------------------------------------------------------------------
  void _findAndSetActiveVariant() {
    if (selectedOptionIds.isEmpty) {
      activeVariant.value = variants.first;
      return;
    }

    final matching = variants.firstWhereOrNull((variant) {
      if (variant.optionIds == null || variant.optionIds!.isEmpty) {
        return false;
      }
      return selectedOptionIds.every(
        (id) => variant.optionIds!.contains(id),
      );
    });

    if (matching != null) {
      activeVariant.value = matching;
    }
  }

  // ---------------------------------------------------------------------------
  // COMPUTE UNION OPTION IDS
  // ---------------------------------------------------------------------------
  void _computeUnionOptionIds() {
    if (selectedAttributeOptions.isEmpty) {
      unionOptionIds.clear();
      return;
    }

    final selectedIds = selectedAttributeOptions.map((e) => e.optionId).toList();

    final matchingVariants = variants.where((variant) {
      if (variant.optionIds == null) return false;
      return selectedIds.every((id) => variant.optionIds!.contains(id));
    }).toList();

    final union = <String>{};
    for (var variant in matchingVariants) {
      if (variant.optionIds != null) {
        union.addAll(variant.optionIds!);
      }
    }

    unionOptionIds.assignAll(union.toList());
  }

  // ---------------------------------------------------------------------------
  // UPDATE ACTIVE IMAGE
  // ---------------------------------------------------------------------------
  void _updateActiveImage() {
    final variant = activeVariant.value;

    if (variant != null && variant.media != null) {
      if (variant.media!.isNotEmpty && variant.media!.first.url != null) {
        activeImage.value = variant.media!.first.url!;
        return;
      }
    }

    // fallback to product thumbnail
    activeImage.value = product.thumbnail ?? "";
  }

  // ---------------------------------------------------------------------------
  // QUANTITY CONTROL
  // ---------------------------------------------------------------------------
  void incrementQty() => quantity.value++;
  void decrementQty() {
    if (quantity.value > 1) quantity.value--;
  }

  // ---------------------------------------------------------------------------
  // RESET ALL SELECTIONS
  // ---------------------------------------------------------------------------
  void reset() {
    selectedAttributeOptions.clear();
    selectedOptionIds.clear();
    unionOptionIds.clear();
    quantity.value = 1;

    activeVariant.value = variants.first;
    activeImage.value = product.thumbnail ?? "";
  }

  // ---------------------------------------------------------------------------
  // BUILD ADD-TO-CART PAYLOAD (for now print only)
  // ---------------------------------------------------------------------------
  Map<String, dynamic> getAddToCartPayload() {
    return {
      "product_id": product.id,
      "variant_id": activeVariant.value?.id,
      "option_ids": selectedOptionIds,
      "quantity": quantity.value,
    };
  }
}
