import 'package:custom_mp_app/app/core/routes/routes.dart';
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/global/widgets/image/online_image.dart';
import 'package:custom_mp_app/app/global/widgets/progress/shimmer_widget.dart';
import 'package:custom_mp_app/app/global/widgets/spacing/to_sliver.dart';
import 'package:custom_mp_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:custom_mp_app/app/modules/cart/widgets/cart_badge.dart';
import 'package:custom_mp_app/app/modules/notifications/widgets/notification_badge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

class AccountInformation extends StatelessWidget {
  const AccountInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Obx(() => _buildContent(authController));
  }

  Widget _buildContent(AuthController authController) {
    final isLoading = authController.isLoading.value;
    final user = authController.user.value;

    return ToSliver(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [AppColors.brandDark, AppColors.brandDark],
          ),
        ),
        height: 120,
        width: double.infinity, // Changed to double.infinity for full-width
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.profileUpdatePage);
                          },
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: isLoading || user == null
                                ? ShimmerWidget(
                                    width: 60,
                                    height: 60,
                                    borderRadius: BorderRadius.circular(100),
                                  )
                                : OnlineImage(
                                    borderRadius: BorderRadius.circular(100),
                                    imageUrl: user.profilePhotoUrl,
                                  ),
                          ),
                        ),
                        SizedBox(width: 24),

                        // User info
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Name
                              if (isLoading || user == null)
                                ShimmerWidget(
                                  width: 150,
                                  height: 18,
                                  borderRadius: BorderRadius.circular(4),
                                )
                              else
                                Text(
                                  user.name ?? 'User',
                                  style: Get.textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              const SizedBox(height: 4),
                              // Email
                              if (isLoading || user == null)
                                ShimmerWidget(
                                  width: 200,
                                  height: 14,
                                  borderRadius: BorderRadius.circular(4),
                                )
                              else
                                Text(
                                  user.email ?? '',
                                  style: Get.textTheme.bodySmall?.copyWith(
                                    color: Colors.white.withOpacity(0.85),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      // Notification Badge
                      NotificationBadge(
                        badgeColor: AppColors.error,
                        textColor: Colors.white,
                        iconColor: Colors.white,
                        onTap: () => Get.toNamed(Routes.notificationsPage),
                      ),

                      // Cart Badge
                      CartBadge(
                        badgeColor: AppColors.error,
                        textColor: Colors.white,
                        iconColor: Colors.white,
                        onTap: () => Get.toNamed(Routes.cartPage),
                      ),

                      // Settings Button
                      IconButton(
                        icon: HeroIcon(
                          HeroIcons.cog6Tooth,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: () {
                          Get.toNamed(Routes.profileUpdatePage);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
