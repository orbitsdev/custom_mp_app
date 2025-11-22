import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order_preparation_controller.dart';
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
class OPPlaceOrderButton extends GetView<OrderPreparationController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = controller.orderPreparation.value;
      if (data == null) return const SizedBox.shrink();

      final summary = data.summary;

      return SizedBox(
        height: 90, // <<< FIXED HEIGHT (important!)
        child: Material(
          elevation: 10,
          child: Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: 12 + MediaQuery.of(context).padding.bottom,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
            
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// LEFT
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total",
                      style: Get.textTheme.bodySmall!
                          .copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "₱${summary.total}",
                      style: Get.textTheme.titleMedium!.copyWith(
                        color: AppColors.brandDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                /// RIGHT
                Obx(() {
                  final isPlacing = controller.isPlacingOrder.value;

                  return ElevatedButton(
                    onPressed: isPlacing ? null : () => controller.placeOrder(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brandDark,
                      disabledBackgroundColor: Colors.grey[400],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: isPlacing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            "Place Order",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  );
                }),
              ],
            ),
          ),
        ),
      );
    });
  }
}
