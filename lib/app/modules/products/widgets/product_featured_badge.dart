import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

class ProductFeaturedBadge extends StatelessWidget {
  const ProductFeaturedBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 4, right: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.brand, width: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.yellow, Colors.orangeAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(Ionicons.star, size: 8, color: Colors.white),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              'Featured',
              style: Get.textTheme.bodySmall?.copyWith(
                color: AppColors.brand,
                fontWeight: FontWeight.bold,
                fontSize: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
