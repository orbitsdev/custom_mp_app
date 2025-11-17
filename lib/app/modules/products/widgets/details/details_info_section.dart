import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';

import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/global/widgets/progress/shimmer_widget.dart';
import 'package:custom_mp_app/app/modules/products/controllers/select_product_controller.dart';
import 'package:custom_mp_app/app/global/widgets/spacing/to_sliver.dart';
import 'package:custom_mp_app/app/modules/products/widgets/product_category_list.dart';

class DetailsInfoSection extends StatelessWidget {
  const DetailsInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SelectProductController>();

    return ToSliver(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Obx(() {
          if (controller.isLoading.value) {
            return _buildShimmer();
          }

          final product = controller.selectedProduct.value!;
          final grouped = controller.getGroupedOptions();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🏷️ Name
              Text(
                product.name,
                style: Get.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const Gap(8),

              // 💰 Price
              Text(
                '₱${product.price?.toStringAsFixed(2) ?? '0.00'}',
                style: Get.textTheme.headlineSmall!.copyWith(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // 📜 Short Description
              if (product.shortDescription?.isNotEmpty == true)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    product.shortDescription!,
                    style: Get.textTheme.bodyMedium!.copyWith(
                      color: AppColors.textLight,
                      height: 1.4,
                    ),
                  ),
                ),

              const Gap(8),

              // 🧩 Grouped Variants
              if (grouped.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: grouped.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.key,
                            style: Get.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            entry.value.join(", "),
                            style: Get.textTheme.bodyMedium!.copyWith(
                              color: AppColors.textDark,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

              const Gap(8),

              // 📚 Categories
              ProductCategoryList(categories: product.categories),
            ],
          );
        }),
      ),
    );
  }

  // -------------------------------
  // SHIMMER LOADING
  // -------------------------------
  Widget _buildShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerWidget(height: 26, width: Get.size.width * 0.6),
        const Gap(12),
        ShimmerWidget(height: 22, width: Get.size.width * 0.4),
        const Gap(14),
        ShimmerWidget(height: 18, width: Get.size.width * 0.9),
        const Gap(6),
        ShimmerWidget(height: 18, width: Get.size.width * 0.7),
        const Gap(20),
        ShimmerWidget(height: 18, width: 100),
        const Gap(12),
        ShimmerWidget(height: 22, width: Get.size.width * 0.9),
        const Gap(6),
        ShimmerWidget(height: 22, width: Get.size.width * 0.8),
        const Gap(24),
        ShimmerWidget(height: 22, width: 140),
        const Gap(12),
        ShimmerWidget(height: 32, width: Get.size.width),
      ],
    );
  }
}
