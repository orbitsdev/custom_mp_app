// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:custom_mp_app/app/core/routes/routes.dart';
import 'package:custom_mp_app/app/core/theme/config.dart';
import 'package:custom_mp_app/app/modules/cart/controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

class CartBadge extends StatelessWidget {
  final Color? badgeColor;
  final Color? textColor;
  final Color? iconColor;
  final bool? isSolid;

  /// 🔥 Dynamic tap behavior
  final VoidCallback? onTap;

  CartBadge({
    Key? key,
    this.badgeColor,
    this.textColor,
    this.iconColor,
    this.onTap,
    this.isSolid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = CartController.instance;

    return Obx(() {
      final count = cart.carts.length;

      return Stack(
        children: [
          SizedBox(
            child: Container(
              padding: const EdgeInsets.only(top: 8),
              child: IconButton(
                onPressed: onTap ?? () => Get.toNamed(Routes.cartPage),
                icon:  HeroIcon(
                  color: iconColor ?? Colors.white,
                  HeroIcons.shoppingCart,
                  style:  isSolid == true ? HeroIconStyle.solid : HeroIconStyle.outline,
                ),
              ),
            ),
          ),

          if (count > 0)
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                decoration: BoxDecoration(
                  color: badgeColor ?? Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                child: Text(
                  '$count',
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: textColor ?? AppColors.brand,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      );
    });
  }
}
