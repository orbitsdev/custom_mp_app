import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/modules/products/widgets/product_card.dart';
import 'package:custom_mp_app/app/modules/search/controllers/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

/// Search Suggestions Section
///
/// Shows popular/featured products in a masonry grid
class SearchSuggestionsSection extends StatelessWidget {
  const SearchSuggestionsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = ProductSearchController.instance;

    return Obx(() {
      // Loading state
      if (controller.isLoadingPopular.value) {
        return Container(
          padding: EdgeInsets.all(32),
          child: Center(
            child: CircularProgressIndicator(color: AppColors.brand),
          ),
        );
      }

      // No popular products
      if (controller.popularProducts.isEmpty) {
        return SizedBox.shrink();
      }

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                HeroIcon(
                  HeroIcons.fire,
                  size: 20,
                  color: AppColors.orange,
                ),
                Gap(8),
                Text(
                  'Popular Products',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),

            Gap(12),

            // Masonry Grid with Products
            MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              itemCount: controller.popularProducts.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final product = controller.popularProducts[index];
                return ProductCard(product: product);
              },
            ),
          ],
        ),
      );
    });
  }
}
