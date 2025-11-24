import 'package:custom_mp_app/app/core/enums/order_status.dart';
import 'package:custom_mp_app/app/modules/orders/views/tabs/base_orders_tab.dart';
import 'package:flutter/material.dart';

class PendingOrdersTab extends StatelessWidget {
  const PendingOrdersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BaseOrdersTab(
      orderStatus: OrderStatus.pending,
      emptyTitle: 'No Pending Orders',
      emptySubtitle: 'Your pending orders will appear here',
    );
  }
}
