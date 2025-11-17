import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/core/theme/buttons.dart';
import 'package:custom_mp_app/app/modules/products/controllers/select_variant_controller.dart';
import 'package:custom_mp_app/app/modules/products/widgets/product_options_sheet/option_add_to_cart_button.dart';
import 'package:custom_mp_app/app/modules/products/widgets/product_options_sheet/option_attribute_selector.dart';
import 'package:custom_mp_app/app/modules/products/widgets/product_options_sheet/option_header.dart';
import 'package:custom_mp_app/app/modules/products/widgets/product_options_sheet/option_quantity_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
class ProductOptionsSheet extends StatelessWidget {
  const ProductOptionsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final c = SelectVariantController.to;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) {
        return Obx(() {
          if (c.product.value == null) {
            return const SizedBox.shrink();
          }

          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              children: [
                OptionHeader(controller: c),
                const Divider(height: 1),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    children: [
                      OptionAttributeSelector(controller: c),
                    ],
                  ),
                ),
                OptionQuantityPicker(controller: c),
                OptionAddToCartButton(controller: c),
              ],
            ),
          );
        });
      },
    );
  }
}
