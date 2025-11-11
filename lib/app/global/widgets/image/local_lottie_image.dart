// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LocalLottieImage extends StatelessWidget {
  final String imagePath;
  double? width;
  double? height;

  LocalLottieImage({Key? key, required this.imagePath, this.width, this.height})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      imagePath,
      width: width ?? null,
      height: height ?? null,
      fit: BoxFit.fill,
    );
  }
}
