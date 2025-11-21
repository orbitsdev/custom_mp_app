import 'package:custom_mp_app/app/global/widgets/modals/app_modal.dart';
import 'package:custom_mp_app/app/modules/shippinaddress/views/create_address_page.dart';
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
            // USE THIS ADDRESS
          

            // SET DEFAULT
            if (!address.isDefault)
              ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: const Text("Set as Default Address"),
                onTap: () async {
                  Get.back();

                  AppModal.confirm(
                    title: "Set as Default",
                    message: "Do you want to make this your default address?",
                    confirmText: "Yes",
                    onConfirm: () async {
                      AppModal.loading(title: "Updating...");
                      final ok = await controller.setDefault(address.id);
                      AppModal.close();

                      if (ok) {
                        AppModal.success(
                          title: "Updated",
                          message: "Default address updated.",
                        );
                      } else {
                        AppModal.error(
                          message: controller.errorMessage.value,
                        );
                      }
                    },
                  );
                },
              ),

            // EDIT
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text("Edit Address"),
              onTap: () async {
                Get.back();
                final updated = await Get.to(
                  () => CreateAddressPage(address: address),
                  transition: Transition.cupertino,
                );
                if (updated == true) {
                  // controller.loadAddresses(); // optional
                }
              },
            ),

            // DELETE
            if (!address.isDefault)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text(
                  "Delete Address",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Get.back();

                  AppModal.confirm(
                    title: "Delete Address",
                    message:
                        "Are you sure you want to delete this address? This action cannot be undone.",
                    confirmText: "Delete",
                    cancelText: "Cancel",
                    onConfirm: () async {
                      AppModal.loading(title: "Deleting...");
                      final ok = await controller.deleteAddress(address.id);
                      AppModal.close();

                      if (ok) {
                        AppModal.success(
                          title: "Deleted",
                          message: "Address deleted successfully.",
                        );
                      } else {
                        AppModal.error(
                          message: controller.errorMessage.value,
                        );
                      }
                    },
                  );
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
