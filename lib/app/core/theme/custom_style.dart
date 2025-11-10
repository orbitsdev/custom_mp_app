import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LogoStyle {
  static TextStyle avante = TextStyle(
      fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.brandDark);
  static TextStyle app =
      TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textDark);
  static TextStyle normalText = TextStyle( color: AppColors.textDark);
  static TextStyle redText =
      TextStyle(color: AppColors.error, fontWeight: FontWeight.w700);
  static TextStyle login =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark);
}