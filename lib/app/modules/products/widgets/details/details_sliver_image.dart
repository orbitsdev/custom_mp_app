import 'package:custom_mp_app/app/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:custom_mp_app/app/global/widgets/progress/shimmer_widget.dart';
import 'package:custom_mp_app/app/global/widgets/image/online_image.dart';
import 'package:custom_mp_app/app/modules/products/controllers/select_product_controller.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class DetailsSliverImage extends StatelessWidget {
  const DetailsSliverImage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SelectProductController>();

    return SliverAppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
      ),
      expandedHeight: Get.size.height * 0.35,
      backgroundColor: Colors.white,
      pinned: false,
      stretch: true,
      leadingWidth: 56,

      // --- 🖼️ Main Image ---
      flexibleSpace: FlexibleSpaceBar(
        background: Obx(() {
          if (controller.isLoading.value) {
            return ShimmerWidget(
              width: double.infinity,
              height: double.infinity,
              borderRadius: BorderRadius.zero,
            );
          }

          final img = controller.selectedImage.value.isNotEmpty
              ? controller.selectedImage.value
              : controller.selectedProduct.value?.thumbnail ?? "";

          return img.isEmpty ? ShimmerWidget() : OnlineImage(imageUrl: img);
        }),
      ),

      // --- 🔙 Back Button ---
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          margin: EdgeInsets.only(left: 12, top: 6),
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

      // --- 🛒 Cart Icon ---
      actions: [
        GestureDetector(
          
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
    );
  }
}
