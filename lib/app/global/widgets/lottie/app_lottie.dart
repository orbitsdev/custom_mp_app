import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AppLottie extends StatelessWidget {



  final String asset;
  final double? width;
  final double? height;
  final BoxFit fit;

  const AppLottie({
    super.key,
    required this.asset,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      asset,
      width: width,
      height: height,
      fit: fit,
    );
  }
}


class AppLotties {
 static const String basePath = 'assets/lotties/';

  static const String success = '${basePath}order-success.json';
  static const String maintenance = '${basePath}under_construction.json'; // or a red variant
  static const String error = '${basePath}error.json'; // or a red variant
  static const String confirm = '${basePath}question.json';
  static const String loading = '${basePath}box.json';
  static const String empty = '${basePath}empty.json';
}