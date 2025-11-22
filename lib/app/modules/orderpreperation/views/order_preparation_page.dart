import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/modules/orderpreparation/controllers/order_preparation_controller.dart';
import 'package:custom_mp_app/app/modules/orderpreparation/widgets/op_address_section.dart';
import 'package:custom_mp_app/app/modules/orderpreparation/widgets/op_app_bar.dart';
import 'package:custom_mp_app/app/modules/orderpreparation/widgets/op_cart_item_list.dart';
import 'package:custom_mp_app/app/modules/orderpreparation/widgets/op_package_selector.dart';
import 'package:custom_mp_app/app/modules/orderpreparation/widgets/op_place_order_button.dart';
import 'package:custom_mp_app/app/modules/orderpreparation/widgets/op_summary_section.dart';

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
    controller.fetchOrderPreparation();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: controller.fetchOrderPreparation,
        child: Scaffold(
        bottomNavigationBar: OPPlaceOrderButton(),
          backgroundColor: AppColors.brandBackground,
          body: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              OpAppBar(),
              OpAddressSection(),
              OpCartItemList(),
              OpPackageSelector(),
              OpSummarySection()
              
            ],
          ),
        ),
      );
  }
}
