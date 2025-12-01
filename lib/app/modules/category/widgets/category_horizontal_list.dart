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
    // 📱 Fixed height for professional appearance (matches Shopee/Lazada)
    const double listHeight = 140.0;

    if (isLoading) {
      // 🔄 Beautiful shimmer loading state
      return SliverToBoxAdapter(
        child: SizedBox(
          height: listHeight,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            separatorBuilder: (_, __) => const Gap(12),
            itemBuilder: (context, index) => ShimmerWidget(
              width: 90,
              height: 110,
              borderRadius: BorderRadius.circular(12),
              margin: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),
      );
    }

    // 🟢 Actual content
    return SliverToBoxAdapter(
      child: SizedBox(
        height: listHeight,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          separatorBuilder: (_, __) => const Gap(24),
          itemBuilder: (context, index) {
            final category = categories[index];
            final hasThumbnail =
                category.thumbnail != null && category.thumbnail!.isNotEmpty;

            return GestureDetector(
              onTap: () {
                // Navigate to category products page
                Get.toNamed(
                  Routes.categoryProductsPage,
                  arguments: category,
                );
              },
              child: Container(
                width: Get.size.width /1.8,
                decoration: BoxDecoration(
                  color: hasThumbnail
                      ? Colors.transparent
                      : _parseColor(category.bgColor) ??
                          AppColors.brandLight, // fallback
                  borderRadius: BorderRadius.circular(12),
                  image: hasThumbnail
                      ? DecorationImage(
                          image: NetworkImage(category.thumbnail!),
                          fit: BoxFit.cover,
                        )
                      : null,
                  
                ),
                child: Stack(
                  children: [
                    // 🏷 Category name box
                    Positioned(
                      bottom: 10,
                      left: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          category.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Get.textTheme.labelMedium?.copyWith(
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
