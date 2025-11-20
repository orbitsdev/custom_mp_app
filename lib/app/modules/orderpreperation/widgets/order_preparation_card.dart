// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/global/widgets/image/online_image.dart';
import 'package:flutter/material.dart';
import 'package:custom_mp_app/app/data/models/cart/cart_item_model.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class OrderPreparationCard extends StatelessWidget {
  final CartItemModel cartItem;
  const OrderPreparationCard({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final variant = cartItem.variant;
    final product = variant?.product;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                const Gap(8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 90,
              height: 90,
              child: OnlineImage(
                imageUrl: (variant?.media.isNotEmpty == true)
                    ? variant!.media
                    : (product?.thumbnail ?? ""),
              ),
            ),
          ),

          const Gap(24),

          /// TEXT DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Product Name
                Text(
                  product?.name ?? '-',
                  style: Get.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                /// Variant Name (if not default)
                if (variant != null && !variant.isDefault) ...[
                  const Gap(4),
                  Text(
                    variant.name,
                    style: Get.textTheme.bodySmall!.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                ],

                const Gap(6),

                /// Price
                Text(
                  "₱${cartItem.finalPrice}",
                  style: Get.textTheme.bodyMedium!.copyWith(
                    color: AppColors.brandDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),

                const Gap(3),

                /// Stock
                Text(
                  "Stock: ${variant?.availableStock ?? 0}",
                  style: Get.textTheme.bodySmall!.copyWith(
                    color: AppColors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const Gap(8),

                /// Quantity (display only)
                Text(
                  "x${cartItem.quantity}",
                  style: Get.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
