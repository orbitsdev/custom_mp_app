import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:custom_mp_app/app/modules/auth/controllers/auth_controller.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      body: Center(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const CircularProgressIndicator();
          } else if (controller.isAuthenticated.value) {
            return const Text('Redirecting to home...');
          } else {
            return const Text('Redirecting to login...');
          }
        }),
      ),
    );
  }
}
