import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/data/models/cart/cart_item_model.dart';
import 'package:custom_mp_app/app/global/widgets/image/online_image.dart';
import 'package:custom_mp_app/app/global/widgets/spacing/to_sliver.dart';
import 'package:custom_mp_app/app/modules/orderpreparation/widgets/order_preparation_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sliver_tools/sliver_tools.dart';
import '../controllers/order_preparation_controller.dart';

class OpAppBar extends GetView<OrderPreparationController> {
  @override
  Widget build(BuildContext context) {
 
    return SliverAppBar(
      backgroundColor: AppColors.brand,
      leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white),onPressed: () => Get.back(),),
      title: Text('Order Summary',style: Get.textTheme.titleLarge?.copyWith(color: Colors.white),),
    );
  }
}
