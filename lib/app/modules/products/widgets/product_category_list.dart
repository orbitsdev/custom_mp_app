// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';


import 'package:custom_mp_app/app/data/models/category/category_model.dart';
import 'package:get/get.dart';

class ProductCategoryList extends StatelessWidget {
List<CategoryModel> categories;
   ProductCategoryList({
    Key? key,
    required this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Categories',
        style: Get.textTheme.bodyMedium!.copyWith(
          color: AppColors.textLight,
          fontWeight: FontWeight.w600,
        ),
      ),
      const Gap(8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: categories.map((cat) {
          return GestureDetector(
            onTap: () {
              // TODO: hook up navigation/filter by category.slug if desired
              // Get.to(() => ProductListPage(), arguments: cat);
              debugPrint('Tapped category: ${cat.name}');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.brandBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.brand.withOpacity(0.35),
                  width: 1,
                ),
              ),
              child: Text(
                cat.name,
                style: Get.textTheme.bodySmall!.copyWith(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    ],
  );
  }
}
