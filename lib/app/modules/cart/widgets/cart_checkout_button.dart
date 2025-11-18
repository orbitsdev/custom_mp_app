import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartCheckoutButton extends StatelessWidget {
  const CartCheckoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 65,
      color: Colors.white,
      child: Row(
        children: [
          // ☐ SELECT ALL (UI only)

        
          Row(
            children: [
              Transform.scale(
                scale: 1.2,
                child:  Checkbox(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  side: BorderSide(color: AppColors.textLight),
                  activeColor: AppColors.brand,
                  value: false,  // UI sample only
                  onChanged: (value) {
                    // ❌ NO LOGIC for now
                    print("Select all tapped (UI only)");
                  },
                ),
              ),
              Text("All", style: Get.textTheme.bodyMedium),
            ],
          ),

          Spacer(),

          // 💰 Total Payment (UI only)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Total Payment",
                style: Get.textTheme.bodySmall?.copyWith(
                  color: AppColors.textLight,
                ),
              ),
              Text(
                "₱ 0.00", // Dummy UI value
                style: Get.textTheme.titleLarge?.copyWith(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          SizedBox(width: 12),

          // 🛒 Checkout Button (UI only)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.textLight,
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              // ❌ No checkout logic yet
              print("Checkout tapped (UI only)");
            },
            child: Text(
              "Checkout",
              style: TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
