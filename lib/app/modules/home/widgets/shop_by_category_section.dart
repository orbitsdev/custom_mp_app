import 'package:custom_mp_app/app/core/routes/routes.dart';
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/global/widgets/spacing/sliver_v_gap.dart';
import 'package:custom_mp_app/app/modules/category/controllers/category_controller.dart';
import 'package:custom_mp_app/app/modules/category/widgets/category_horizontal_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopByCategorySection extends StatelessWidget {
  const ShopByCategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.find<CategoryController>();

    return SliverMainAxisGroup(
      slivers: [
        // Section Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Shop by Category',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[900],
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => Get.toNamed(Routes.allCategoriesPage),
                  icon: Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.brand,
                    ),
                  ),
                  label: Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: AppColors.brand,
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
              ],
            ),
          ),
        ),

         SliverVGap(12),

        // Category Horizontal List
        Obx(() {
          return CategoryHorizontalList(
            categories: categoryController.categories,
            isLoading: categoryController.isLoading.value,
          );
        }),
      ],
    );
  }
}
