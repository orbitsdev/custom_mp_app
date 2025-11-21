import 'package:custom_mp_app/app/modules/shippinaddress/widgets/sa_address_actions_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/data/models/shippingaddress/shipping_address_model.dart';

class SaAddressCard extends StatelessWidget {
  final ShippingAddressModel address;
  final bool isSelected;
  final bool enableSelection;

  const SaAddressCard({
    Key? key,
    required this.address,
    this.isSelected = false,
    this.enableSelection = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showAddressActionsSheet(address),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.brandDark : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ADDRESS TYPE + DEFAULT BADGE
            Row(
              children: [
                Text(
                  address.type.toUpperCase(),
                  style: Get.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),

                if (address.isDefault) ...[
                  const Gap(10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.brandLight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "Default",
                      style: Get.textTheme.bodySmall!.copyWith(
                        color: AppColors.brandDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),

            const Gap(12),

            /// NAME + CONTACT
            Text(
              "${address.fullName} | ${address.phoneNumber}",
              style: Get.textTheme.bodyMedium!.copyWith(
                color: AppColors.textDark,
              ),
            ),

            const Gap(8),

            /// FULL ADDRESS
            Text(
              "${address.street}, ${address.barangay.name}",
              style: Get.textTheme.bodySmall!.copyWith(
                height: 1.4,
                color: AppColors.textLight,
              ),
            ),

            Text(
              "${address.municipality.name}, "
              "${address.province.name}, "
              "${address.region.name} "
              "${address.postalCode}",
              style: Get.textTheme.bodySmall!.copyWith(
                height: 1.4,
                color: AppColors.textLight,
              ),
            ),

            const Gap(10),

            /// CHECKMARK (when selected)
            if (isSelected && enableSelection)
              Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.check_circle,
                  color: AppColors.brandDark,
                  size: 22,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
