import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';

import 'package:custom_mp_app/app/core/theme/buttons.dart';
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/modules/cart/views/cart_page.dart';
import 'package:custom_mp_app/app/modules/products/controllers/select_product_controller.dart';

// --- SECTION WIDGETS ---
import 'package:custom_mp_app/app/modules/products/widgets/details/details_sliver_image.dart';
import 'package:custom_mp_app/app/modules/products/widgets/details/details_gallery.dart';
import 'package:custom_mp_app/app/modules/products/widgets/details/details_info_section.dart';
import 'package:custom_mp_app/app/modules/products/widgets/details/details_tabs.dart';
import 'package:custom_mp_app/app/modules/products/widgets/details/details_tab_content.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SelectProductController>();
  
    

    return Scaffold(
      backgroundColor: Colors.white,

      // ===========================================================
      // 🛒 BOTTOM "ADD TO CART"
      // ===========================================================
      bottomSheet: Obx(() {
        final product = controller.selectedProduct.value;

        if (product == null) return const SizedBox.shrink();

        return Container(
          color: Colors.white,
          width: Get.width,
          height: MediaQuery.of(context).size.height * 0.085,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: GradientElevatedButton.icon(
            style: GRADIENT_ELEVATED_BUTTON_STYLE,
            onPressed: controller.showProductOptionsSheet,
            icon: const Icon(
              FluentIcons.cart_16_regular,
              color: Colors.white,
              size: 26,
            ),
            label: Text(
              "Add to Cart",
              style: Get.textTheme.bodyLarge!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }),

      // ===========================================================
      // 🧾 MAIN BODY
      // ===========================================================
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
              const DetailsSliverImage(),
              const DetailsGallery(),
              const DetailsInfoSection(),
              const DetailsTabs(),
              const DetailsTabContent(),
            ],
          ),
        );
      }),
    );
  }
}
