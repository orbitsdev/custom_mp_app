import 'package:custom_mp_app/app/core/routes/routes.dart';
import 'package:custom_mp_app/app/modules/cart/controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
class CartBadgeCircle extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? badgeColor;
  final Color? iconColor;

  const CartBadgeCircle({
    super.key,
    this.onTap,
    this.backgroundColor,
    this.badgeColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final cart = CartController.instance;

    return Obx(() {
      final count = cart.carts.length;

      return Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: onTap ?? () => Get.toNamed(Routes.cartPage),
            child: Container(
              margin: const EdgeInsets.only(right: 12, top: 6),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: backgroundColor ?? Colors.black.withOpacity(0.35),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  FluentIcons.cart_16_regular,
                  color: iconColor ?? Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),

          // 🔥 Improved Badge
          if (count > 0)
            Positioned(
              right: 10,
              top: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeColor ?? const Color(0xFFFF3B30), // Brighter red
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    )
                  ],
                ),
                child: Text(
                  "$count",
                  style: const TextStyle(
                    color: Colors.white, // ✔ readable
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}
