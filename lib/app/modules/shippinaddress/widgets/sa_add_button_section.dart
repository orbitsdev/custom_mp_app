import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SAAddButtonSection extends StatelessWidget {
  const SAAddButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton.icon(
              onPressed: () {
                // TODO: navigate to add form
                // Get.toNamed(Routes.shippingAddressForm);
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text(
                "Add New Address",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppColors.brand,
                side: const BorderSide(color: Colors.transparent),
                padding: const EdgeInsets.symmetric(

                  horizontal: 8,
                  vertical: 6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
