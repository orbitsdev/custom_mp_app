import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/core/theme/buttons.dart';
import 'package:custom_mp_app/app/modules/products/controllers/select_variant_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class ProductOptionsSheet extends StatelessWidget {
  const ProductOptionsSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = SelectVariantController.to;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) {
        return Obx(() {
          final product = c.product.value;
          if (product == null) return const SizedBox.shrink();

          final grouped = c.groupedOptions;

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: ListView(
              controller: scrollController,
              children: [
                Text(
                  product.name,
                  style: Get.textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),

                Obx(() {
                  final v = c.selectedVariant.value;
                  return Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 12),
                    child: Text(
                      v != null ? "Selected: ${v.name}" : "Select variant",
                      style: TextStyle(
                        color: v != null ? Colors.green : AppColors.brand,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }),

                ...grouped.entries.map((entry) {
                  final attrName = entry.key;
                  final options = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attrName,
                        style: Get.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: options.map((opt) {
                          final disabled = c.disabledOptions.contains(opt.id);

                          final attributeIndex =
                              c.attributeOrder.indexOf(attrName);

                          final isSelected =
                              c.selectedOptions[attributeIndex] == opt.id;

                          return GestureDetector(
                            onTap: disabled
                                ? null
                                : () =>
                                    c.pickOption(attrName, opt.id),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.brand.withOpacity(0.15)
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: disabled
                                      ? Colors.grey.shade300
                                      : isSelected
                                          ? AppColors.brand
                                          : Colors.grey.shade400,
                                ),
                              ),
                              child: Text(
                                opt.name,
                                style: TextStyle(
                                  color: disabled
                                      ? Colors.grey
                                      : isSelected
                                          ? AppColors.brandDark
                                          : AppColors.textDark,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                }).toList(),

                Row(
                  children: [
                    IconButton(
                      onPressed: c.qty.value > 1
                          ? () => c.qty.value--
                          : null,
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Obx(() => Text(
                          c.qty.value.toString(),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                    IconButton(
                      onPressed: () => c.qty.value++,
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Obx(() {
                  final disabled = !c.isSelectionComplete;

                  return GradientElevatedButton.icon(
                    style: GRADIENT_ELEVATED_BUTTON_STYLE,
                    onPressed: disabled ? null : () => print("ADD TO CART"),
                    icon: const Icon(
                      FluentIcons.cart_16_regular,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Add to Cart",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }),
              ],
            ),
          );
        });
      },
    );
  }
}
