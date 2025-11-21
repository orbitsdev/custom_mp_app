import 'package:custom_mp_app/app/core/routes/routes.dart';
import 'package:custom_mp_app/app/core/theme/config.dart';
import 'package:custom_mp_app/app/global/widgets/spacing/to_sliver.dart';
import 'package:custom_mp_app/app/modules/orderpreperation/controllers/order_preparation_controller.dart';
import 'package:custom_mp_app/app/modules/orderpreperation/widgets/skeleton/op_shipping_address_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
class OpAddressSection extends GetView<OrderPreparationController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      /// 🔥 1. Show shimmer while fetching data
      if (controller.isLoading.value) {
        return const OpShippingAddressSkeleton();
      }

      final data = controller.orderPreparation.value;

      /// 🔥 2. No data after loading = safe fallback
      if (data == null) {
        return const SliverToBoxAdapter(
          child: SizedBox(height: 1),
        );
      }

      final addresses = data.shippingAddresses;

      /// 🔥 3. No addresses available
      if (addresses.isEmpty) {
        return const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text("No shipping address found"),
          ),
        );
      }

      /// 🔥 4. Determine selected address
      final selected = addresses.firstWhereOrNull(
            (a) => a.id == data.selectedShippingAddressId,
          ) ??
          addresses.first;

      /// 🔥 5. Actual UI
      return SliverToBoxAdapter(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      HeroIcon(HeroIcons.mapPin, color: AppColors.brandDark),
                      const SizedBox(width: 8),
                      Text(
                        "Shipping Address",
                        style: Get.textTheme.titleMedium,
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                        Get.toNamed(Routes.shippingAddressPage);
                    },
                    child: Row(
                      children: [
                        Text(
                          "Change",
                          style: Get.textTheme.bodyMedium?.copyWith(
                            color: AppColors.brandDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        HeroIcon(
                          HeroIcons.pencilSquare,
                          size: 18,
                          color: AppColors.brandDark,
                        )
                      ],
                    ),
                  )
                ],
              ),

              const Gap(12),

              /// NAME + CONTACT
              Text(
                selected.fullName?.toUpperCase() ?? "",
                style: Get.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                selected.phoneNumber ?? "",
                style: Get.textTheme.bodySmall!.copyWith(
                  color: Colors.grey.shade700,
                ),
              ),

              const Gap(8),

              /// FULL ADDRESS
              Text(
                selected.fullAddress ?? "",
                style: Get.textTheme.bodySmall!.copyWith(
                  height: 1.3,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
