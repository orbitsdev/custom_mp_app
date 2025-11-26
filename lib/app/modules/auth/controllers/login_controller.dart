import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:custom_mp_app/app/data/repositories/auth_repository.dart';
import 'package:custom_mp_app/app/global/widgets/modals/app_modal.dart';
import 'package:custom_mp_app/app/global/widgets/toasts/app_toast.dart';
import 'package:custom_mp_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:custom_mp_app/app/modules/user_device/controllers/user_device_controller.dart';

class LoginController extends GetxController {
  final formKeyLogin = GlobalKey<FormBuilderState>();
  final AuthRepository _authRepo = AuthRepository();
  final isLoading = false.obs;
  final obscureText = true.obs;

  /// Toggle password visibility
  void togglePasswordVisibility() {
    obscureText.value = !obscureText.value;
    update();
  }

  /// Handle login submission
  Future<void> submitLogin() async {
 
  if (!formKeyLogin.currentState!.saveAndValidate()) {
    AppToast.error("Please complete all fields correctly.");
    return;
  }


  final formData = formKeyLogin.currentState!.value;
  final email = formData['email'];
  final password = formData['password'];


  print('[DEBUG] Raw formData: $formData');
  print('[DEBUG] Logging in with email: $email');


  isLoading.value = true;
  AppModal.loading(title: "Signing in...");

 
  final result = await _authRepo.login(email: email, password: password);

  
  AppModal.close();
  isLoading.value = false;

  
  result.fold(
    (failure) {

      AppModal.error(
        title: "Login Failed",
        message: failure.message,
      );
    },
    (user) async {

      // print(user.toString());
        AuthController.instance.user.value = user;
          AuthController.instance.isAuthenticated.value = true;

          // Register device for push notifications
          print('📱 [LoginController] Registering device after login...');
          await UserDeviceController.instance.registerDevice();

          Get.offAllNamed('/home'); // ✅ replace with your home route
      //
    },
  );
}

}
