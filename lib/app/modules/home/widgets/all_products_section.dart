import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/global/widgets/spacing/sliver_v_gap.dart';
import 'package:custom_mp_app/app/global/widgets/spacing/to_sliver.dart';
import 'package:custom_mp_app/app/modules/home/widgets/product_sort_bottom_sheet.dart';
import 'package:custom_mp_app/app/modules/products/controllers/product_controller.dart';
import 'package:custom_mp_app/app/modules/products/widgets/product_list.dart';
import 'package:custom_mp_app/app/modules/products/widgets/product_loading_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

class AllProductsSection extends StatelessWidget {
  const AllProductsSection({super.key});

  void _showSortOptions() {
    Get.bottomSheet(
      const ProductSortBottomSheet(),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        // Section Header with Sort Button
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'All Products',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[900],
                  ),
                ),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: _showSortOptions,
                  icon: HeroIcon(
                    HeroIcons.adjustmentsHorizontal,
                    size: 18,
                    color: AppColors.brand,
                  ),
                  label: Text(
                    'Sort',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.brand,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.brand, width: 1.5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

         SliverVGap(12),

        // Product Grid
        GetBuilder<ProductController>(
          builder: (_) => const ProductList(),
        ),

         SliverVGap(24),
        // Loading More Indicator
        GetBuilder<ProductController>(
          builder: (controller) {
            if (controller.isLoadingMore) {
              return const ProductLoadingCard();
            }
            return const ToSliver(child: SizedBox.shrink());
          },
        ),
      ],
    );
  }
}
