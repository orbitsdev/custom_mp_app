import 'package:custom_mp_app/app/core/routes/routes.dart';
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/data/repositories/product_query_params.dart';
import 'package:custom_mp_app/app/global/widgets/spacing/sliver_v_gap.dart';
import 'package:custom_mp_app/app/global/widgets/spacing/to_sliver.dart';
import 'package:custom_mp_app/app/modules/category/controllers/category_controller.dart';
import 'package:custom_mp_app/app/modules/category/widgets/category_horizontal_list.dart';
import 'package:custom_mp_app/app/modules/home/widgets/home_drawer.dart';
import 'package:custom_mp_app/app/modules/products/controllers/product_controller.dart';
import 'package:custom_mp_app/app/modules/products/widgets/product_list.dart';
import 'package:custom_mp_app/app/modules/products/widgets/product_loading_card.dart';
import 'package:custom_mp_app/app/modules/products/widgets/product_search_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final scrollController = ScrollController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final productController = Get.find<ProductController>();
  final categoryController = Get.find<CategoryController>();

  Future<void> _onRefresh() async {
    await Future.wait([
      categoryController.fetchCategories(),
      productController.fetchProducts(),
     
    ]);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 300) {
        productController.loadMore();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
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
                      productController.selectedSort.value = null;
                      productController.fetchProducts();
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

            SizedBox(height: 16),
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
        final isSelected = productController.selectedSort.value == option;

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
            productController.applySort(option);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.brandBackground,
      drawer: HomeDrawer(),
      body: RefreshIndicator(
        color: AppColors.brand,
        backgroundColor: Colors.white,
        strokeWidth: 2.5,
        onRefresh: _onRefresh,
        child: CustomScrollView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // 🔹 Sticky search bar
            SliverAppBar(
              pinned: true,
              backgroundColor: AppColors.brand,
              automaticallyImplyLeading: false,
              title: ProductSearchField(scaffoldKey: scaffoldKey),
            ),

            SliverVGap(16),

            // 🔹 "Shop by Category" Section Header
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
                      onPressed: () {
                        // TODO: Navigate to all categories page
                        // Get.toNamed(Routes.allCategoriesPage);
                      },
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

            // 🔹 Category carousel
            Obx(() {
              final c = categoryController;
              return CategoryHorizontalList(
                categories: c.categories,
                isLoading: c.isLoading.value,
              );
            }),

            SliverVGap(24),

            // 🔹 "All Products" Section Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      'All Products',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[900],
                      ),
                    ),
                    const Spacer(),
                    OutlinedButton.icon(
                      onPressed: _showSortOptions,
                      icon: HeroIcon(
                        HeroIcons.adjustmentsHorizontal,
                        size: 18,
                        color: AppColors.brand,
                      ),
                      label: Text(
                        'Sort',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.brand,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.brand, width: 1.5),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverVGap(12),

            // 🔹 Product grid
            GetBuilder<ProductController>(builder: (_) => const ProductList()),

            SliverVGap(24),
            GetBuilder<ProductController>(
              builder: (c) {
                if (c.isLoadingMore) {
                  return const ProductLoadingCard();
                }
                return const ToSliver(child: SizedBox.shrink());
              },
            ),
          ],
        ),
      ),
    );
  }
}
