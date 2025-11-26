import 'package:custom_mp_app/app/config/firebase/firebase_initializer.dart';
import 'package:custom_mp_app/app/core/bindings/app_binding.dart';
import 'package:custom_mp_app/app/core/plugins/deviceinfoplus/device_info_service.dart';
import 'package:custom_mp_app/app/core/routes/routes.dart';
import 'package:custom_mp_app/app/core/theme/app_theme.dart';
import 'package:custom_mp_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:custom_mp_app/app/modules/user_device/controllers/user_device_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await FirebaseInitializer.init();
  await DeviceInfoService.init();
  AppBinding().dependencies();
  // Note: autoLogin is called by SplashController after UI is ready
  runApp(const CustomMPAPP());

}

class CustomMPAPP extends StatefulWidget {
  const CustomMPAPP({super.key});
  @override
  State<CustomMPAPP> createState() => _CustomMPAPPState();
}

class _CustomMPAPPState extends State<CustomMPAPP> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    print('-------------------------------- DEVICE INFO --------------------------------');
    print(DeviceInfoService.info);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
         print('🔁 AppLifecycleState.resumed');
         // Note: We don't register device here - too frequent!
         // Device registration happens on:
         // - Login/Signup
         // - App startup (autoLogin)
         // - FCM token refresh
        break;
      case AppLifecycleState.inactive:
         print('🔁 AppLifecycleState.inactive');
       break;
      case AppLifecycleState.paused:
         print('🔁 AppLifecycleState.paused');
       break;
      case AppLifecycleState.detached:
         print('🔁 AppLifecycleState.detached');
      default:
        break;
    }
  }

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
