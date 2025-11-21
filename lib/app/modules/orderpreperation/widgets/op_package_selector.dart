import 'package:custom_mp_app/app/global/widgets/spacing/to_sliver.dart';
import 'package:custom_mp_app/app/modules/orderpreperation/widgets/skeleton/op_package_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliver_tools/sliver_tools.dart';
import '../controllers/order_preparation_controller.dart';

import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/modules/orderpreperation/controllers/order_preparation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';

class OpPackageSelector extends GetView<OrderPreparationController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = controller.orderPreparation.value;

      /// 🔥 LOADING STATE
      if (controller.isLoading.value) return const OpPackageSkeleton();

      /// 🔥 NO PACKAGES
      if (data == null || data.packages.isEmpty) {
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      }

      return MultiSliver(
        children: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(12)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Packaging",
                    style: Get.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Gap(10),

                  /// WRAP BUTTONS
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: data.packages.map((pkg) {
                      final isSelected =
                          controller.selectedPackageId.value == pkg.id;

                      return GestureDetector(
                        onTap: () => controller.selectPackage(pkg.id),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.brandLight
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.brandDark
                                  : Colors.grey.shade300,
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.brandDark.withOpacity(
                                        0.2,
                                      ),
                                      blurRadius: 5,
                                      offset: Offset(1, 2),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isSelected) ...[
                                Icon(
                                  Icons.check_circle,
                                  color: AppColors.brandDark,
                                  size: 18,
                                ),
                                const Gap(6),
                              ],
                              Text(
                                pkg.name,
                                style: Get.textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Gap(6),
                              Text(
                                "(₱${pkg.price})",
                                style: Get.textTheme.bodySmall!.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          ToSliver(child: Gap(8)),
        ],
      );
    });
  }
}
