  import 'package:flutter/material.dart';
  import 'package:flutter_form_builder/flutter_form_builder.dart';
  import 'package:get/get.dart';

  import 'package:custom_mp_app/app/data/repositories/auth_repository.dart';
  import 'package:custom_mp_app/app/global/widgets/modals/app_modal.dart';
  import 'package:custom_mp_app/app/global/widgets/toasts/app_toast.dart';
  import 'package:custom_mp_app/app/modules/auth/controllers/auth_controller.dart';
  import 'package:custom_mp_app/app/modules/user_device/controllers/user_device_controller.dart';
  import 'package:google_sign_in/google_sign_in.dart';

  class LoginController extends GetxController {
    final formKeyLogin = GlobalKey<FormBuilderState>();
    final AuthRepository _authRepo = AuthRepository();
    final isLoading = false.obs;
    final obscureText = true.obs;
    final isGoogleLoading = false.obs;

    // Google Sign-In scopes
    static const List<String> _scopes = <String>[
      'email',
    ];

    @override
    void onInit() {
      super.onInit();
      _initializeGoogleSignIn();
    }

    /// Initialize Google Sign-In (v7.x API)
    Future<void> _initializeGoogleSignIn() async {
      try {
        await GoogleSignIn.instance.initialize();
        print('✅ Google Sign-In initialized');
      } catch (e) {
        print('⚠️ Google Sign-In initialization failed: $e');
      }
    }

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

    /// Sign in with Google (v7.x API)
    /// Handles full OAuth flow including account selection and error cases
    Future<void> signInWithGoogle() async {
      try {
        print('🔵 [Google Sign-In] Starting Google Sign-In flow...');
        isGoogleLoading.value = true;

        // 1. Check if authentication is supported
        if (!GoogleSignIn.instance.supportsAuthenticate()) {
          print('❌ [Google Sign-In] Platform does not support authentication');
          isGoogleLoading.value = false;
          AppModal.error(
            title: 'Not Supported',
            message: 'Google Sign-In is not supported on this device',
          );
          return;
        }

        // 2. Trigger Google Sign-In (shows account picker) - v7.x API
        // authenticate() returns the authenticated user
        final GoogleSignInAccount? googleUser = await GoogleSignIn.instance.authenticate();

        // Handle case where user cancels/doesn't select account
        if (googleUser == null) {
          print('⚠️ [Google Sign-In] User cancelled account selection');
          isGoogleLoading.value = false;
          AppToast.error('Google Sign-In cancelled');
          return;
        }

        print('✅ [Google Sign-In] Account selected: ${googleUser.email}');

        // 4. Get authentication token
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final String? idToken = googleAuth.idToken;

        if (idToken == null) {
          print('❌ [Google Sign-In] Failed to get ID token');
          isGoogleLoading.value = false;
          AppModal.error(
            title: 'Google Sign-In Failed',
            message: 'Could not retrieve Google authentication token',
          );
          return;
        }

        print('🔑 [Google Sign-In] Got ID token, sending to backend...');
        AppModal.loading(title: "Signing in with Google...");

        // 5. Send token to backend
        final result = await _authRepo.signInWithGoogle(googleToken: idToken);

        AppModal.close();
        isGoogleLoading.value = false;

        result.fold(
          (failure) {
            print('❌ [Google Sign-In] Backend error: ${failure.message}');
            AppModal.error(
              title: 'Sign-In Failed',
              message: failure.message,
            );
          },
          (user) async {
            print('✅ [Google Sign-In] Success for ${user.email}');

            // Update auth state
            AuthController.instance.user.value = user;
            AuthController.instance.isAuthenticated.value = true;

            // Register device for push notifications
            print('📱 [Google Sign-In] Registering device...');
            await UserDeviceController.instance.registerDevice();

            // Navigate to home
            Get.offAllNamed('/home');
          },
        );
      } catch (e) {
        print('❌ [Google Sign-In] Unexpected error: $e');
        isGoogleLoading.value = false;
        AppModal.close();

        // Handle cancellation gracefully
        if (e.toString().contains('CANCEL') || e.toString().contains('cancel')) {
          AppToast.error('Google Sign-In cancelled');
        } else {
          AppModal.error(
            title: 'Google Sign-In Error',
            message: 'An unexpected error occurred. Please try again.',
          );
        }
      }
    }

  }
