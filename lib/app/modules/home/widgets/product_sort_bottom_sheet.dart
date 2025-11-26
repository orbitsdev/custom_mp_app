import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/data/repositories/product_query_params.dart';
import 'package:custom_mp_app/app/modules/products/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductSortBottomSheet extends StatelessWidget {
  const ProductSortBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = Get.find<ProductController>();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title with Reset Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text(
                  'Sort By',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    productController.selectedSort.value = null;
                    productController.fetchProducts();
                    Get.back();
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Sort Options List
          ..._buildSortOptions(productController),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  List<Widget> _buildSortOptions(ProductController controller) {
    final sortOptions = [
      ProductSortOption.newest,
      ProductSortOption.priceLowToHigh,
      ProductSortOption.priceHighToLow,
      ProductSortOption.mostPopular,
      ProductSortOption.mostSold,
      ProductSortOption.nameAsc,
      ProductSortOption.nameDesc,
    ];

    return sortOptions.map((option) {
      return Obx(() {
        final isSelected = controller.selectedSort.value == option;

        return ListTile(
          title: Text(
            _getSortName(option),
            style: TextStyle(
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? AppColors.brand : Colors.grey[800],
            ),
          ),
          trailing: isSelected
              ? Icon(Icons.check, color: AppColors.brand)
              : null,
          onTap: () {
            controller.applySort(option);
            Get.back();
          },
        );
      });
    }).toList();
  }

  String _getSortName(ProductSortOption option) {
    switch (option) {
      case ProductSortOption.newest:
        return 'Newest';
      case ProductSortOption.priceLowToHigh:
        return 'Price: Low to High';
      case ProductSortOption.priceHighToLow:
        return 'Price: High to Low';
      case ProductSortOption.mostPopular:
        return 'Most Popular';
      case ProductSortOption.mostSold:
        return 'Best Selling';
      case ProductSortOption.nameAsc:
        return 'Name: A to Z';
      case ProductSortOption.nameDesc:
        return 'Name: Z to A';
      default:
        return 'Default';
    }
  }
}
