import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/modules/cart/controllers/cart_controller.dart';
import 'package:custom_mp_app/app/modules/cart/widgets/cart_checkout_button.dart';
import 'package:custom_mp_app/app/modules/cart/widgets/cart_item_list.dart';
import 'package:custom_mp_app/app/modules/cart/widgets/cart_sliver_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartPage extends StatelessWidget {
const CartPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    final cartController = Get.find<CartController>();

    return RefreshIndicator(
      onRefresh: cartController.fetchCart ,
      child: Scaffold(
        backgroundColor: AppColors.brandBackground,
        bottomSheet:  CartCheckoutButton(),
        body: CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            
            CartSliverAppBar(),
            CartItemList(),

          ],
        ),
      ),
    );
  }
}