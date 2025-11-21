import 'package:custom_mp_app/app/data/models/cart/cart_item_model.dart';
import 'package:custom_mp_app/app/global/widgets/image/online_image.dart';
import 'package:custom_mp_app/app/global/widgets/spacing/to_sliver.dart';
import 'package:custom_mp_app/app/modules/orderpreperation/widgets/order_preparation_card.dart';
import 'package:custom_mp_app/app/modules/orderpreperation/widgets/skeleton/op_cart_item_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sliver_tools/sliver_tools.dart';
import '../controllers/order_preparation_controller.dart';

class OpCartItemList extends GetView<OrderPreparationController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      /// 🔥 Show skeleton if still loading
      if (controller.isLoading.value) {
        return const OpCartItemSkeleton();
      }

      final data = controller.orderPreparation.value;

      if (data == null) {
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      }

      final items = data.cartItems;

      return MultiSliver(
        children: [
          /// HEADER
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Order Items",
                    style: Get.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${items.length} items",
                    style: Get.textTheme.bodySmall!.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// LIST
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            sliver: SliverMasonryGrid.count(
              crossAxisCount: 1,
              childCount: items.length,
              mainAxisSpacing: 6,
              itemBuilder: (_, i) => OrderPreparationCard(cartItem: items[i]),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),
        ],
      );
    });
  }
}

