import 'package:custom_mp_app/app/modules/auth/bindings/auth_binding.dart';
import 'package:custom_mp_app/app/modules/auth/controllers/login_controller.dart';
import 'package:custom_mp_app/app/modules/auth/views/login_page.dart';
import 'package:custom_mp_app/app/modules/auth/views/signup_page.dart';
import 'package:custom_mp_app/app/modules/auth/views/splash_page.dart';
import 'package:custom_mp_app/app/modules/testing/modal_page.dart';
import 'package:get/route_manager.dart';

class Routes {


  //Authentication
  static const String loginPage = '/login';
  static const String signupPage = '/signup';
  static const String homePage = '/home';
  static const String forgotPasswordPage = '/home';
  static const String  splashPage = '/splash';


  //
  static const String modalPage = '/modal';


  static List<GetPage> pages = [
   GetPage(name: Routes.splashPage, page: () => const SplashPage()),
      GetPage(name: modalPage, page:()=>  ModalPage()),
      GetPage(name: loginPage, page:()=>  LoginPage(), binding:  AuthBinding()),
      GetPage(name: signupPage, page:()=>  SignupPage(),binding:  AuthBinding()),
      GetPage(name: forgotPasswordPage, page:()=>  SignupPage(),binding:  AuthBinding()),
  ];
}
