import 'package:custom_mp_app/app/core/routes/routes.dart';
import 'package:custom_mp_app/app/data/models/products/product_model.dart';
import 'package:custom_mp_app/app/global/widgets/progress/shimmer_widget.dart';
import 'package:custom_mp_app/app/modules/products/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';

/// Horizontal scrollable list of products
/// Used for Best Sellers and New Arrivals sections
class ProductHorizontalList extends StatelessWidget {
  final List<ProductModel> products;
  final bool isLoading;

  const ProductHorizontalList({
    Key? key,
    required this.products,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 📱 Fixed height for product cards
    const double listHeight = 260.0;

    if (isLoading) {
      // 🔄 Beautiful shimmer loading state
      return SliverToBoxAdapter(
        child: SizedBox(
          height: listHeight,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (_, __) => const Gap(12),
            itemBuilder: (context, index) => ShimmerWidget(
              width: 160,
              height: 260,
              borderRadius: BorderRadius.circular(10),
              margin: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),
      );
    }

    // 📦 Empty state
    if (products.isEmpty) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: 100,
          child: Center(
            child: Text(
              'No products available',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
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
          itemCount: products.length,
          separatorBuilder: (_, __) => const Gap(12),
          itemBuilder: (context, index) {
            final product = products[index];

            return GestureDetector(
              onTap: () {
                // Navigate to product details page
                Get.toNamed(
                  Routes.productDetailsPage,
                  arguments: product,
                );
              },
              child: SizedBox(
                width: 160,
                child: ProductCard(
                  product: product,
                  borderRadius: 10,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
