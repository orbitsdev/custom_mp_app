import 'package:custom_mp_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:custom_mp_app/app/modules/myprofile/controllers/profile_controller.dart';
import 'package:custom_mp_app/app/modules/myprofile/widgets/account_information.dart';
import 'package:custom_mp_app/app/modules/myprofile/widgets/orders_status_summary.dart';
import 'package:custom_mp_app/app/modules/myprofile/widgets/product_that_you_might_also_;like.dart';
import 'package:custom_mp_app/app/modules/myprofile/widgets/setting_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  @override
  void initState() {
    super.initState();
    // Auto-refresh order counts if stale (older than 5 minutes)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileController = Get.find<ProfileController>();
      profileController.checkAndRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final profileController = Get.find<ProfileController>();

    return RefreshIndicator(
      onRefresh: () async {
        // Refresh both user data and order counts
        await Future.wait([
          authController.refreshUserData(),
          profileController.refreshOrderCounts(),
        ]);
      },
      child: Scaffold(
        body: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            AccountInformation(),
            OrdersStatusSummary(),
            SettingNavigation(),
            ProductThatYouMightAlsoLike(),
          ],
        ),
      ),
    );
  }
}
