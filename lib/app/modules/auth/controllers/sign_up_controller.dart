import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:custom_mp_app/app/data/repositories/auth_repository.dart';
import 'package:custom_mp_app/app/global/widgets/modals/app_modal.dart';
import 'package:custom_mp_app/app/global/widgets/toasts/app_toast.dart';
import 'package:custom_mp_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:custom_mp_app/app/modules/user_device/controllers/user_device_controller.dart';

class SignupController extends GetxController {
  final formKeySignup = GlobalKey<FormBuilderState>();
  final AuthRepository _authRepo = AuthRepository();

  final isLoading = false.obs;
  final obscureText = true.obs;
  final obscureConfirmText = true.obs;

  /// Toggle password visibility
  void togglePasswordVisibility() {
    obscureText.value = !obscureText.value;
    update();
  }

  /// Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    obscureConfirmText.value = !obscureConfirmText.value;
    update();
  }

  /// Handle signup submission
  Future<void> submitSignup() async {
    if (!formKeySignup.currentState!.saveAndValidate()) {
      AppToast.error("Please fill out all fields correctly.");
      return;
    }

    final formData = formKeySignup.currentState!.value;
    final name = formData['name'];
    final email = formData['email'];
    final password = formData['password'];
    final confirmPassword = formData['password_confirmation'];

    print('[DEBUG] Signup formData: $formData');

    isLoading.value = true;
    AppModal.loading(title: "Creating account...");

    final result = await _authRepo.register(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: confirmPassword,
    );

    AppModal.close();
    isLoading.value = false;

    result.fold(
      (failure) {
        AppModal.error(title: "Signup Failed", message: failure.message);
      },
      (user) async {
        AuthController.instance.user.value = user;
            AuthController.instance.isAuthenticated.value = true;

            // Register device for push notifications
            print('📱 [SignupController] Registering device after signup...');
            await UserDeviceController.instance.registerDevice();

            Get.offAllNamed('/home'); // redirect after signup
      },
    );
  }
}
