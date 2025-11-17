import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:custom_mp_app/app/modules/products/controllers/select_product_controller.dart';
import 'package:custom_mp_app/app/modules/products/widgets/product_tab_content_card.dart';

class DetailsTabContent extends StatelessWidget {
  const DetailsTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SelectProductController>();

    return Obx(() {
      final product = controller.selectedProduct.value!;
      final isLoading = controller.isLoading.value;
      final tab = controller.tabIndex.value;

      final description =
          product.description ?? '<p>No description available.</p>';
      final nutrition =
          product.nutritionFacts ?? '<p>No nutrition facts available.</p>';

      return ProductTabContentCard(
        isLoading: isLoading,
        child: Html(
          data: tab == 0 ? description : nutrition,
          style: {
            "body": Style(
              fontSize: FontSize(16),
              lineHeight: LineHeight.number(1.5),
            ),
          },
        ),
      );
    });
  }
}
