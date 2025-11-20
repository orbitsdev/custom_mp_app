import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order_preparation_controller.dart';

class OpSummarySection extends GetView<OrderPreparationController> {
  @override
  Widget build(BuildContext context) {
    final summary = controller.orderPreparation .value!.summary;

    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          children: [
            _row("Item Total", "₱${summary.subtotal}"),
            _row("Packaging", "₱${summary.packagingFee}"),
            _row("Delivery Fee", "₱${summary.shippingFee}"),

            const Divider(height: 28),

            _row("Total",
                "₱${summary.total}",
                bold: true),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value,
              style: TextStyle(
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
