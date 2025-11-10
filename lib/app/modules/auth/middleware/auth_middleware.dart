import 'package:custom_mp_app/app/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:custom_mp_app/app/modules/auth/controllers/auth_controller.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final auth = AuthController.instance;

   print('AUTH MIDDLEWARE');
    print(auth.isAuthenticated);
  

  

    // ✅ If user not authenticated, go to login
    if (auth.isAuthenticated.isFalse) {
      return const RouteSettings(name: Routes.loginPage);
    }

     return null;
  }
}
