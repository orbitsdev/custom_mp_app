import 'package:custom_mp_app/app/data/models/products/option_model.dart';
import 'package:custom_mp_app/app/data/models/products/product_model.dart';
import 'package:custom_mp_app/app/data/models/products/variant_model.dart';
import 'package:get/get.dart';

class SelectVariantController extends GetxController {
  static SelectVariantController get to => Get.find();

  final product = Rxn<ProductModel>();

  /// attributeIndex → optionId
  final selectedOptions = <int, int>{}.obs;

  final selectedVariant = Rxn<VariantModel>();

  final qty = 1.obs;

  /// Disabled option IDs
  final disabledOptions = <int>{}.obs;

  /// We auto-generate attributeId based on grouping order
  late List<String> attributeOrder;

  int get requiredAttributeCount => attributeOrder.length;

  /// Group options by attributeName
  Map<String, List<OptionModel>> get groupedOptions {
    final p = product.value;
    if (p == null) return {};

    final map = <String, List<OptionModel>>{};

    for (final v in p.variants) {
      for (final o in v.options) {
        final key = o.attributeName ?? "Option";

        map.putIfAbsent(key, () => []);

        if (!map[key]!.any((x) => x.id == o.id)) {
          map[key]!.add(o);
        }
      }
    }

    attributeOrder = map.keys.toList(); // <-- we generate attributeId here

    return map;
  }

  void init(ProductModel p) {
    product.value = p;
    selectedOptions.clear();
    disabledOptions.clear();
    selectedVariant.value = null;
    qty.value = 1;
    groupedOptions; // build attributeOrder
  }

  bool get isSelectionComplete =>
      selectedOptions.length == requiredAttributeCount;

  /// Convert attributeName → attributeIndex
  int _attrIndex(String attrName) {
    return attributeOrder.indexOf(attrName);
  }

void pickOption(String attributeName, int optionId) {
  final idx = _attrIndex(attributeName);

  // If user clicks the same option → unselect it
  if (selectedOptions[idx] == optionId) {
    selectedOptions.remove(idx);
    selectedVariant.value = null;
    _updateAvailableOptions();
    return;
  }

  // Otherwise select normally
  selectedOptions[idx] = optionId;

  _updateAvailableOptions();
  _findMatchingVariant();
}


  void _updateAvailableOptions() {
    final p = product.value;
    if (p == null) return;

    if (selectedOptions.isEmpty) {
      disabledOptions.clear();
      return;
    }

    final selectedIds = selectedOptions.values.toList();

    final matching = p.variants.where((v) {
      return selectedIds.every((id) => v.optionIds.contains(id));
    });

    final union = matching.expand((v) => v.optionIds).toSet();

    disabledOptions.value = p.variants
        .expand((v) => v.optionIds)
        .toSet()
        .difference(union)
        .toSet();
  }

  void _findMatchingVariant() {
    final p = product.value;
    if (p == null) return;

    final selectedIds = selectedOptions.values.toList();

    selectedVariant.value = p.variants.firstWhereOrNull(
      (v) => selectedIds.every((id) => v.optionIds.contains(id)),
    );
  }
}
