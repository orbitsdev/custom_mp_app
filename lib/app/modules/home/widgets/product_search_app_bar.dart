import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/modules/products/widgets/product_search_field.dart';
import 'package:flutter/material.dart';

class ProductSearchAppBar extends StatelessWidget {


  const ProductSearchAppBar({
    super.key,
   
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppColors.brand,
      automaticallyImplyLeading: false,
      title: ProductSearchField(),
    );
  }
}
