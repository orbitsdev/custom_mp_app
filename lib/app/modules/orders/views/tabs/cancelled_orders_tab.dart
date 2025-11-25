import 'package:custom_mp_app/app/core/enums/order_status.dart';
import 'package:custom_mp_app/app/modules/orders/views/tabs/base_orders_tab.dart';
import 'package:flutter/material.dart';

class CancelledOrdersTab extends StatelessWidget {
  const CancelledOrdersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BaseOrdersTab(
      orderStatus: OrderStatus.canceled,
      emptyTitle: 'No Cancelled Orders',
      emptySubtitle: 'Your cancelled orders will appear here',
    );
  }
}
