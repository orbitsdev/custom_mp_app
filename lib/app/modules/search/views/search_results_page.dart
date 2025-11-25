import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/data/repositories/product_query_params.dart';
import 'package:custom_mp_app/app/global/widgets/progress/shimmer_widget.dart';
import 'package:custom_mp_app/app/modules/products/widgets/product_card.dart';
import 'package:custom_mp_app/app/modules/products/widgets/product_loading_card.dart';
import 'package:custom_mp_app/app/modules/search/controllers/search_results_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';


class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({Key? key}) : super(key: key);

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  // Controller is injected via SearchBinding, just find it
  final controller = Get.find<SearchResultsController>();
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Load more on scroll
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 300) {
        controller.loadMore();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    // Controller will be automatically disposed by GetX when route is removed
    super.dispose();
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
        title: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Search Results ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              if (controller.searchQuery.value.isNotEmpty)
                Text(
                  '"${controller.searchQuery.value}"',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
            ],
          );
        }),
        actions: [
          // Sort button
          IconButton(
            icon: HeroIcon(HeroIcons.adjustmentsHorizontal, color: Colors.white),
            onPressed: _showSortOptions,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        color: AppColors.brand,
        child: Obx(() {
          // Loading state
          if (controller.isLoading.value) {
            return _buildLoadingState();
          }

          // Empty state
          if (controller.products.isEmpty) {
            return _buildEmptyState();
          }

          // Products grid
          return CustomScrollView(
            controller: scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            slivers: [
              // Results count
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(
                        '${controller.products.length} results found',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      Spacer(),
                      Obx(() {
                        if (controller.selectedSort.value != null) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.brand.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _getSortName(controller.selectedSort.value!),
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.brand,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }
                        return SizedBox.shrink();
                      }),
                    ],
                  ),
                ),
              ),

              // Products masonry grid (dynamic heights to prevent overflow)
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverAlignedGrid.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  itemCount: controller.products.length,
                  itemBuilder: (context, index) {
                    final product = controller.products[index];
                    return ProductCard(product: product);
                  },
                ),
              ),

              // Loading more indicator
              Obx(() {
                if (controller.isLoadingMore.value) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: ProductLoadingCard(),
                    ),
                  );
                }
                return SliverToBoxAdapter(child: Gap(16));
              }),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildLoadingState() {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.all(16),
          sliver: SliverAlignedGrid.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            itemCount: 6,
            itemBuilder: (context, index) => _buildSingleLoadingCard(),
          ),
        ),
      ],
    );
  }

  /// Single loading card widget (non-sliver) with shimmer animation
  Widget _buildSingleLoadingCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder with shimmer
          ShimmerWidget(
            height: 150,
            width: double.infinity,
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name placeholder with shimmer
                ShimmerWidget(
                  height: 14,
                  width: double.infinity,
                ),
                Gap(8),
                // Price placeholder with shimmer
                ShimmerWidget(
                  height: 14,
                  width: 80,
                ),
                Gap(8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Colors.grey[300],
            ),
            Gap(24),
            Text(
              'No products found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.grey[800],
              ),
            ),
            Gap(8),
            Text(
              'Try searching with different keywords\nor browse our categories',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            Gap(24),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brand,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Back to Search',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortOptions() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    'Sort By',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      controller.selectedSort.value = null;
                      controller.searchProducts();
                      Get.back();
                    },
                    child: Text('Reset'),
                  ),
                ],
              ),
            ),

            Divider(height: 1),

            // Sort options
            ..._buildSortOptions(),

            Gap(16),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  List<Widget> _buildSortOptions() {
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
