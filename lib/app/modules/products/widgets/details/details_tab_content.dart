import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:custom_mp_app/app/modules/products/controllers/select_product_controller.dart';
import 'package:custom_mp_app/app/modules/products/widgets/product_tab_content_card.dart';
import 'package:custom_mp_app/app/modules/products/widgets/details/reviews/review_summary_widget.dart';
import 'package:custom_mp_app/app/modules/products/widgets/details/reviews/reviews_masonry_grid.dart';
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
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
                _buildEmptyReviews()
              else ...[
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

  Widget _buildEmptyReviews() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
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
          ],
        ),
      ),
    );
  }
}
