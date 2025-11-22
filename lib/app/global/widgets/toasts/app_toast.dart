import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:custom_mp_app/app/core/theme/app_colors.dart';

class AppToast {
  static void show({
    required String message,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Color? bgColor,
    Color? textColor,
    Toast toastLength = Toast.LENGTH_SHORT,
  }) {
    Fluttertoast.showToast(
      msg: message,
      gravity: gravity,
      toastLength: toastLength,
      backgroundColor: bgColor ?? Colors.black.withOpacity(0.85),
      textColor: textColor ?? Colors.white,
      fontSize: 14.0,
    );
  }

  static void success(String message) => show(
        message: message,
        bgColor: AppColors.green,
      );

  static void error(String message) => show(
        message: message,
        bgColor: AppColors.error,
        toastLength: Toast.LENGTH_LONG
      );

  static void info(String message) => show(
        message: message,
        bgColor: AppColors.brand,
      );
}
