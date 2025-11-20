import 'package:custom_mp_app/app/global/widgets/spacing/to_sliver.dart';
import 'package:custom_mp_app/app/modules/orderpreperation/controllers/order_preparation_controller.dart';
import 'package:custom_mp_app/app/modules/orderpreperation/widgets/op_address_section.dart';
import 'package:custom_mp_app/app/modules/orderpreperation/widgets/op_app_bar.dart';
import 'package:custom_mp_app/app/modules/orderpreperation/widgets/op_cart_item_list.dart';
import 'package:custom_mp_app/app/modules/orderpreperation/widgets/op_package_selector.dart';
import 'package:custom_mp_app/app/modules/orderpreperation/widgets/op_summary_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderPreparationPage extends StatefulWidget {
  const OrderPreparationPage({super.key});

  @override
  State<OrderPreparationPage> createState() => _OrderPreparationPageState();
}

class _OrderPreparationPageState extends State<OrderPreparationPage> {
  final controller = Get.find<OrderPreparationController>();

  @override
  void initState() {
    super.initState();
    // Future.delayed( Duration.zero, () => controller.fetchOrderPreparation());
    controller.fetchOrderPreparation();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: controller.fetchOrderPreparation,
        child: Scaffold(
          body: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              OpAppBar(),
              OpAddressSection(),
              OpCartItemList(),
              OpPackageSelector(),
              OpSummarySection(),
            ],
          ),
        ),
      );
  }
}
