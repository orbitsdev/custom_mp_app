import 'package:custom_mp_app/app/core/routes/routes.dart';
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/modules/shippinaddress/controllers/shipping_address_controller.dart';
import 'package:custom_mp_app/app/modules/shippinaddress/views/create_address_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
              onPressed: () async {
                final created = await Get.toNamed(
                  Routes.shippingAddressCreatePage,
                  arguments: null, // for "add new address"
                );

                if (created == true) {
                  // refresh the shipping address controller
                  Get.find<ShippingAddressController>().loadAddresses();
                }
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text(
                "Add New Address",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppColors.brand,
                side: const BorderSide(color: Colors.transparent),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
