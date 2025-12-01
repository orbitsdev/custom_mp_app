import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';

import 'package:custom_mp_app/app/modules/products/controllers/select_product_controller.dart';
import 'package:custom_mp_app/app/modules/products/widgets/product_tab_content_card.dart';
import 'package:custom_mp_app/app/modules/products/widgets/details/reviews/review_summary_widget.dart';
import 'package:custom_mp_app/app/modules/products/widgets/details/reviews/reviews_masonry_grid.dart';
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/core/theme/buttons.dart';
import 'package:custom_mp_app/app/core/routes/routes.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class DetailsTabContent extends StatelessWidget {
  const DetailsTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SelectProductController>();

    return Obx(() {
      final product = controller.selectedProduct.value!;
    final isLoading = controller.isLoading.value;
      final tab = controller.tabIndex.value;

      final description =
          product.description ?? '<p>No description available.</p>';
      final nutrition =
          product.nutritionFacts ?? '<p>No nutrition facts available.</p>';

      // Reviews tab
      if (tab == 2) {
        final reviewSummary = product.reviewSummary;
        final reviews = product.reviews;

        return ProductTabContentCard(
          isLoading: isLoading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (reviewSummary == null || !reviewSummary.hasReviews)
                _buildEmptyReviews(product)
              else ...[
                // Write Review Button (when there are existing reviews)
                _buildWriteReviewButton(product),
                const SizedBox(height: 16),

                // Review Summary
                ReviewSummaryWidget(summary: reviewSummary),


                // Reviews Grid
                if (reviews.isNotEmpty) ...[
                  ReviewsMasonryGrid(reviews: reviews),
                  const SizedBox(height: 16),
                ],

                // See All Button
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      Get.toNamed(
                        Routes.allReviewsPage,
                        arguments: {
                          'productId': product.id,
                          'productName': product.name,
                          'totalReviews': reviewSummary.totalReviews,
                          'initialReviews': reviews,
                        },
                      );
                    },
                    icon: Icon(
                      FluentIcons.chevron_right_24_regular,
                      size: 18,
                      color: AppColors.brand,
                    ),
                    label: Text(
                      'See All ${reviewSummary.totalReviews} Reviews',
                      style: Get.textTheme.bodyLarge?.copyWith(
                        color: AppColors.brand,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      }

      // Description and Nutrition tabs
      return ProductTabContentCard(
        isLoading: isLoading,
        child: Html(
          data: tab == 0 ? description : nutrition,
          style: {
            "body": Style(
              fontSize: FontSize(16),
              lineHeight: LineHeight.number(1.5),
            ),
          },
        ),
      );
    });
  }

  Widget _buildEmptyReviews(product) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Icon(
              FluentIcons.star_24_regular,
              size: 48,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 12),
            Text(
              'No Reviews Yet',
              style: Get.textTheme.titleSmall?.copyWith(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Be the first to review this product',
              style: Get.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 20),
            // Write Review Button
            SizedBox(
              width: 200,
              child: GradientElevatedButton.icon(
                style: GRADIENT_ELEVATED_BUTTON_STYLE,
                onPressed: () async {
                  final result = await Get.toNamed(
                    Routes.writeReviewPage,
                    arguments: product,
                  );

                  // Refresh product if review was submitted
                  if (result == true) {
                    final controller = Get.find<SelectProductController>();
                    controller.refreshProduct();
                  }
                },
                icon: const Icon(
                  FluentIcons.edit_24_regular,
                  color: Colors.white,
                  size: 18,
                ),
                label: const Text(
                  'Write Review',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWriteReviewButton(product) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () async {
          final result = await Get.toNamed(
            Routes.writeReviewPage,
            arguments: product,
          );

          // Refresh product if review was submitted
          if (result == true) {
            final controller = Get.find<SelectProductController>();
            controller.refreshProduct();
          }
        },
        icon: Icon(
          FluentIcons.edit_24_regular,
          color: AppColors.brand,
          size: 18,
        ),
        label: Text(
          'Write a Review',
          style: TextStyle(
            color: AppColors.brand,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.brand, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
