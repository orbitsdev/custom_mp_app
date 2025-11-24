
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationBadge extends StatelessWidget {
  final Widget icon;
  final int value;
  final VoidCallback action;
   Color? badgeColor; 
   Color? textColor; 
   NotificationBadge({
    Key? key,
    required this.icon,
    required this.value,
    required this.action,
    this.badgeColor,
    this.textColor,
  }) : super(key: key);
  


  @override
  Widget build(BuildContext context){
    return  Stack(
            children: [
            SizedBox(
              
              child: Container(
                padding: EdgeInsets.only(top: 8),
                child: IconButton(onPressed: action, icon: icon,)),),
          if( value > 0) Positioned(
                   right: 6,
                top: 6,
                child:  Container(
                  // color: Colors.red,
                  decoration:  BoxDecoration(
                    // border: Border.all(color: Colors.white),
                    color:badgeColor ?? Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  constraints: BoxConstraints(
                 minWidth: 14,
                    minHeight: 14,
                  ),
                  child: Text(
                    value > 0 ? '$value': '',
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: AppColors.brand,
                      fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],

      );
  }
}
