import 'package:custom_mp_app/app/core/enums/order_status.dart';
import 'package:custom_mp_app/app/modules/orders/views/tabs/base_orders_tab.dart';
import 'package:flutter/material.dart';

class ToReceiveOrdersTab extends StatelessWidget {
  const ToReceiveOrdersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BaseOrdersTab(
      orderStatus: OrderStatus.outForDelivery,
      emptyTitle: 'No Orders To Receive',
      emptySubtitle: 'Orders out for delivery will appear here',
    );
  }
}
