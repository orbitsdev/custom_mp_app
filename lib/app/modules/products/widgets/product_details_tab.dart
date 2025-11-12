import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/data/models/products/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailsTab extends StatelessWidget {
  final ProductModel product;
  final String title;
  final VoidCallback function;
  final bool isSelected;

  const ProductDetailsTab({
    Key? key,
    required this.product,
    required this.title,
    required this.function,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🧾 Tab Text
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: Get.textTheme.bodyMedium!.copyWith(
                color: isSelected ? AppColors.textDark : AppColors.textLight,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.normal,
                letterSpacing: 0.2,
              ),
              child: Text(title),
            ),
            const SizedBox(height: 6),
            // 🔶 Animated underline indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              height: 3,
              width: isSelected ? 40 : 0,
              decoration: BoxDecoration(
                color: AppColors.brand,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
