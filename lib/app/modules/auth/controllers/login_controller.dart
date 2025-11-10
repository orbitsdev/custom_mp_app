import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:custom_mp_app/app/data/repositories/auth_repository.dart';
import 'package:custom_mp_app/app/modules/auth/controllers/auth_controller.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
    final formKeyLogin = GlobalKey<FormBuilderState>();

  final isLoading = false.obs;
  final _authRepo = AuthRepository();

  
}
