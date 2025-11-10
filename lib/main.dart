import 'package:custom_mp_app/app/core/bindings/app_binding.dart';

import 'package:custom_mp_app/app/core/routes/routes.dart';
import 'package:custom_mp_app/app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

Future<void> main() async  {
  
  WidgetsFlutterBinding.ensureInitialized();
  AppBinding().dependencies();
  runApp(const CustomMPAPP());
}

class CustomMPAPP extends StatefulWidget {
  const CustomMPAPP({ Key? key }) : super(key: key);

  @override
  _CustomMPAPPState createState() => _CustomMPAPPState();
}

class _CustomMPAPPState extends State<CustomMPAPP> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.AVANTE_THEME,
      initialRoute: Routes.loginPage,
      getPages: Routes.pages,
    );
  }
}