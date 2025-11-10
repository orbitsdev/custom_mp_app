import 'package:custom_mp_app/app/core/bindings/app_binding.dart';
import 'package:custom_mp_app/app/core/routes/routes.dart';
import 'package:custom_mp_app/app/core/theme/app_theme.dart';
import 'package:custom_mp_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  AppBinding().dependencies();
  await AuthController.instance.autoLogin();
  runApp(const CustomMPAPP());
}

class CustomMPAPP extends StatelessWidget {
  const CustomMPAPP({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Custom MP',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.AVANTE_THEME,
     initialRoute: Routes.splashPage,
      getPages: Routes.pages,
    );
  }
}
