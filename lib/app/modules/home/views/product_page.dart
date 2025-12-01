import 'package:custom_mp_app/app/core/routes/routes.dart';
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/global/widgets/spacing/sliver_v_gap.dart';
import 'package:custom_mp_app/app/global/widgets/spacing/to_sliver.dart';
import 'package:custom_mp_app/app/modules/category/controllers/category_controller.dart';
import 'package:custom_mp_app/app/modules/home/widgets/all_products_section.dart';
import 'package:custom_mp_app/app/modules/home/widgets/best_sellers_section.dart';
import 'package:custom_mp_app/app/modules/home/widgets/new_arrivals_section.dart';
import 'package:custom_mp_app/app/modules/home/widgets/home_drawer.dart';
import 'package:custom_mp_app/app/modules/home/widgets/product_search_app_bar.dart';
import 'package:custom_mp_app/app/modules/home/widgets/shop_by_category_section.dart';
import 'package:custom_mp_app/app/modules/products/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final scrollController = ScrollController();

  final productController = Get.find<ProductController>();
  final categoryController = Get.find<CategoryController>();

  Future<void> _onRefresh() async {
    await Future.wait([
      categoryController.fetchCategories(),
      productController.fetchProducts(),
      productController.fetchBestSellersPreview(),
      productController.fetchNewArrivalsPreview(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandBackground,

      body: RefreshIndicator(
        color: AppColors.brand,
        backgroundColor: Colors.white,
        strokeWidth: 2.5,
        onRefresh: _onRefresh,
        child: CustomScrollView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            ProductSearchAppBar(),
            SliverVGap(16),

            ShopByCategorySection(),
            SliverVGap(20),
            AllProductsSection(),
          ],
        ),
      ),
    );
  }
}
