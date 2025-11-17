import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/modules/products/controllers/select_variant_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OptionAttributeSelector extends StatelessWidget {
  final SelectVariantController controller;
  const OptionAttributeSelector({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final grouped = controller.groupedOptions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: grouped.entries.map((entry) {
        final attr = entry.key;
        final options = entry.value;
        final attrIndex = controller.attributeOrder.indexOf(attr);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              attr,
              style: Get.textTheme.titleSmall!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: options.map((opt) {
                return Obx(() {
                  final disabled =
                      controller.disabledOptions.contains(opt.id);
                  final isSelected =
                      controller.selectedOptions[attrIndex] == opt.id;

                  return GestureDetector(
                    onTap: disabled
                        ? null
                        : () => controller.pickOption(attr, opt.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 120),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: _chipColor(isSelected, disabled),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: _chipBorder(isSelected, disabled),
                        ),
                      ),
                      child: Text(
                        opt.name,
                        style: TextStyle(
                          color: _chipText(isSelected, disabled),
                        ),
                      ),
                    ),
                  );
                });
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],
        );
      }).toList(),
    );
  }

  Color _chipColor(bool selected, bool disabled) {
    if (disabled) return Colors.grey.shade200;
    if (selected) return AppColors.brand;
    return Colors.grey.shade100;
  }

  Color _chipBorder(bool selected, bool disabled) {
    if (disabled) return Colors.grey.shade300;
    if (selected) return AppColors.brand;
    return Colors.grey.shade400;
  }

  Color _chipText(bool selected, bool disabled) {
    if (disabled) return Colors.grey;
    if (selected) return Colors.white;
    return Colors.black87;
  }
}
