import 'package:custom_mp_app/app/modules/auth/bindings/auth_binding.dart';
import 'package:custom_mp_app/app/modules/auth/controllers/login_controller.dart';
import 'package:custom_mp_app/app/modules/auth/middleware/auth_middleware.dart';
import 'package:custom_mp_app/app/modules/auth/middleware/guest_middleware.dart';
import 'package:custom_mp_app/app/modules/auth/views/login_page.dart';
import 'package:custom_mp_app/app/modules/auth/views/signup_page.dart';
import 'package:custom_mp_app/app/modules/auth/views/splash_page.dart';
import 'package:custom_mp_app/app/modules/home/bindings/home_binding.dart';
import 'package:custom_mp_app/app/modules/home/views/home_page.dart';
import 'package:custom_mp_app/app/modules/products/bindings/product_binding.dart';
import 'package:custom_mp_app/app/modules/products/controllers/product_controller.dart';
import 'package:custom_mp_app/app/modules/testing/modal_page.dart';
import 'package:get/route_manager.dart';

class Routes {
  //Authentication
  static const String loginPage = '/login';
  static const String signupPage = '/signup';
  static const String forgotPasswordPage = '/home';
  static const String splashPage = '/splash';

  static const String homePage = '/home';

  //
  static const String modalPage = '/modal';

  static List<GetPage> pages = [
    GetPage(name: Routes.splashPage, page: () => const SplashPage()),
    GetPage(name: modalPage, page: () => ModalPage()),
    GetPage(
      name: Routes.loginPage,
      middlewares: [GuestMiddleware()],
      page: () => LoginPage(),
       binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.signupPage,
      middlewares: [GuestMiddleware()],
      page: () => SignupPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.homePage,
      middlewares: [AuthMiddleware()],
      page: () => HomePage(),
      binding: HomeBinding()
    ),
  ];
}
