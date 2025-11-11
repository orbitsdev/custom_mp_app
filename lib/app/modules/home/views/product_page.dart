import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/modules/home/widgets/home_drawer.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandBackground,
      drawer: HomeDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(58.0),
        child: AppBar(
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0,
          backgroundColor: AppColors.brand,
           flexibleSpace: Container(
              decoration: BoxDecoration(color: AppColors.brandDark),
            ),
        ),
      ),
      body: Container(child: Center(child: Text('Product Page'))),
    );
  }
}
