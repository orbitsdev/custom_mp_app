// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';


import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/global/widgets/progress/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';



class OnlineImage extends StatelessWidget {
  final String imageUrl;

  final BorderRadiusGeometry? borderRadius;
  final BorderRadiusGeometry? borderRadiusClipRect;
  final Widget? shimmer;
  bool? isCover;
  BoxFit? fit;
  double? noImageIconSize;
  bool? enableFilter;

  OnlineImage({
    Key? key,
    required this.imageUrl,
    this.borderRadius,
    this.borderRadiusClipRect,
    this.shimmer,
    this.isCover,
    this.noImageIconSize,
    this.enableFilter  =false,
 this.fit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
    imageUrl.isEmpty
        ? Container(
           decoration: BoxDecoration(
                 borderRadius: borderRadius ?? BorderRadius.circular(2),
              color: Colors.white,
              ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Icon(
                    Icons.image,
                    size: noImageIconSize ?? 24,
                    color: AppColors.textDark,
                  ),
                ),
                // Gap(2),
                // Text(
                //   'No Image',
                //   style: Get.textTheme.bodyLarge!.copyWith(
                //         color: Palette.TEXT_DARK,
                //       ),
                // ),
              ],
            ),
          )
        : CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) => shimmer ?? ShimmerWidget( borderRadius:   borderRadius ?? BorderRadius.circular(2),),
            //  errorWidget: (context, url, error) => Icon(Icons.error),
            errorWidget: (context, url, error) => Container(
              decoration: BoxDecoration(
                 borderRadius: borderRadius ?? BorderRadius.circular(2),
              color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Icon(
                      Icons.image,
                      size: noImageIconSize ?? 24,
                      color: AppColors.textLight,
                    ),
                  ),
                  Gap(2),
                  Text(
                    'No Image',
                    style: Get.textTheme.bodySmall!.copyWith(
                          color: AppColors.textDark,
                        ),
                  ),
                ],
              ),
            ),
            errorListener: (e) {
          if (e is SocketException) {
            print('Error with ${e.address} and message ${e.message}');
          } else {
            print('Image Exception is: ${e.runtimeType}');
          }
        },
            fit: BoxFit.contain,
            width: Get.size.width,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: borderRadius ?? BorderRadius.circular(2),
                image: DecorationImage(
                  colorFilter: enableFilter == true? ColorFilter.mode(
     Colors.grey,
     BlendMode.saturation,
   ) : null,
                  image: imageProvider,
                  fit: fit ?? BoxFit.cover,
                ),
              ),
            ),
          );
  }
}
