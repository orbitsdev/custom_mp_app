import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:custom_mp_app/app/global/widgets/progress/shimmer_widget.dart';
import 'package:custom_mp_app/app/modules/products/controllers/select_product_controller.dart';
import 'package:custom_mp_app/app/modules/products/widgets/product_details_tab.dart';
import 'package:custom_mp_app/app/global/widgets/spacing/to_sliver.dart';

class DetailsTabs extends StatelessWidget {
  const DetailsTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SelectProductController>();

    return Obx(() {
      final isLoading = controller.isLoading.value;

      return ToSliver(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isLoading
                  ? ShimmerWidget(height: 26, width: 100)
                  : ProductDetailsTab(
                      product: controller.selectedProduct.value!,
                      title: 'Description',
                      isSelected: controller.tabIndex.value == 0,
                      function: () => controller.selecTab(0),
                    ),

              const SizedBox(width: 24),

              isLoading
                  ? ShimmerWidget(height: 26, width: 100)
                  : ProductDetailsTab(
                      product: controller.selectedProduct.value!,
                      title: 'Nutrition Facts',
                      isSelected: controller.tabIndex.value == 1,
                      function: () => controller.selecTab(1),
                    ),
            ],
          ),
        ),
      );
    });
  }
}
