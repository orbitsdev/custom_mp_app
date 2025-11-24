import 'package:custom_mp_app/app/core/enums/order_status.dart';
import 'package:custom_mp_app/app/modules/orders/views/tabs/base_orders_tab.dart';
import 'package:flutter/material.dart';

class CompletedOrdersTab extends StatelessWidget {
  const CompletedOrdersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BaseOrdersTab(
      orderStatus: OrderStatus.completed,
      emptyTitle: 'No Completed Orders',
      emptySubtitle: 'Your completed orders will appear here',
    );
  }
}
