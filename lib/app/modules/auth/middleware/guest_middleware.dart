import 'package:custom_mp_app/app/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:custom_mp_app/app/modules/auth/controllers/auth_controller.dart';

class GuestMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {

   final auth = AuthController.instance;

    print('GUEST MIDDLEWARE');
    // print(auth.isAuthenticated);
    print('GUEST MIDDLEWARE2');
      print(auth.isAuthenticated.isTrue);

  

  
    if (auth.isAuthenticated.isTrue) {
      return const RouteSettings(name: Routes.homePage);
    }
    // Otherwise, allow access to guest pages
    return null;
  
  }
}
