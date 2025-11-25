import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/global/widgets/progress/shimmer_widget.dart';
import 'package:custom_mp_app/app/modules/products/widgets/product_card.dart';
import 'package:custom_mp_app/app/modules/search/controllers/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

/// Search Suggestions Section
///
/// Shows popular/featured products in a masonry grid using Slivers
class SearchSuggestionsSection extends StatelessWidget {
  const SearchSuggestionsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = ProductSearchController.instance;

    return Obx(() {
      // Loading state with shimmer
      if (controller.isLoadingPopular.value) {
        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          sliver: SliverMainAxisGroup(
            slivers: [
              // Header shimmer
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ShimmerWidget(
                          width: 20,
                          height: 20,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        Gap(8),
                        ShimmerWidget(
                          width: 120,
                          height: 16,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                    Gap(12),
                  ],
                ),
              ),
              // Grid shimmer using SliverGrid
              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: ShimmerWidget(
                              width: double.infinity,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ShimmerWidget(width: 80, height: 12),
                                  ShimmerWidget(width: double.infinity, height: 14),
                                  ShimmerWidget(width: 60, height: 16),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: 4,
                ),
              ),
            ],
          ),
        );
      }

      // No popular products
      if (controller.popularProducts.isEmpty) {
        return SliverToBoxAdapter(child: SizedBox.shrink());
      }

      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        sliver: SliverMainAxisGroup(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                ],
              ),
            ),

            // Masonry Grid with Products
            SliverMasonryGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childCount: controller.popularProducts.length,
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
