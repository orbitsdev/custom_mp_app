import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/global/widgets/spacing/sliver_v_gap.dart';
import 'package:custom_mp_app/app/modules/products/controllers/product_controller.dart';
import 'package:custom_mp_app/app/modules/home/widgets/product_horizontal_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// New Arrivals Section - Shows horizontal scrollable list of new arrival products
class NewArrivalsSection extends StatelessWidget {
  const NewArrivalsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = Get.find<ProductController>();

    return SliverMainAxisGroup(
      slivers: [
        // Section Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // ⚡ Icon and title
                Icon(
                  Icons.bolt,
                  color: Colors.blue.shade700,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'New Arrivals',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[900],
                  ),
                ),
                const Spacer(),
                // See All button (for future dedicated page)
                // TextButton.icon(
                //   onPressed: () => Get.toNamed(Routes.newArrivalsPage),
                //   icon: Text(
                //     'See All',
                //     style: TextStyle(
                //       fontSize: 14,
                //       fontWeight: FontWeight.w600,
                //       color: AppColors.brand,
                //     ),
                //   ),
                //   label: Icon(
                //     Icons.arrow_forward_ios,
                //     size: 14,
                //     color: AppColors.brand,
                //   ),
                //   style: TextButton.styleFrom(
                //     padding: const EdgeInsets.symmetric(horizontal: 8),
                //   ),
                // ),
              ],
            ),
          ),
        ),

        SliverVGap(12),

        // Product Horizontal List
        Obx(() {
          return ProductHorizontalList(
            products: productController.newArrivals,
            isLoading: productController.isLoadingNewArrivals.value,
          );
        }),
      ],
    );
  }
}
