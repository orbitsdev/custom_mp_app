import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/modules/orderpreparation/widgets/skeleton/op_summary_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order_preparation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order_preparation_controller.dart';
import 'package:flutter/rendering.dart';
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order_preparation_controller.dart';

class OpSummarySection extends GetView<OrderPreparationController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = controller.orderPreparation.value;

      if (controller.isLoading.value || data == null) {
        return const OpSummarySkeleton();
      }

      final summary = data.summary;

      return SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            children: [
              _row("Item Total", "₱${summary.subtotal}"),
              _row("Packaging", "₱${summary.packagingFee}"),
              _row("Delivery Fee", "₱${summary.shippingFee}"),
              Divider(height: 4, color: AppColors.brandBackground),
              _row("Total", "₱${summary.total}", bold: true),
            ],
          ),
        ),
      );
    });
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
