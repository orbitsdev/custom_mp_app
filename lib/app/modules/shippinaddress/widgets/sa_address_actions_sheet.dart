import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:custom_mp_app/app/data/models/shippingaddress/shipping_address_model.dart';
import '../controllers/shipping_address_controller.dart';

void showAddressActionsSheet(ShippingAddressModel address) {
  final controller = Get.find<ShippingAddressController>();

  Get.bottomSheet(
    SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: const Text("Use This Address"),
              onTap: () {
                Get.back(result: address);
              },
            ),

            if (!address.isDefault)
              ListTile(
                leading: const Icon(Icons.star_outline),
                title: const Text("Set as Default Address"),
                onTap: () async {
                  await controller.setDefault(address.id);
                  Get.back();
                },
              ),

            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text("Edit Address"),
              onTap: () {
                // TODO: navigate to edit page
              },
            ),

            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text(
                "Delete Address",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                await controller.deleteAddress(address.id);
                Get.back();
              },
            ),

            const Divider(),

            ListTile(
              title: const Center(
                child: Text(
                  "Cancel",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              onTap: () => Get.back(),
            ),
          ],
        ),
      ),
    ),
  );
}
