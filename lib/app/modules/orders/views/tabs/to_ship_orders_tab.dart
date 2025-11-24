import 'package:custom_mp_app/app/core/enums/order_status.dart';
import 'package:custom_mp_app/app/modules/orders/views/tabs/base_orders_tab.dart';
import 'package:flutter/material.dart';

class ToShipOrdersTab extends StatelessWidget {
  const ToShipOrdersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BaseOrdersTab(
      orderStatus: OrderStatus.preparing,
      emptyTitle: 'No Orders To Ship',
      emptySubtitle: 'Orders being prepared will appear here',
    );
  }
}
