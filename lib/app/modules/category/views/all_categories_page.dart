import 'package:custom_mp_app/app/core/routes/routes.dart';
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/data/models/category/category_model.dart';
import 'package:custom_mp_app/app/global/widgets/progress/shimmer_widget.dart';
import 'package:custom_mp_app/app/modules/category/controllers/category_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

//
class AllCategoriesPage extends StatefulWidget {
  const AllCategoriesPage({Key? key}) : super(key: key);

  @override
  State<AllCategoriesPage> createState() => _AllCategoriesPageState();
}

class _AllCategoriesPageState extends State<AllCategoriesPage> {
  final controller = Get.find<CategoryController>();
  final searchController = TextEditingController();

  // Local search filter
  final searchQuery = ''.obs;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Filter categories based on search query
  List<CategoryModel> get filteredCategories {
    if (searchQuery.value.isEmpty) {
      return controller.categories;
    }

    return controller.categories
        .where((cat) => cat.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandBackground,
      appBar: AppBar(
        backgroundColor: AppColors.brand,
        elevation: 0,
        leading: IconButton(
          icon: HeroIcon(HeroIcons.arrowLeft, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'All Categories',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search categories...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                suffixIcon: Obx(() {
                  if (searchQuery.value.isNotEmpty) {
                    return IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey[400]),
                      onPressed: () {
                        searchController.clear();
                        searchQuery.value = '';
                      },
                    );
                  }
                  return SizedBox.shrink();
                }),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) {
                searchQuery.value = value;
              },
            ),
          ),

          // Categories grid
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.fetchCategories,
              color: AppColors.brand,
              child: Obx(() {
                // Loading state
                if (controller.isLoading.value) {
                  return _buildLoadingState();
                }

                // Empty state
                if (controller.categories.isEmpty) {
                  return _buildEmptyState('No categories available');
                }

                // Filtered empty state
                final filtered = filteredCategories;
                if (filtered.isEmpty) {
                  return _buildEmptyState('No categories found');
                }

                // Grid of categories
                return GridView.builder(
                  padding: EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final category = filtered[index];
                    return _buildCategoryCard(category);
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(CategoryModel category) {
    final hasThumbnail = category.thumbnail != null && category.thumbnail!.isNotEmpty;

    return GestureDetector(
      onTap: () {
        // Navigate to category products page
        Get.toNamed(
          Routes.categoryProductsPage,
          arguments: category,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: hasThumbnail
              ? Colors.white
              : _parseColor(category.bgColor) ?? AppColors.brandLight,
          borderRadius: BorderRadius.circular(12),
          image: hasThumbnail
              ? DecorationImage(
                  image: NetworkImage(category.thumbnail!),
                  fit: BoxFit.cover,
                )
              : null,
          boxShadow: [
           
          ],
        ),
        child: Stack(
          children: [
            // Category name at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[900],
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return ShimmerWidget(
          height: 200,
          width: double.infinity,
          borderRadius: BorderRadius.circular(12),
        );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.category_outlined,
              size: 80,
              color: Colors.grey[300],
            ),
            Gap(24),
            Text(
              message,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.grey[800],
              ),
            ),
            Gap(8),
            Text(
              searchQuery.value.isEmpty
                  ? 'Categories will appear here once added'
                  : 'Try a different search term',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (searchQuery.value.isNotEmpty) ...[
              Gap(24),
              ElevatedButton(
                onPressed: () {
                  searchController.clear();
                  searchQuery.value = '';
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brand,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Clear Search',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Helper: safely parse "#E4FCF8" → Color
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
