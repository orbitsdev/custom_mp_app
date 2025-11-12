import 'package:custom_mp_app/app/modules/products/widgets/product_details_tab.dart';
import 'package:custom_mp_app/app/modules/products/widgets/tab_content_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:flutter/services.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:heroicons/heroicons.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';
import 'package:sliver_tools/sliver_tools.dart';

import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/core/theme/buttons.dart';
import 'package:custom_mp_app/app/global/widgets/image/online_image.dart';
import 'package:custom_mp_app/app/global/widgets/image/online_image_full_screen_display.dart';
import 'package:custom_mp_app/app/global/widgets/progress/shimmer_widget.dart';
import 'package:custom_mp_app/app/global/widgets/spacing/to_sliver.dart';
import 'package:custom_mp_app/app/global/widgets/wrapper/ripple_cotainer.dart';
import 'package:custom_mp_app/app/modules/cart/views/cart_page.dart';
import 'package:custom_mp_app/app/modules/products/controllers/select_product_controller.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SelectProductController>();

    return Scaffold(
      backgroundColor: AppColors.brandBackground,

      // ✅ Bottom sheet (UI only)
      bottomSheet: Obx(() {
        final product = controller.selectedProduct.value;
        return Container(
          width: Get.size.width,
          color: product?.id == null ? Colors.transparent : Colors.white,
          height: MediaQuery.of(context).size.height * 0.07,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: product?.id == null
              ? const SizedBox.shrink()
              : GradientElevatedButton.icon(
                  style: GRADIENT_ELEVATED_BUTTON_STYLE_NO_RADIUS,
                  onPressed: () =>
                      debugPrint('🛒 Add to Cart pressed (UI only)'),
                  icon: const Icon(
                    FluentIcons.cart_16_regular,
                    color: Colors.white,
                    size: 26,
                  ),
                  label: Text(
                    'Add to Cart',
                    style: Get.textTheme.bodyLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
        );
      }),

      // ✅ Body
      body: Obx(() {
        final product = controller.selectedProduct.value;
        if (product == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return CustomScrollView(
          slivers: [
            // ===================================
            // 📸 SliverAppBar with product image
            // ===================================
            SliverAppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarBrightness: Brightness.dark,
              ),
              expandedHeight: Get.size.height * 0.35,
              backgroundColor: Colors.white,
              pinned: false,
              stretch: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    product.thumbnail.isNotEmpty
                        ? OnlineImage(imageUrl: product.thumbnail)
                        : ShimmerWidget(),
                  ],
                ),
              ),
              leadingWidth: 56,
              leading: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  margin: const EdgeInsets.only(left: 12, top: 6),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    shape: BoxShape.circle,
                  
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () => Get.to(() => const CartPage()),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12, top: 6),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.35),
                      shape: BoxShape.circle,
                     
                    ),
                    child: const Center(
                      child: Icon(
                        FluentIcons.cart_16_regular,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ===================================
            // 🧱 Product Info Section
            // ===================================
            ToSliver(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🏷️ Product name
                    Text(
                      product.name,
                      style: Get.textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),

                    const Gap(8),

                    // 💰 Price
                    Text(
                      '₱${product.price?.toStringAsFixed(2) ?? '0.00'}',
                      style: Get.textTheme.headlineSmall!.copyWith(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Gap(12),

                    // 📦 Category
                    if (product.categories.isNotEmpty)
                      Row(
                        children: [
                          Text(
                            'Category:',
                            style: Get.textTheme.bodyMedium!.copyWith(
                              color: AppColors.textLight,
                            ),
                          ),
                          const Gap(6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.brandBackground,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              product.categories.first.name,
                              style: Get.textTheme.bodyMedium!.copyWith(
                                color: AppColors.textDark,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                    const Gap(16),

                    // 📄 Description preview (short)
                    Text(
                      product.description?.isNotEmpty == true
                          ? product.description!
                          : 'No description available for this product.',
                      style: Get.textTheme.bodyMedium!.copyWith(
                        color: AppColors.textLight,
                        height: 1.5,
                      ),
                    ),

                    // const Gap(12),

                    // // ❤️ Favorite button
                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: GestureDetector(
                    //     onTap: () => debugPrint('❤️ Wishlist tapped'),
                    //     child: const HeroIcon(
                    //       HeroIcons.heart,
                    //       style: HeroIconStyle.outline,
                    //       color: Colors.grey,
                    //       size: 26,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),

            // ===================================
            // 📋 Tabs Section
            // ===================================
            // ===================================
            // 📋 Tabs Section
            // ===================================
            MultiSliver(
              children: [
                // 🧱 Tab header row
                ToSliver(
                  child: Container(
                    height: 55,
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ProductDetailsTab(
                          product: product,
                          title: 'Description',
                          isSelected: controller.tabIndex.value == 0,
                          function: () => controller.selecTab(0),
                        ),
                        ProductDetailsTab(
                          product: product,
                          title: 'Nutrition',
                          isSelected: controller.tabIndex.value == 1,
                          function: () => controller.selecTab(1),
                        ),
                        ProductDetailsTab(
                          product: product,
                          title: 'Facts',
                          isSelected: controller.tabIndex.value == 2,
                          function: () => controller.selecTab(2),
                        ),
                      ],
                    ),
                  ),
                ),

                // ✅ FIXED — remove ToSliver wrapper here
                Obx(() {
                  final tabIndex = controller.tabIndex.value;

                  switch (tabIndex) {
                    case 0:
                      return TabContentCard(
                        child: _tabText(
                          product.description ??
                              'No detailed description available.',
                        ),
                      );

                    case 1:
                      return TabContentCard(
                        child: _tabText(
                          product.nutritionFacts ??
                              'No nutrition information available.',
                        ),
                      );

                    case 2:
                      return TabContentCard(
                        child: _tabText(
                          'All our products are processed with care and quality control standards.',
                        ),
                      );

                    default:
                      return TabContentCard(
                        child: Text('No content available.'),
                      );
                  }
                }),

                // ===================================
                // ⭐ Review Section (static)
                // ===================================
                ToSliver(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    margin: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Product Reviews',
                          style: Get.textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const Gap(6),
                        Row(
                          children: const [
                            Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 20,
                            ),
                            Gap(4),
                            Text(
                              'No reviews yet',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  // 🧾 Helper: Tab content text
  Widget _tabText(String text) {
    return Container(
      width: Get.size.width,
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Text(text, style: Get.textTheme.bodyMedium!.copyWith(height: 1.5)),
    );
  }
}
