// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:custom_mp_app/app/core/utils/path_helpers.dart';
import 'package:custom_mp_app/app/global/widgets/image/local_lottie_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EmptyState extends StatelessWidget {
  final double width;
  final double height;
  final String title;
  final String subtitle;
  final String? lottiePath; // <-- Optional custom animation

  const EmptyState({
    Key? key,
    this.width = 250,
    this.height = 250,
    this.title = "Empty Cart",
    this.subtitle = "Start by exploring our products and great deals",
    this.lottiePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Gap(Get.size.height * 0.10),

        /// 🎞 Lottie Animation
        SizedBox(
          width: width,
          height: height,
          child: LocalLottieImage(
            imagePath: lottiePath ?? PathHelpers.lottiesPath('empty.json'),
          ),
        ),

        const Gap(20),

        /// 🏷 TITLE
        Text(
          title,
          style: Get.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),

        const Gap(8),

        /// 📝 SUBTITLE
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            subtitle,
            style: Get.textTheme.bodyMedium?.copyWith(
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
