import 'package:custom_mp_app/app/data/repositories/shipping_address_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:custom_mp_app/app/data/models/shippingaddress/shipping_address_model.dart';

class ShippingAddressController extends GetxController {
  static ShippingAddressController get to => Get.find();
 final ShippingAddressRepository repo;
  ShippingAddressController(this.repo);



  final addresses = <ShippingAddressModel>[].obs;
  final isLoading = false.obs;
  final isSaving = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadAddresses();
  }

  Future<void> loadAddresses() async {
    isLoading(true);
    errorMessage('');

    final result = await repo.fetchAddresses();

    result.match(
      (failure) {
        errorMessage.value = failure.message;
        addresses.clear();
      },
      (list) {
        addresses.assignAll(list);
      },
    );

    isLoading(false);
  }

  Future<bool> createAddress(Map<String, dynamic> payload) async {
    isSaving(true);
    errorMessage('');

    final result = await repo.createAddress(payload);

    bool success = false;

    result.match(
      (failure) => errorMessage.value = failure.message,
      (address) {
        addresses.insert(0, address);
        success = true;
      },
    );

    isSaving(false);
    return success;
  }

  Future<bool> updateAddress(int id, Map<String, dynamic> payload) async {
    isSaving(true);
    errorMessage('');

    final result = await repo.updateAddress(id, payload);

    bool success = false;

    result.match(
      (failure) => errorMessage.value = failure.message,
      (updated) {
        final index = addresses.indexWhere((e) => e.id == id);
        if (index != -1) addresses[index] = updated;
        success = true;
      },
    );

    isSaving(false);
    return success;
  }

  Future<bool> deleteAddress(int id) async {
    errorMessage('');

    final result = await repo.deleteAddress(id);

    bool success = false;

    result.match(
      (failure) => errorMessage.value = failure.message,
      (_) {
        addresses.removeWhere((e) => e.id == id);
        success = true;
      },
    );

    return success;
  }

  Future<bool> setDefault(int id) async {
    errorMessage('');

    final result = await repo.setDefault(id);

    bool success = false;

    result.match(
      (failure) => errorMessage.value = failure.message,
      (updatedDefault) {
        for (int i = 0; i < addresses.length; i++) {
          final a = addresses[i];
          addresses[i] = a.copyWith(
            isDefault: a.id == updatedDefault.id,
          );
        }
        success = true;
      },
    );

    return success;
  }

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
            /// === Use This Address ===
            ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: const Text("Use This Address"),
              onTap: () {
                // return selected ID to OrderPreparationPage
                Get.back(result: address);
              },
            ),

            /// === Set Default ===
            if (!address.isDefault)
              ListTile(
                leading: const Icon(Icons.star_outline),
                title: const Text("Set as Default Address"),
                onTap: () async {
                  await controller.setDefault(address.id);
                  Get.back();
                },
              ),

            /// === Edit ===
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text("Edit Address"),
              onTap: () {
                // TODO: navigate to edit page
              },
            ),

            /// === Delete ===
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text("Delete Address",
                  style: TextStyle(color: Colors.red)),
              onTap: () async {
                await controller.deleteAddress(address.id);
                Get.back();
              },
            ),

            const Divider(),

            /// === Cancel ===
            ListTile(
              title: const Center(
                child: Text(
                  "Cancel",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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

}
