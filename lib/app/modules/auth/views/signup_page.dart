
import 'package:custom_mp_app/app/core/theme/config.dart';
import 'package:custom_mp_app/app/modules/auth/controllers/login_controller.dart';
import 'package:custom_mp_app/app/modules/auth/controllers/sign_up_controller.dart';
import 'package:custom_mp_app/app/modules/auth/widgets/label.dart';
import 'package:custom_mp_app/app/modules/auth/widgets/logo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColors.brandDark,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(onPressed: (){
          Get.back();
        }, icon: Icon(Icons.arrow_back, color: Colors.white,)),
      ),
      body: SafeArea(
        
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 8,
            right: 8,
          
            bottom: 60.0,
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 24,
                  bottom: 24,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(),
                    Center(child: Logo()),
                    Gap(16),
                      Text('SIGNUP', style: Get.textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold
                     ),),
                    const   Gap(32),
                      GetBuilder<SignupController>(builder: (controller) {
                        return FormBuilder(
                          key: controller.formKeySignup,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                             const Label(text: 'Name'),
                              const Gap(6),
                              FormBuilderTextField(
                                initialValue: 'User',
                                style: Get.textTheme.bodyMedium!
                                  .copyWith(color: AppColors.textDark),
                                name: 'name',
                                decoration: InputDecoration(
                                  
                                  filled: true,
                                  fillColor: AppColors.brandBackground,
                                  // labelText: '',
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal:
                                          10), // Adjust the vertical padding here
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(width: 2.0, color: AppColors.brand),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.0, color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.0, color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(width: 1.0, color: Colors.red),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                  
                                  
                                ]),
                              ),
                                   Gap(16),
                                 const Label(text: 'Email '),
                              const Gap(6),
                              FormBuilderTextField(
                                initialValue: '@gmail.com',
                                autocorrect: false,
                              enableSuggestions:true,
                              autofillHints: const [AutofillHints.email],
                               style: Get.textTheme.bodyMedium!
                                  .copyWith(color: AppColors.textDark),
                                name: 'email',
                                decoration: InputDecoration(
                                  
                                  filled: true,
                                  fillColor: AppColors.brandBackground,
                                  // labelText: '',
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal:
                                          10), // Adjust the vertical padding here
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(width: 2.0, color: AppColors.brand),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.0, color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.0, color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(width: 1.0, color: AppColors.error ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                  // FormBuilderValidators.email(),
                                ]),
                              ),
                            
                              Gap(16),
                              const Label(text: 'Password'),
                              const Gap(6),
                              FormBuilderTextField(
                                initialValue: '@Password2!!',
                              style: Get.textTheme.bodyMedium!
                                  .copyWith(color: AppColors.textDark),
                                name: 'password',
                                decoration: InputDecoration(
                                  fillColor: AppColors.brandBackground,
                                  filled: true,
                                  // labelText: 'Password',
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal:
                                          10), // Adjust the vertical padding here
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(width: 2.0, color: AppColors.brand),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.0, color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.0, color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  suffixIcon: SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: IconButton(
                                      icon: Icon(
                                        controller.obscureText.value
                                            ? Icons.visibility
                                            : Icons.visibility_off,
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
                              Gap(16),
                              const Label(text: 'Confirm Password'),
                              const Gap(6),
                              FormBuilderTextField(
                                initialValue: '@Password2!!',
                              style: Get.textTheme.bodyMedium!
                                  .copyWith(color: AppColors.textDark),
                                name: 'password_confirmation',
                                decoration: InputDecoration(
                                  fillColor: AppColors.brandBackground,
                                  filled: true,
                                  // labelText: 'Password',
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal:
                                          10), // Adjust the vertical padding here
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(width: 2.0, color: AppColors.brand),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.0, color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.0, color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  suffixIcon: SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: IconButton(
                                      icon: Icon(
                                        controller.obscureConfirmText.value
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: controller.toggleConfirmPasswordVisibility,
                                    ),
                                  ),
                                ),
                                obscureText: controller.obscureConfirmText.value,
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.minLength(6),
                                ]),
                              ),
                           
                                
                              ]),
                        );
                      }
                    ),
                    
                 
                       const Gap(32),
                   GetBuilder<SignupController>(
  builder: (controller) {
    return SizedBox(
      height: 50,
      width: Get.size.width,
      child: GradientElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.submitSignup,
        style: GRADIENT_ELEVATED_BUTTON_STYLE,
        child: controller.isLoading.value
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                'Create Account',
                style: Get.textTheme.bodyLarge?.copyWith(color: Colors.white),
              ),
      ),
    );
  },
),


                      const  Gap(24),
                    RichText(
                      text: TextSpan(
                          text: 'Already have an ccount?',
                          style: Get.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textDark
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: ' Login',
                                style: TextStyle(
                                   
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.brandDark),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                     Get.back();
                                    // // navigate to desired screen
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
                      ),),
                    GetBuilder<LoginController>(
                      builder: (controller) {
                        return SizedBox(
                          
                          height:  50,
                        width: Get.size.width,
                          child: ElevatedButton.icon(
                             style:ELEVATED_BUTTON_SOCIALITE_STYLE,
                            onPressed: () {
                                // controller.signInWithGoogle(context);
                            },
                            icon:   Container(
                              child: SvgPicture.asset(
                                height: 24,
                                width: 24,
                                'assets/images/google-logo.svg', // Added ".svg" extension
                                semanticsLabel:
                                    'Google Logo', // Adjusted semantics label
                              ),
                            ),
                            label: Text('Continue with Google', style: Get.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),),
                          ),
                        );
                      }
                    ),

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
                      style: Get.textTheme.bodyMedium?.copyWith(color: Colors.white),
                      children: <TextSpan>[
                        TextSpan(
                            text: ' Terms of Service',
                            style:
                                Get.textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold,decoration: TextDecoration.underline, decorationColor: Colors.white),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                              // Get.to(()=> AgreementPage(title: 'Terms of use' , url: 'https://staging.avantefood.com/terms-of-use') ,transition: Transition.cupertino );

                                // Get.to(()=> TermsOfUseScreen() ,transition: Transition.cupertino );
                                // navigate to desired screen
                              }),
                        TextSpan(
                          text: ' and acknowledge you’ve read our',
                          style:Get.textTheme.bodyMedium?.copyWith(color: Colors.white),
                        ),
                        TextSpan(
                            text: ' Privacy Policy.',
                            style:Get.textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold, decoration: TextDecoration.underline, decorationColor: Colors.white),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // navigate to desired screen
                                // Get.to(()=> AgreementPage(title: 'Privacy Policy' , url: 'https://staging.avantefood.com/privacy-policy') ,transition: Transition.cupertino );

                                  //  Get.to(()=> PrivacyPolicyScreen() ,transition: Transition.cupertino );
                                // navigate to desired screen
                              }),
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
