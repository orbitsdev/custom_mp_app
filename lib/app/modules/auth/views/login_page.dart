
import 'package:custom_mp_app/app/core/theme/buttons.dart';
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/modules/auth/controllers/login_controller.dart';
import 'package:custom_mp_app/app/modules/auth/views/signup_page.dart';
import 'package:custom_mp_app/app/modules/agreement/views/privacy_policy_page.dart';
import 'package:custom_mp_app/app/modules/agreement/views/terms_of_use_page.dart';

import 'package:custom_mp_app/app/modules/auth/widgets/label.dart';
import 'package:custom_mp_app/app/modules/auth/widgets/logo.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 8,
            right: 8,
            bottom: 60.0,
          ),
          child: Column(
            children: [
              Gap(Get.size.height * 0.02),
              Container(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 34,
                  bottom: 30,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14)),
                child: Column(
                  children: [
                    const Logo(),
                    const Gap(32),
                    Text(
                      'LOGIN',
                      style: Get.textTheme.titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Gap(32),
                    GetBuilder<LoginController>(builder: (controller) {
                      return FormBuilder(
                        key: controller.formKeyLogin,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Label(text: 'Email'),
                            const Gap(6),
                            FormBuilderTextField(
                              autocorrect: false,
                              enableSuggestions:true,
                              autofillHints: const [AutofillHints.email],
                              initialValue: 'orbinobrian0506@gmail.com',
                              style: Get.textTheme.bodyMedium!
                                  .copyWith(color: AppColors.textDark),
                              name: 'email',
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.brandBackground,
                                // labelText: '',
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal:
                                        10), // Adjust the vertical padding here
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 2.0, color: AppColors.brand),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1.0, color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1.0, color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1.0, color: AppColors.error),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.email(),
                              ]),
                            ),
                            const Gap(16),
                            const Label(text: 'Password'),
                            const Gap(6),
                            FormBuilderTextField(
                              initialValue: 'password',
                              style: Get.textTheme.bodyMedium!
                                  .copyWith(color: AppColors.textDark),
                              name: 'password',
                              decoration: InputDecoration(
                                fillColor: AppColors.brandBackground,
                                filled: true,
                                // labelText: 'Password',
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal:
                                        10), // Adjust the vertical padding here
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 2.0, color: AppColors.brand),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1.0, color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1.0, color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                suffixIcon: SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: IconButton(
                                    icon: Icon(
                                     
                                      controller.obscureText.value
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                   onPressed: controller.togglePasswordVisibility, 
                                  ),
                                ),
                              ),
                              obscureText: controller.obscureText.value,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.minLength(6),
                              ]),
                            ),
                            const Gap(16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                RichText(
                                  text: TextSpan(
                                      text: '',
                                      style: Get.textTheme.bodyMedium
                                          ?.copyWith(color: AppColors.textDark),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'Forgot Password?',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.brandDark),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                             
                                              }),
                                      ]),
                                ),
                              ],
                            ),
                            const Gap(24),

                           SizedBox(
  height: 50,
  width: Get.size.width,
  child: GradientElevatedButton(
    onPressed: controller.isLoading.value
        ? null
        : () => controller.submitLogin(),
    style: GRADIENT_ELEVATED_BUTTON_STYLE,
    child: Obx(() => controller.isLoading.value
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(color: Colors.white),
          )
        : Text(
            'Login',
            style: Get.textTheme.bodyLarge?.copyWith(color: Colors.white),
          )),
  ),
),

                           
                          ],
                        ),
                      );
                    }),
                    const Gap(24),
                    RichText(
                      text: TextSpan(
                          text: 'Dont have an account?',
                          style: Get.textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textDark),
                          children: <TextSpan>[
                            TextSpan(
                                text: ' Signup',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.brandDark),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {

                                    Get.to(() => SignupPage(), transition: Transition.cupertino);
                                  
                                  }),
                          ]),
                    ),
                    const Gap(24),
                    Container(
                      child: Row(
                        children: [
                          Flexible(
                              child: Container(
                            height: 2,
                            width: Get.size.width,
                            color: AppColors.brandBackground,
                          )),
                          Gap(8),
                          Text(
                            'Or',
                            style: Get.textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textLight),
                          ),
                          Gap(8),
                          Flexible(
                              child: Container(
                            height: 2,
                            color: AppColors.brandBackground,
                          )),
                        ],
                      ),
                    ),
                    GetBuilder<LoginController>(builder: (controller) {
                      return Obx(() => SizedBox(
                            height: 50,
                            width: Get.size.width,
                            child: ElevatedButton.icon(
                              style: ELEVATED_BUTTON_SOCIALITE_STYLE,
                              onPressed: controller.isGoogleLoading.value
                                  ? null
                                  : () => controller.signInWithGoogle(),
                              icon: controller.isGoogleLoading.value
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : SvgPicture.asset(
                                      height: 24,
                                      width: 24,
                                      'assets/images/google-logo.svg',
                                      semanticsLabel: 'Google Logo',
                                    ),
                              label: Text(
                                controller.isGoogleLoading.value
                                    ? 'Signing in...'
                                    : 'Continue with Google',
                                style: Get.textTheme.bodyMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ));
                    }),
                  ],
                ),
              ),
              const Gap(24),
              Container(
                width: MediaQuery.of(context).size.width * 0.70,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: 'By signing up, you agree to the',
                      style: Get.textTheme.bodyMedium
                          ?.copyWith(color: Colors.white),
                      children: <TextSpan>[
                        TextSpan(
                            text: ' Terms of Service',
                            style: Get.textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(() => const TermsOfUsePage(), preventDuplicates: false);
                              }),
                        TextSpan(
                          text: ' and acknowledge you’ve read our',
                          style: Get.textTheme.bodyMedium
                              ?.copyWith(color: Colors.white),
                        ),
                        TextSpan(
                            text: ' Privacy Policy.',
                            style: Get.textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(() => const PrivacyPolicyPage(), preventDuplicates: false);
                              }
                              
                              ),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
