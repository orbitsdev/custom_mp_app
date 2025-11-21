import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sa_address_card.dart';
import 'sa_address_skeleton.dart';
import '../controllers/shipping_address_controller.dart';

class SAAddressList extends GetView<ShippingAddressController> {
  const SAAddressList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => const SAAddressSkeleton(),
            childCount: 4,
          ),
        );
      }

      if (controller.addresses.isEmpty) {
        return const SliverFillRemaining(
          child: Center(
            child: Text(
              "No shipping addresses yet",
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final addr = controller.addresses[index];
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: SaAddressCard(
                address: addr,
                isSelected: addr.isDefault,
                enableSelection: false,
              ),
            );
          },
          childCount: controller.addresses.length,
        ),
      );
    });
  }
}
