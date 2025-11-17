import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/modules/products/controllers/select_variant_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OptionHeader extends StatelessWidget {
  final SelectVariantController controller;
  const OptionHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final product = controller.product.value!;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              final v = controller.selectedVariant.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Get.textTheme.titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "₱${v?.price ?? product.price}",
                    style: Get.textTheme.headlineSmall!.copyWith(
                      color: AppColors.brand,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
