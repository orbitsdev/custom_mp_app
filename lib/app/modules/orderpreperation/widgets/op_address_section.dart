import 'package:custom_mp_app/app/modules/orderpreperation/controllers/order_preparation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class OpAddressSection extends GetView<OrderPreparationController> {
  @override
  Widget build(BuildContext context) {
    final shipping = controller.orderPreparation.value!.shippingAddresses;

    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Delivery Address",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            ListTile(
              title: Text('${shipping.first.fullAddress}'),
              subtitle: Text('${shipping.first.phoneNumber}'),
            ),
          ],
        ),
      ),
    );
  }
}
