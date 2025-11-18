// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:custom_mp_app/app/core/theme/app_colors.dart';

class CartQuantityButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  final bool disable;
  const CartQuantityButton({
    Key? key,
    this.onPressed,
    required this.icon,
    required this.disable,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          backgroundColor: AppColors.brandBackground,
          padding: EdgeInsets.all(0),
        ),
        iconSize: 14,
      ),
    );
  }
}
