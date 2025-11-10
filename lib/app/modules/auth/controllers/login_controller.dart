import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class LoginController extends GetxController{
  static  LoginController controller = Get.find();
  final formKeyLogin = GlobalKey<FormBuilderState>(); 
  bool obscureText = true;

  void togggleShowPassword(){
    obscureText = !obscureText;
    update();
  }
}