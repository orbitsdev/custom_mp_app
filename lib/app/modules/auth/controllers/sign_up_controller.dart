import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:custom_mp_app/app/data/repositories/auth_repository.dart';
import 'package:custom_mp_app/app/modules/auth/controllers/auth_controller.dart';

class SignupController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final _authRepo = AuthRepository();

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    final result = await _authRepo.register(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      passwordConfirmation: confirmPasswordController.text.trim(),
    );

    result.fold(
      (error) => Get.snackbar('Error', error,
          snackPosition: SnackPosition.BOTTOM, colorText: Colors.white),
      (user) {
        AuthController.instance.user.value = user;
        AuthController.instance.isAuthenticated.value = true;
        Get.offAllNamed('/home');
      },
    );

    isLoading.value = false;
  }
}
