import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/global/widgets/spacing/sliver_v_gap.dart';
import 'package:custom_mp_app/app/global/widgets/spacing/to_sliver.dart';
import 'package:custom_mp_app/app/modules/category/controllers/category_controller.dart';
import 'package:custom_mp_app/app/modules/category/widgets/category_horizontal_list.dart';
import 'package:custom_mp_app/app/modules/home/widgets/home_drawer.dart';
import 'package:custom_mp_app/app/modules/products/controllers/product_controller.dart';
import 'package:custom_mp_app/app/modules/products/widgets/product_list.dart';
import 'package:custom_mp_app/app/modules/products/widgets/product_search_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  void dispose() {
    scrollController.dispose();
    super.dispose();
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

            SliverVGap(12),

            // 🔹 Category carousel
            Obx(() {
              final c = categoryController;
              return CategoryHorizontalList(
                categories: c.categories,
                isLoading: c.isLoading.value,
              );
            }),

            SliverVGap(12),

            // 🔹 Product grid
            GetBuilder<ProductController>(builder: (_) => const ProductList()),

            SliverVGap(24),
          ],
        ),
      ),
    );
  }
}
