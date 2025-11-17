import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/core/theme/buttons.dart';
import 'package:custom_mp_app/app/modules/products/controllers/select_variant_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class ProductOptionsSheet extends StatelessWidget {
  const ProductOptionsSheet({super.key});

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
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),

            child: Column(
              children: [
                // ===========================
                // HEADER (Shopee Style)
                // ===========================
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thumbnail
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product.thumbnail,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Obx(() {
                          final v = c.selectedVariant.value;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 6),

                              Text(
                                "₱${v?.price ?? product.price}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.brand,
                                ),
                              ),

                              //                             const SizedBox(height: 6),
                              //                        Text(
                              //   "Stock: ${v?.availableStock ?? 0}",
                              //   style: const TextStyle(color: Colors.grey),
                              // ),

                              //                             const SizedBox(height: 6),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    children: [
                      ...grouped.entries.map((entry) {
                        final attr = entry.key;
                        final options = entry.value;
                        final attrIndex = c.attributeOrder.indexOf(attr);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              attr,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 10),

                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: options.map((opt) {
                                final disabled = c.disabledOptions.contains(
                                  opt.id,
                                );
                                final isSelected =
                                    c.selectedOptions[attrIndex] == opt.id;

                                return GestureDetector(
                                  onTap: disabled
                                      ? null
                                      : () => c.pickOption(attr, opt.id),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: disabled
                                          ? Colors.grey.shade200
                                          : isSelected
                                          ? AppColors.brand
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
                                            ? Colors.white
                                            : Colors.black87,
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
                    ],
                  ),
                ),

                // ===========================
                // FIXED FOOTER (Shopee Style)
                // ===========================
                Container(
                  width: Get.size.width,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ===========================
                      // QUANTITY (Centered)
                      // ===========================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: c.qty.value > 1
                                ? () => c.qty.value--
                                : null,
                            icon: Icon(
                              Icons.remove_circle_outline,
                              color: c.qty.value > 1
                                  ? AppColors.textDark
                                  : Colors.grey,
                            ),
                          ),

                          Obx(
                            () => Text(
                              c.qty.value.toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),

                          IconButton(
                            onPressed: () => c.qty.value++,
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // ===========================
                      // ADD TO CART BUTTON
                      // ===========================
                      Obx(() {
  final disabled = !c.isSelectionComplete || c.isLoading.value;

  return GestureDetector(
    onTap: disabled ? null : () => c.addToCart(),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(vertical: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: disabled
            ? LinearGradient(
                colors: [
                  Colors.grey.shade300,
                  Colors.grey.shade400,
                ],
              )
            : const LinearGradient(
                colors: [
                  AppColors.brand,
                  AppColors.brandDark,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
      ),
      child: c.isLoading.value
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : const Text(
              "Add to Cart",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
    ),
  );
})

                    ],
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}
