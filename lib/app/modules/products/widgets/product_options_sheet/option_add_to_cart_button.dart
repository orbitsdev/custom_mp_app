import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/modules/products/controllers/select_variant_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OptionAddToCartButton extends StatelessWidget {
  final SelectVariantController controller;
  const OptionAddToCartButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final disabled =
          !controller.isSelectionComplete || controller.isLoading.value;

      return GestureDetector(
        onTap: disabled ? null : controller.addToCart,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 16),
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: disabled
                ? LinearGradient(
                    colors: [
                      Colors.grey.shade300,
                      Colors.grey.shade400,
                    ],
                  )
                : const LinearGradient(
                    colors: [
                      AppColors.brand,
                      AppColors.brandDark,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
          ),
          child: controller.isLoading.value
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child:
                      CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : const Text(
                  "Add to Cart",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      );
    });
  }
}
