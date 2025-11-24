import 'package:custom_mp_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:custom_mp_app/app/modules/myprofile/widgets/account_information.dart';
import 'package:custom_mp_app/app/modules/myprofile/widgets/orders_status_summary.dart';
import 'package:custom_mp_app/app/modules/myprofile/widgets/product_that_you_might_also_;like.dart';
import 'package:custom_mp_app/app/modules/myprofile/widgets/setting_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return RefreshIndicator(
      onRefresh: () => authController.refreshUserData(),
      child: Scaffold(
        body: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            AccountInformation(),
            SettingNavigation(),
            OrdersStatusSummary(),
            ProductThatYouMightAlsoLike()
              
          ]),
      ),
    );
  }
}
