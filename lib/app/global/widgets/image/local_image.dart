import 'package:flutter/material.dart';

class LocalImage extends StatelessWidget {
  final String imageUrl;
   BorderRadiusGeometry? borderRadius;
   LocalImage({
    super.key,
    required this.imageUrl,
    this.borderRadius,
  });


  @override
  Widget build(BuildContext context) {
   return Container(
  decoration: BoxDecoration(
    borderRadius: borderRadius,
  ),
  child: ClipRRect(
    borderRadius: borderRadius ?? BorderRadius.circular(0),
    child: Image.asset(
      imageUrl,
      fit: BoxFit.cover,
      width: MediaQuery.of(context).size.width,
    ),
  ),
);

  }
}
