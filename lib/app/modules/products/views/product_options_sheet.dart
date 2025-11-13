import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/core/theme/buttons.dart';
import 'package:custom_mp_app/app/modules/products/controllers/select_variant_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';

class ProductOptionsSheet extends StatelessWidget {
  const ProductOptionsSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = SelectVariantController.to;
    final product = c.product;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {

        return Container();
        
      },
    );
  }

  
}
