import 'package:custom_mp_app/app/data/models/cart/cart_item_model.dart';
import 'package:custom_mp_app/app/global/widgets/image/online_image.dart';
import 'package:custom_mp_app/app/global/widgets/spacing/to_sliver.dart';
import 'package:custom_mp_app/app/modules/orderpreperation/widgets/order_preparation_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sliver_tools/sliver_tools.dart';
import '../controllers/order_preparation_controller.dart';

class OpCartItemList extends GetView<OrderPreparationController> {
  @override
  Widget build(BuildContext context) {
 
    return MultiSliver(
        children: [
          ToSliver(child: Gap(2)),
          SliverPadding(  
             padding: const EdgeInsets.symmetric(horizontal: 8),
            sliver: SliverMasonryGrid.count(
              childCount: controller.orderPreparation.value!.cartItems.length,
              crossAxisCount: 1,
              mainAxisSpacing: 1,
              crossAxisSpacing: 8,
              itemBuilder: (context, index) {
                CartItemModel cartItem =controller.orderPreparation.value!.cartItems[index];
                
                return OrderPreparationCard(cartItem: cartItem);
                
              },
            ),
          ),
ToSliver(child: Gap(2)),
   
        ],
      );
  }
}
