
import 'package:custom_mp_app/app/global/widgets/progress/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ContentLoader extends StatelessWidget {
const ContentLoader({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
 
                  ShimmerWidget(width: Get.size.width * 0.60, height: 16,),
                  const Gap(8),
                  ShimmerWidget(height: 16,),
                  const Gap(8),
                  ShimmerWidget(width: Get.size.width , height: 16,),
                  const Gap(8),
                  ShimmerWidget(width: Get.size.width , height: 16,),
               

              ],);
  }
}