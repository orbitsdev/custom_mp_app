import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/core/utils/format.dart';
import 'package:custom_mp_app/app/global/widgets/emptystate/empty_state.dart';
import 'package:custom_mp_app/app/modules/cart/controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CartCheckoutButton extends StatelessWidget {
  const CartCheckoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    return   Obx(
      () {
     
       return  Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 65,
        color: Colors.white,
        child:  Column(
          children: [
            cartController.isSummaryUpdating.value ?  LinearProgressIndicator(color: AppColors.brand,) : const Gap(4),
            Expanded(
              child: Row(
                children: [
                  /// ☐ ALL
                  Row(
                    children: [
                      Transform.scale(
                        scale: 1.2,
                        child: Checkbox(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          side: BorderSide(color: AppColors.textLight),
                          activeColor: cartController.hasSelectedItems ? AppColors.brand : AppColors.textLight,
                          value:  cartController.selectAllValue.value,
                          onChanged:  cartController.carts.isEmpty ? null :  (value) =>  cartController.uiToggleSelectAll(value!),
                        ),
                      ),
                      Text("All", style: Get.textTheme.bodyMedium),
                    ],
                  ),

                  Spacer(), // ⭐ pushes total + button to the right
                  /// 💰 TOTAL
                  Expanded(
                    flex: 2,
                    child: FittedBox(
                      fit: BoxFit
                          .scaleDown, // ⭐ Shrinks text to fit width safely
                      alignment: Alignment.centerRight,
                      child: Text(
                        "₱${formatMoney(cartController.cartSummary.value.grandTotal)}",
                        style: Get.textTheme.titleLarge?.copyWith(
                          color: cartController.hasSelectedItems
                              ? AppColors.brandDark
                              : AppColors.textLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 12),

                  /// CHECKOUT
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cartController.hasSelectedItems
                          ? AppColors.brand
                          : AppColors.textLight,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: cartController.hasSelectedItems ? () {} : null,
                    child: Text(
                      "Checkout",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
      },
    );
  }
}

