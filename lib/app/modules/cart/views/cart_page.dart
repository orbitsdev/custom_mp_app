import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/modules/cart/controllers/cart_controller.dart';
import 'package:custom_mp_app/app/modules/cart/widgets/cart_checkout_button.dart';
import 'package:custom_mp_app/app/modules/cart/widgets/cart_item_list.dart';
import 'package:custom_mp_app/app/modules/cart/widgets/cart_sliver_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final cartController = Get.find<CartController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await cartController.fetchCart().then((_) async {
      
        if (cartController.hasSelectedItems) {
          cartController.fetchCartSummary();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: cartController.fetchCart,
      child: Obx(
        () => Scaffold(
          backgroundColor: AppColors.brandBackground,
          // Only show bottomSheet when cart is not empty
          bottomSheet: cartController.carts.isNotEmpty
              ? CartCheckoutButton()
              : null,
          body: CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            slivers: [
              CartSliverAppBar(),
              CartItemList(),
            ],
          ),
        ),
      ),
    );
  }
}
