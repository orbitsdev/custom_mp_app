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

   final qty = cartItem.quantity ?? 0;
final price = cartItem.finalPrice ?? 0;

final double subtotal = price * qty;


    return  Container(
  padding: const EdgeInsets.all(16), // was 12 → made wider
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
  ),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // IMAGE
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

      const SizedBox(width: 20), // ← bigger spacing from image

      // TEXT SECTION
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PRODUCT NAME
            Text(
              product?.name ?? '-',
              style: Get.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            // VARIANT NAME
            if (variant != null && !variant.isDefault)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  variant.name,
                  style: Get.textTheme.bodySmall!.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
              ),

            const SizedBox(height: 8),

            // PRICE
            Text(
              "₱${cartItem.finalPrice}",
              style: Get.textTheme.bodyMedium!.copyWith(
                
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 6),

            // Qty + Subtotal
            Text(
              "Qty: ${cartItem.quantity}",
              style: Get.textTheme.bodySmall,
            ),

            const SizedBox(height: 6),

            Text(
              "Subtotal: ₱${subtotal.toStringAsFixed(2)}",
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
