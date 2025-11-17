import 'package:custom_mp_app/app/modules/products/widgets/product_category_list.dart';
import 'package:custom_mp_app/app/modules/products/widgets/product_details_tab.dart';
import 'package:custom_mp_app/app/modules/products/widgets/product_tab_content_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:flutter/services.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';

import 'package:flutter_html/flutter_html.dart';

import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/core/theme/buttons.dart';
import 'package:custom_mp_app/app/global/widgets/image/online_image.dart';
import 'package:custom_mp_app/app/global/widgets/progress/shimmer_widget.dart';
import 'package:custom_mp_app/app/global/widgets/spacing/to_sliver.dart';
import 'package:custom_mp_app/app/modules/cart/views/cart_page.dart';
import 'package:custom_mp_app/app/modules/products/controllers/select_product_controller.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SelectProductController>();

    return Scaffold(
      backgroundColor: Colors.white,

      bottomSheet: Obx(() {
        final product = controller.selectedProduct.value;

        return Container(
          width: Get.size.width,
          color: product?.id == null ? Colors.transparent : Colors.white,
          height: MediaQuery.of(context).size.height * 0.08,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: product?.id == null
              ? const SizedBox.shrink()
              : GradientElevatedButton.icon(
                  style: GRADIENT_ELEVATED_BUTTON_STYLE,
                  onPressed: controller.showProductOptionsSheet,
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

      body: Obx(() {
        final product = controller.selectedProduct.value;
        if (product == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.refreshProduct,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // =============================
              // 📸 SliverAppBar (Main Image)
              // =============================
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
                      Obx(() {
                        if (controller.isLoading.value) {
                          return ShimmerWidget(
                            width: double.infinity,
                            height: double.infinity,
                            borderRadius: BorderRadius.zero,
                          );
                        }

                        final img = controller.selectedImage.value.isNotEmpty
                            ? controller.selectedImage.value
                            : product.thumbnail;

                        return OnlineImage(imageUrl: img);
                      }),
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
              ToSliver(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return SizedBox(
                        height: 70,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: 4, // << Force shimmer count
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (_, __) => ShimmerWidget(
                            width: Get.size.width / 4.5,
                            height: 70,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    }

                    if (controller.fullGallery.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return SizedBox(
                      height: 70,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.fullGallery.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final img = controller.fullGallery[index];
                          final isSelected =
                              controller.selectedImage.value == img;

                          return GestureDetector(
                            onTap: () => controller.selectImage(img),
                            child: Container(
                              width: Get.size.width / 4.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.brand
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: OnlineImage(imageUrl: img),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ),
              ),

              // =============================
              // 🧾 Product Info
              // =============================
             ToSliver(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(20),
                  child: Obx(() {
                    if (controller.isLoading.value)
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ShimmerWidget(height: 26, width: Get.size.width * 0.6),
      const Gap(12),

      ShimmerWidget(height: 22, width: Get.size.width * 0.4),
      const Gap(14),

      ShimmerWidget(height: 18, width: Get.size.width * 0.9),
      const Gap(6),
      ShimmerWidget(height: 18, width: Get.size.width * 0.7),

      const Gap(20),
      ShimmerWidget(height: 18, width: 100),
      const Gap(12),

      ShimmerWidget(height: 22, width: Get.size.width * 0.9),
      const Gap(6),

      ShimmerWidget(height: 22, width: Get.size.width * 0.8),
      const Gap(24),

      ShimmerWidget(height: 22, width: 140),
      const Gap(12),
      ShimmerWidget(height: 32, width: Get.size.width),
    ],
  );

                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🏷️ Name
                          Text(
                                  product.name,
                                  style: Get.textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                  ),
                                ),
                          const Gap(8),

                        Text(
                                  '₱${product.price?.toStringAsFixed(2) ?? '0.00'}',
                                  style: Get.textTheme.headlineSmall!.copyWith(
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                          if (product.shortDescription != null &&
                              product.shortDescription!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child:Text(
                                      product.shortDescription!,
                                      style: Get.textTheme.bodyMedium!.copyWith(
                                        color: AppColors.textLight,
                                        height: 1.4,
                                      ),
                                    ),
                            ),

                          const Gap(8),

                          // ✅ Grouped Variant Displ
                          
                          if (controller.getGroupedOptions().isNotEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: controller.getGroupedOptions().entries.map((entry) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Attribute Name
                                        Text(
                                          entry.key,
                                          style: Get.textTheme.bodyLarge!
                                              .copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                        ),
                                        const SizedBox(height: 4),

                                        // ⭐ Comma-separated options
                                        Text(
                                          entry.value.join(", "),
                                          style: Get.textTheme.bodyMedium!
                                              .copyWith(
                                                color: AppColors.textDark,
                                                fontWeight: FontWeight.w400,
                                                height: 1.4,
                                              ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),

                          const Gap(8),
                          ProductCategoryList(categories: product.categories),
                        ],
                      );
                  }),
                ),
              ),

              // =============================
              // 🧩 Tabs
              // =============================
              Obx((){
                  

                   return ToSliver(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(top: 4, bottom: 2),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          controller.isLoading.value ?  ShimmerWidget( height: 26, width: 100) :  ProductDetailsTab(
                            product: product,
                            title: 'Description',
                            isSelected: controller.tabIndex.value == 0,
                            function: () => controller.selecTab(0),
                          ),
                          const SizedBox(width: 24),
                          controller.isLoading.value ?  ShimmerWidget( height: 26, width: 100) :  ProductDetailsTab(
                            product: product,
                            title: 'Nutrition Facts',
                            isSelected: controller.tabIndex.value == 1,
                            function: () => controller.selecTab(1),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              // =============================
              // 📄 Tab Content
              // =============================
              Obx(() {
                final tabIndex = controller.tabIndex.value;
                final description =
                    product.description ?? '<p>No description available.</p>';
                final nutrition =
                    product.nutritionFacts ??
                    '<p>No nutrition facts available.</p>';

                switch (tabIndex) {
                  case 0:
                    return ProductTabContentCard(
                      isLoading: controller.isLoading.value,
                      child: Container(
                        color: Colors.white,
                        child: Html(
                          data: description,
                          style: {
                            "body": Style(
                              fontSize: FontSize(16),
                              color: AppColors.textLight,
                              lineHeight: LineHeight.number(1.5),
                            ),
                          },
                        ),
                      ),
                    );
                  case 1:
                    return ProductTabContentCard(
                      isLoading: controller.isLoading.value,
                      child: Container(
                        color: Colors.white,
                        child: Html(
                          data: nutrition,
                          style: {
                            "body": Style(
                              fontSize: FontSize(16),
                              color: AppColors.textLight,
                              lineHeight: LineHeight.number(1.5),
                            ),
                          },
                        ),
                      ),
                    );
                  default:
                    return const ToSliver(
                      child: Center(child: Text('No content available.')),
                    );
                }
              }),
            ],
          ),
        );
      }),
    );
  }
}
