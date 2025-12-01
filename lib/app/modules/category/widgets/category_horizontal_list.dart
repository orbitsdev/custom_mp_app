import 'package:custom_mp_app/app/core/routes/routes.dart';
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/data/models/category/category_model.dart';
import 'package:custom_mp_app/app/global/widgets/progress/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';

class CategoryHorizontalList extends StatelessWidget {
  final List<CategoryModel> categories;
  final bool isLoading;

  const CategoryHorizontalList({
    Key? key,
    required this.categories,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Clean pill-style buttons height
    const double listHeight = 50.0;

    if (isLoading) {
      // Loading shimmer for pill buttons
      return SliverToBoxAdapter(
        child: SizedBox(
          height: listHeight,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            separatorBuilder: (_, __) => const Gap(8),
            itemBuilder: (context, index) => ShimmerWidget(
              width: 80,
              height: 36,
              borderRadius: BorderRadius.circular(20),
              margin: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),
      );
    }

    // Pill-style category buttons
    return SliverToBoxAdapter(
      child: SizedBox(
        height: listHeight,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          separatorBuilder: (_, __) => const Gap(8),
          itemBuilder: (context, index) {
            final category = categories[index];
            final isFirst = index == 0;
            final hasThumbnail = category.thumbnail != null && category.thumbnail!.isNotEmpty;

            return GestureDetector(
              onTap: () {
                Get.toNamed(
                  Routes.categoryProductsPage,
                  arguments: category,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isFirst ? AppColors.brand : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isFirst ? AppColors.brand : Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Category thumbnail/icon
                    if (hasThumbnail)
                      Container(
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(category.thumbnail!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    else if (category.bgColor != null)
                      Container(
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _parseColor(category.bgColor) ?? AppColors.brandLight,
                        ),
                      ),
                    // Category name
                    Text(
                      category.name,
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: isFirst ? Colors.white : Colors.grey[800],
                        fontWeight: isFirst ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// 🧮 Helper: safely parse "#E4FCF8" → Color
  Color? _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    try {
      String cleaned = hex.replaceAll("#", "");
      if (cleaned.length == 6) cleaned = "FF$cleaned";
      return Color(int.parse("0x$cleaned"));
    } catch (_) {
      return null;
    }
  }
}
