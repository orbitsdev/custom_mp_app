import 'package:custom_mp_app/app/modules/shippinaddress/widgets/sa_add_button_section.dart';
import 'package:custom_mp_app/app/modules/shippinaddress/widgets/sa_address_list.dart';
import 'package:custom_mp_app/app/modules/shippinaddress/widgets/sa_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import '../controllers/shipping_address_controller.dart';


class ShippingAddressPage extends StatelessWidget {
  const ShippingAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ShippingAddressController>();

    return RefreshIndicator(
      onRefresh: controller.loadAddresses,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SAAppBar(),
            SAAddButtonSection(),
            SAAddressList(),
          ],
        ),
      ),
    );
  }
}
