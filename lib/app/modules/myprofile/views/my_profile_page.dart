  import 'package:custom_mp_app/app/modules/myprofile/widgets/account_information.dart';
import 'package:custom_mp_app/app/modules/myprofile/widgets/orders_status_summary.dart';
import 'package:custom_mp_app/app/modules/myprofile/widgets/setting_navigation.dart';
import 'package:flutter/material.dart';

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {},
      child: Scaffold(
        body: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            AccountInformation(),
            SettingNavigation(),
            OrdersStatusSummary(),
              
          ]),
      ),
    );
  }
}
