import 'package:custom_mp_app/app/core/routes/routes.dart';
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/global/widgets/spacing/to_sliver.dart';
import 'package:custom_mp_app/app/global/widgets/modals/app_modal.dart';
import 'package:custom_mp_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:custom_mp_app/app/modules/myprofile/widgets/settings_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sliver_tools/sliver_tools.dart';

class SettingNavigation extends StatelessWidget {
  const SettingNavigation({Key? key}) : super(key: key);

  Future<void> _showLogoutDialog() async {
    final confirmed = await AppModal.confirm(
      title: 'Logout',
      message: 'Are you sure you want to logout from your account?',
      confirmText: 'Logout',
      cancelText: 'Cancel',
      barrierDismissible: true,
    );

    if (confirmed == true) {
      final authController = Get.find<AuthController>();
      authController.logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [


        // Account Section
        SittingsListCard(
          title: "My Account",
          content: "View and edit your profile information",
          showIcon: true,
          function: () {
            Get.toNamed(Routes.profileUpdatePage);
          },
        ),

        ToSliver(child: const Gap(1)),

        SittingsListCard(
          title: "My Addresses",
          content: "Manage your shipping addresses",
          showIcon: true,
          function: () {
            Get.toNamed(Routes.shippingAddressPage);
          },
        ),

        ToSliver(child: const Gap(8)),

        // Settings Section
        SittingsListCard(
          title: "Notifications",
          content: "Manage notification preferences",
          showIcon: true,
          function: () {
            // TODO: Navigate to notifications settings
            Get.snackbar(
              'Coming Soon',
              'Notification settings will be available soon',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        ),

        ToSliver(child: const Gap(1)),

        SittingsListCard(
          title: "Payment Methods",
          content: "Manage your payment options",
          showIcon: true,
          function: () {
            // TODO: Navigate to payment methods page
            Get.snackbar(
              'Coming Soon',
              'Payment methods will be available soon',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        ),

        ToSliver(child: const Gap(8)),

        // Support Section
        SittingsListCard(
          title: "Help & Support",
          content: "Get help and contact support",
          showIcon: true,
          function: () {
            // TODO: Navigate to help page
            Get.snackbar(
              'Coming Soon',
              'Help center will be available soon',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        ),

        ToSliver(child: const Gap(1)),

        SittingsListCard(
          title: "About",
          content: "App information and legal",
          showIcon: true,
          function: () {
            Get.toNamed(Routes.aboutPage);
          },
        ),

        ToSliver(child: const Gap(8)),

        // Logout Button
        SittingsListCard(
          title: "Logout",
          content: "Sign out of your account",
          showIcon: false,
          function: _showLogoutDialog,
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),

        ToSliver(child: const Gap(16)),
      ],
    );
  }
}
