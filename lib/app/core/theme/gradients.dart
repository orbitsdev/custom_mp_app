import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppGradients {
  static  LinearGradient primary = LinearGradient(
    colors: [AppColors.brand, AppColors.brandDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static  LinearGradient secondary = LinearGradient(
    colors: [AppColors.brandLight, AppColors.brand],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
