import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'sa_address_card.dart';
import 'sa_address_skeleton.dart';
import '../controllers/shipping_address_controller.dart';

class SAAddressList extends GetView<ShippingAddressController> {
  const SAAddressList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      /// LOADING SKELETON
      if (controller.isLoading.value) {
        return SliverAlignedGrid.count(
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          crossAxisCount: 1, // still list style but uses the aligned grid system
          itemBuilder: (context, index) => const SAAddressSkeleton(),
          itemCount: 4,
        );
      }

      /// EMPTY STATE
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

      /// MAIN LIST USING ALIGNED GRID
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        sliver: SliverAlignedGrid.count(
          crossAxisSpacing: 16,
          mainAxisSpacing: 12,
          crossAxisCount: 1, // 1 per row → like list but cleaner
          itemBuilder: (context, index) {
            final addr = controller.addresses[index];
            return SaAddressCard(
              address: addr,
              isSelected: addr.isDefault,
              enableSelection: false,
            );
          },
          itemCount: controller.addresses.length,
        ),
      );
    });
  }
}
