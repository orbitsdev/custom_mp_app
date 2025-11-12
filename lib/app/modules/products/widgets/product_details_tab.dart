// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/data/models/products/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ProductDetailsTab extends StatelessWidget {
  final ProductModel product;
  final String title; 
  final Function function;
  final bool isSelected;
  const ProductDetailsTab({
    Key? key,
    required this.product,
    required this.title,
    required this.function,
    required this.isSelected,
  }) : super(key: key);
 
  

  @override
  Widget build(BuildContext context){
   return GestureDetector(
      onTap: () => function(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical:0),
        decoration: BoxDecoration(
           color: isSelected ? AppColors.gainsboro : Colors.white,
         borderRadius:BorderRadius.circular(4),
        
        ),
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        child: Center(
          child: Text(
            title,
            style: Get.textTheme.bodyMedium!.copyWith(
              color: isSelected ? AppColors.textDark : AppColors.textLight,
              fontWeight: isSelected ? FontWeight.normal : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
