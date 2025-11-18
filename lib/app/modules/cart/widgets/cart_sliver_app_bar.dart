import 'package:custom_mp_app/app/core/theme/config.dart';
import 'package:custom_mp_app/app/global/widgets/modals/app_modal.dart';
import 'package:custom_mp_app/app/modules/cart/controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartSliverAppBar extends StatelessWidget {
  const CartSliverAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = CartController.instance;

    return Obx(() {
      final selectedCount = controller.selectedRowCount;
      final itemCount = controller.carts.length;
      final highlight = controller.hasSelectedItems;

      return SliverAppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: AppColors.textDark),
        ),

        // 🔥 TITLE
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Cart ",
                style: Get.textTheme.titleLarge,
              ),
              if (itemCount > 0)
                TextSpan(
                  text: "($itemCount)",
                  style: Get.textTheme.titleLarge?.copyWith(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.normal,
                  ),
                ),
            ],
          ),
        ),

        // 🔥 ACTIONS
        actions: [
          if (selectedCount > 0)
            Text(
              "($selectedCount)",
              style: Get.textTheme.bodyLarge?.copyWith(
                color: highlight ? AppColors.error : AppColors.textLight,
              ),
            ),

          if (selectedCount > 0) const SizedBox(width: 6),

          Icon(
            Icons.shopping_cart_outlined,
            color: highlight ? AppColors.error : AppColors.textLight,
            size: 22,
          ),

          IconButton(
            icon: Icon(Icons.info_outline, color: AppColors.textLight),
            onPressed: () {
              AppModal.info(
                 title: 'Helpful Reminder',
                message: 'You can swipe to remove an item from the cart.',
                buttonText: 'Got it',
              );
            },
          ),

          const SizedBox(width: 8),
        ],
      );
    });
  }
}
