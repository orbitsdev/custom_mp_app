import 'package:custom_mp_app/app/core/routes/routes.dart';
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/modules/notifications/controllers/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

/// Notification Badge
///
/// Shows notification icon with unread count badge
class NotificationBadge extends StatelessWidget {
  final Color? badgeColor;
  final Color? textColor;
  final Color? iconColor;
  final VoidCallback? onTap;

  const NotificationBadge({
    Key? key,
    this.badgeColor,
    this.textColor,
    this.iconColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = NotificationController.instance;

    return Obx(() {
      final count = controller.unreadCount;

      return Stack(
        children: [
          SizedBox(
            child: Container(
              padding: const EdgeInsets.only(top: 8),
              child: IconButton(
                onPressed: onTap ?? () => Get.toNamed(Routes.notificationsPage),
                icon: HeroIcon(
                  color: iconColor ?? Colors.white,
                  HeroIcons.bell,
                  style: HeroIconStyle.outline,
                ),
              ),
            ),
          ),

          if (count > 0)
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: badgeColor ?? AppColors.error,
                  borderRadius: BorderRadius.circular(20),
                ),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: Text(
                  count > 99 ? '99+' : '$count',
                  style: TextStyle(
                    color: textColor ?? Colors.white,
                    fontSize: 10,
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
