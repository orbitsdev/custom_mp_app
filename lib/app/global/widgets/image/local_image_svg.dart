import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LocalImageSvg extends StatelessWidget {
  final String imageUrl;
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double? height;
  final BoxFit fit;

  const LocalImageSvg({
    super.key,
    required this.imageUrl,
    this.borderRadius,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: SvgPicture.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
      ),
    );
  }
}
