import 'package:custom_mp_app/app/core/routes/routes.dart';
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/global/widgets/spacing/to_sliver.dart';
import 'package:custom_mp_app/app/modules/myprofile/controllers/profile_controller.dart';
import 'package:custom_mp_app/app/modules/myprofile/widgets/order_summary_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sliver_tools/sliver_tools.dart';

class OrdersStatusSummary extends StatelessWidget {
  const OrdersStatusSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();

    return Obx(() {
      final isLoading = profileController.isLoadingOrderCounts.value;
      final toPayCount = profileController.toPayCount.value;
      final toShipCount = profileController.toShipCount.value;
      final toReceiveCount = profileController.toReceiveCount.value;

      return MultiSliver(
        children: [
          ToSliver(child: Gap(16)),
          ToSliver(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'My Orders',
                            style: Get.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed(Routes.ordesrPage),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'View All Orders',
                              style: Get.textTheme.bodyMedium!.copyWith(),
                            ),
                            Gap(4),
                            Icon(Icons.arrow_forward_ios, size: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Gap(16),
                  Container(height: 1, color: AppColors.brandBackground),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        OrderSummaryButton(
                          notificationCount: toPayCount,
                          onPressed: () {
                            // Navigate to "To Pay" tab (index 0)
                            Get.toNamed(Routes.ordesrPage, arguments: {'initialTab': 0});
                          },
                          label: 'To Pay',
                          icon: ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (Rect bounds) => LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [AppColors.orange, AppColors.brand],
                            ).createShader(bounds),
                            child: FaIcon(
                              FontAwesomeIcons.wallet,
                              color: AppColors.dimGray,
                            ),
                          ),
                        ),
                        OrderSummaryButton(
                          notificationCount: toShipCount,
                          onPressed: () {
                            // Navigate to "To Ship" tab (index 1)
                            Get.toNamed(Routes.ordesrPage, arguments: {'initialTab': 1});
                          },
                          label: 'To Ship',
                          icon: ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (Rect bounds) => LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [AppColors.orange, AppColors.brand],
                            ).createShader(bounds),
                            child: FaIcon(
                              FontAwesomeIcons.box,
                              color: AppColors.dimGray,
                            ),
                          ),
                        ),
                        OrderSummaryButton(
                          notificationCount: toReceiveCount,
                          onPressed: () {
                            // Navigate to "To Receive" tab (index 2)
                            Get.toNamed(Routes.ordesrPage, arguments: {'initialTab': 2});
                          },
                          label: 'To Receive', // Fixed typo!
                          icon: ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (Rect bounds) => LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [AppColors.orange, AppColors.brand],
                            ).createShader(bounds),
                            child: FaIcon(
                              FontAwesomeIcons.truck,
                              color: AppColors.dimGray,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ToSliver(child: Gap(16)),
        ],
      );
    });
  }
}
