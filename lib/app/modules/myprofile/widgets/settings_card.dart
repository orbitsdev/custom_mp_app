
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SittingsListCard extends StatelessWidget {
  final String title;
  final String? content;
  final Function? function;
  final bool? showIcon;
   double? iconSize;
  EdgeInsetsGeometry? padding;
  
   SittingsListCard({
    Key? key,
    required this.title,
    this.content,
    this.function,
    this.showIcon,
    this.padding,
    this.iconSize,
  }) : super(key: key);
  


  Color get grayTextLight => Colors.grey; // Define grayTextLight

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          function!();
        },
        child: Ink(
          color: Colors.white, // Set the background color using Ink
          child: Container(
            padding: padding ??EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), // Optional: Add border radius
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Get.textTheme.bodyMedium,
                      ),
                      if (content != null)
                        Text(
                          content!,
                          style: Get.textTheme.bodySmall!.copyWith(color: grayTextLight),
                        ),
                    ],
                  ),
                ),
               if(showIcon == true) Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: iconSize?? 14,
                  color: AppColors.textDark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
