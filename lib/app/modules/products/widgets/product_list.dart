import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/core/utils/path_helpers.dart';
import 'package:custom_mp_app/app/data/models/products/product_model.dart';
import 'package:custom_mp_app/app/global/widgets/image/local_lottie_image.dart';
import 'package:custom_mp_app/app/global/widgets/wrapper/ripple_cotainer.dart';
import 'package:custom_mp_app/app/modules/products/controllers/product_controller.dart';
import 'package:custom_mp_app/app/modules/products/widgets/product_card.dart';
import 'package:custom_mp_app/app/modules/products/widgets/product_loading_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ProductList extends StatelessWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return GetBuilder<ProductController>(builder: (controller) {
  if (controller.isLoading) {
    return const ProductLoadingCard();
  }

  if (controller.products.isEmpty) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.only(top: 24),
        child: LocalLottieImage(
          imagePath: PathHelpers.lottiesPath('empty.json'),
        ),
      ),
    );
  }

  return SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    sliver: SliverAlignedGrid.count(
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      crossAxisCount: 2,
      itemCount: controller.products.length,
      itemBuilder: (context, index) {
        final product = controller.products[index];
        return RippleContainer(
          onTap: () {},
          child: ProductCard(
            product: product,
            borderRadius: 3,
          ),
        );
      },
    ),
  );
});

  }
}
