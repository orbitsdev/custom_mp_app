import 'package:custom_mp_app/app/modules/products/controllers/select_variant_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OptionQuantityPicker extends StatelessWidget {
  final SelectVariantController controller;
  const OptionQuantityPicker({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: controller.qty.value > 1
                ? () => controller.qty.value--
                : null,
            icon: const Icon(Icons.remove_circle_outline),
          ),
          Obx(() => Text(
                controller.qty.value.toString(),
                style: Get.textTheme.titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              )),
          IconButton(
            onPressed: () => controller.qty.value++,
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
    );
  }
}
