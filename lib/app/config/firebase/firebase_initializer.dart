import 'package:custom_mp_app/app/config/firebase/firebase_messaging_handler.dart';
import 'package:custom_mp_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:custom_mp_app/app/modules/user_device/controllers/user_device_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:custom_mp_app/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'firebase_logger.dart';
import 'local_notification_service.dart';

class FirebaseInitializer {
  static Future<void> init() async {
    
     // 1. Background handler (already correct)
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  if (initialMessage != null) {
   
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseLogger.log("🚀 Handling initial message navigation");
      LocalNotificationService.handleFCMTap(initialMessage.data);
    });
  }

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    LocalNotificationService.handleFCMTap(message.data);
  });



  FirebaseLogger.group("🔥 Firebase Initialized");
  FirebaseLogger.log("Project: ${DefaultFirebaseOptions.currentPlatform.projectId}");
  FirebaseLogger.endGroup();


  await LocalNotificationService.init();

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseLogger.group("🔐 Notification Permission");
  FirebaseLogger.log("Status: ${settings.authorizationStatus}");
  FirebaseLogger.endGroup();

  await LocalNotificationService.requestPermission();


  final token = await messaging.getToken();
  FirebaseLogger.group("📱 FCM TOKEN");
  FirebaseLogger.log(token ?? "No token found");
  FirebaseLogger.endGroup();

 
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    FirebaseLogger.group("📩 Foreground Message");
    FirebaseLogger.log("Title: ${message.notification?.title}");
    FirebaseLogger.log("Body: ${message.notification?.body}");
    FirebaseLogger.log("Data: ${message.data}");
    FirebaseLogger.endGroup();

    if (message.notification != null) {
      LocalNotificationService.showNotification(message);
    }
  });

   
    FirebaseMessaging.instance.onTokenRefresh.listen((String newToken) async {
      FirebaseLogger.group("🔄 FCM Token Refreshed");
      FirebaseLogger.log("New Token: ${newToken.substring(0, 20)}...");
      FirebaseLogger.endGroup();

      
      try {
        if (!Get.isRegistered<AuthController>()) {
          FirebaseLogger.log(
            "⏳ AuthController not registered yet - skipping device registration",
          );
          return;
        }

        final authController = AuthController.instance;
        if (!authController.isAuthenticated.value) {
          FirebaseLogger.log(
            "🔓 User not authenticated - skipping device registration",
          );
          return;
        }

        if (!Get.isRegistered<UserDeviceController>()) {
          FirebaseLogger.log(
            "⏳ UserDeviceController not registered yet - skipping device registration",
          );
          return;
        }

        FirebaseLogger.log(
          '📱 Auto-registering device with new FCM token...',
        );
        await UserDeviceController.instance.registerDevice();
        FirebaseLogger.log('✅ Device re-registered successfully');
      } catch (e, stackTrace) {
        FirebaseLogger.log('❌ Failed to re-register device: $e');
        FirebaseLogger.log('Stack trace: $stackTrace');
      }
    });
  }
}
