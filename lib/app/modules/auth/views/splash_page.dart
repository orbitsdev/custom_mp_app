import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/modules/auth/controllers/splash_controller.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashController());

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.brand, AppColors.brandDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 140,
                height: 140,
              ),
              // const SizedBox(height: 20),
              // const CircularProgressIndicator(
              //   color: Colors.white,
              //   strokeWidth: 3,
              // ),
              // const SizedBox(height: 12),
              // Text(
              //   'Preparing your experience...',
              //   style: Get.textTheme.bodyMedium?.copyWith(
              //     color: Colors.white,
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
