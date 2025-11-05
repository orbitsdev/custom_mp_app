import 'package:custom_mp_app/app/modules/auth/views/login_view.dart';
import 'package:custom_mp_app/app/modules/auth/views/signup_view.dart';
import 'package:get/route_manager.dart';

class Routes {

  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';



  static List<GetPage> pages = [
      GetPage(name: login, page:()=>  LoginView()),
      GetPage(name: signup, page:()=>  SignupView()),
  ];
}
