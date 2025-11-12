import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/data/models/products/product_model.dart';
import 'package:custom_mp_app/app/global/widgets/image/online_image.dart';
import 'package:custom_mp_app/app/modules/products/widgets/featured_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final double? borderRadius;

  const ProductCard({
    Key? key,
    required this.product,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final br = borderRadius ?? 10.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(br),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🖼 Product Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(br),
                  topRight: Radius.circular(br),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 160,
                  child: OnlineImage(imageUrl: product.thumbnail),
                ),
              ),

              if (product.isFeatured)
                const Positioned(
                  top: 8,
                  left: 8,
                  child: FeaturedBadge(),
                ),
            ],
          ),

          // 🧾 Product Info
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category name (first category)
                if (product.categories.isNotEmpty)
                  Text(
                    product.categories.first.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Get.textTheme.bodySmall!.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                const Gap(4),

                // 🛍 Product name
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(
                    textStyle: Get.textTheme.bodyMedium!.copyWith(
                      height: 1.2,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Gap(6),

                // 💰 Price section
                Row(
                  children: [
                    Text(
                      '₱${product.price ?? 0}',
                      style: Get.textTheme.bodyLarge!.copyWith(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (product.compareAtPrice != null &&
                        product.compareAtPrice! > (product.price ?? 0))
                      Text(
                        '₱${product.compareAtPrice}',
                        style: Get.textTheme.bodySmall!.copyWith(
                          color: AppColors.textLight,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}
