import 'package:custom_mp_app/app/core/routes/routes.dart';
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/data/models/products/product_model.dart';
import 'package:custom_mp_app/app/global/widgets/image/online_image.dart';
import 'package:custom_mp_app/app/modules/products/controllers/select_product_controller.dart';
import 'package:custom_mp_app/app/modules/products/widgets/product_featured_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final double? borderRadius;

  const ProductCard({
    super.key,
    required this.product,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final br = borderRadius ?? 16.0;

    return GestureDetector(
      onTap: () {
        Get.toNamed(
          Routes.productDetailsPage,
          arguments: product,
        );
      },
      child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(br),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
                  child: ProductFeaturedBadge(),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Current price
                          Text(
                            '₱${product.price?.toStringAsFixed(2) ?? '0.00'}',
                            style: Get.textTheme.titleMedium!.copyWith(
                              color: AppColors.brand,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          // Compare at price (slashed)
                          if (product.compareAtPrice != null &&
                              product.compareAtPrice! > (product.price ?? 0))
                            Text(
                              '₱${product.compareAtPrice!.toStringAsFixed(2)}',
                              style: Get.textTheme.bodySmall!.copyWith(
                                color: Colors.grey[500],
                                decoration: TextDecoration.lineThrough,
                                fontSize: 11,
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Add to Cart Button
                    InkWell(
                      onTap: () => _handleAddToCart(product),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.brand,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  // Handle add to cart - opens product options sheet
  void _handleAddToCart(ProductModel product) {
    // First, navigate to product details to load product
    Get.toNamed(
      Routes.productDetailsPage,
      arguments: product,
    );

    // Then open the options sheet after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      try {
        final controller = Get.find<SelectProductController>();
        controller.showProductOptionsSheet();
      } catch (e) {
        // Controller not found, user probably left the page
      }
    });
  }
}
