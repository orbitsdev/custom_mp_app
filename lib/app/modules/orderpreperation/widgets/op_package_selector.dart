import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order_preparation_controller.dart';

class OpPackageSelector extends GetView<OrderPreparationController> {
  @override
  Widget build(BuildContext context) {
    final packages = controller.orderPreparation .value!.packages;

    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Packaging",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            Obx(() {
              final selectedId = controller.selectedPackageId.value;

              return Wrap(
                spacing: 12,
                children: packages.map((p) {
                  final selected = p.id == selectedId;

                  return GestureDetector(
                    onTap: () => controller.selectPackage(p.id),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: selected ? Colors.green : Colors.grey),
                      ),
                      child: Column(
                        children: [
                          Text(p.name),
                          Text("₱${p.price}"),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }
}
