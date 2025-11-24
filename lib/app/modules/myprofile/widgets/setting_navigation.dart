import 'package:custom_mp_app/app/core/routes/routes.dart';
import 'package:custom_mp_app/app/global/widgets/spacing/to_sliver.dart';
import 'package:custom_mp_app/app/modules/myprofile/widgets/settings_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sliver_tools/sliver_tools.dart';

class SettingNavigation extends StatelessWidget {
const SettingNavigation({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return MultiSliver(children: [
      ToSliver(child: const Gap(8)),
      SittingsListCard(
        title: "My Account",
        function: (){},
      ),

       ToSliver(child: const Gap(8)),
       SittingsListCard(
        title: "My Addresses",
        function: (){
          Get.toNamed(Routes.shippingAddressPage);
        },
      ),

      ToSliver(child: const Gap(8)),

    ]);
  }
}