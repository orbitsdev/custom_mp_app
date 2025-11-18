import 'package:custom_mp_app/app/data/models/cart/cart_item_model.dart';
import 'package:custom_mp_app/app/global/widgets/spacing/to_sliver.dart';
import 'package:custom_mp_app/app/modules/cart/controllers/cart_controller.dart';
import 'package:custom_mp_app/app/modules/cart/widgets/cart_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:sliver_tools/sliver_tools.dart';

class CartItemList extends StatelessWidget {
  const CartItemList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CartController.instance;

    return Obx(
      () => MultiSliver(
        children: [
          ToSliver(child: Gap(16)),
          SliverPadding(
             padding: const EdgeInsets.symmetric(horizontal: 8),
            sliver: SliverMasonryGrid.count(
              childCount: controller.carts.length,
              crossAxisCount: 1,
              mainAxisSpacing: 10,
              crossAxisSpacing: 8,
              itemBuilder: (context, index) {
                CartItemModel cartItem = controller.carts[index];
                return Slidable(
                  key: const ValueKey(0),
                  startActionPane: null,
                  endActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          print('delete');
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: CartCard(cartItem: cartItem),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
