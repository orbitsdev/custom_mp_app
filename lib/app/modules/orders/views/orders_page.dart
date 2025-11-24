import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/modules/orders/controllers/orders_controller.dart';
import 'package:custom_mp_app/app/modules/orders/views/tabs/cancelled_orders_tab.dart';
import 'package:custom_mp_app/app/modules/orders/views/tabs/completed_orders_tab.dart';
import 'package:custom_mp_app/app/modules/orders/views/tabs/pending_orders_tab.dart';
import 'package:custom_mp_app/app/modules/orders/views/tabs/to_receive_orders_tab.dart';
import 'package:custom_mp_app/app/modules/orders/views/tabs/to_ship_orders_tab.dart';
import 'package:custom_mp_app/app/modules/orders/widgets/order_custom_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersPage extends StatefulWidget {
  final int initialTabIndex;

  const OrdersPage({
    Key? key,
    this.initialTabIndex = 0,
  }) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  final controller = Get.find<OrdersController>();
  late TabController tabController;

  final List<Widget> pages = [
    const PendingOrdersTab(),
    const ToShipOrdersTab(),
    const ToReceiveOrdersTab(),
    const CompletedOrdersTab(),
    const CancelledOrdersTab(),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 5,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'My Orders',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        bottom: TabBar(
          controller: tabController,
          isScrollable: true,
          dividerColor: Colors.transparent,
            indicator: OrderCustomUnderlineTabIndicator(
              color: AppColors.orange,
            ),
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: AppColors.orange,
           
            labelColor: AppColors.orange,
            tabAlignment: TabAlignment.start,
          
            unselectedLabelStyle: Get.textTheme.bodyMedium!.copyWith(
              height: 0,
            ),
            labelStyle: Get.textTheme.bodyLarge!.copyWith(
              height: 0,
            ),
          tabs: const [
            Tab(text: 'To Pay'),
            Tab(text: 'To Ship'),
            Tab(text: 'To Receive'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: pages,
      ),
    );
  }
}
