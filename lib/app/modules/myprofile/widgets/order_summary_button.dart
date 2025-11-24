import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';

class OrderSummaryButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onPressed;
  final int notificationCount;

  const OrderSummaryButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.notificationCount = 0, // Default to 0 if no count is provided
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // Make sure the ripple effect is visible
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8), // Adjust as needed
        child: Padding(
          padding: const EdgeInsets.all(8.0), // Adjust padding as needed
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  icon,
                  Gap(4),
                  Text(
                    label,
                    style: Get.textTheme.bodySmall!.copyWith(
                          height: 0,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              if (notificationCount > 0)
                Positioned(
                  right: -6,
                  top: -12,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                    child: Center(
                      child: Text(
                        '$notificationCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
