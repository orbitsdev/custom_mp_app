import 'package:custom_mp_app/app/config/firebase/firebase_messaging_handler.dart';
import 'package:custom_mp_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:custom_mp_app/app/modules/user_device/controllers/user_device_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:custom_mp_app/firebase_options.dart';
import 'package:get/get.dart';

import 'firebase_logger.dart';
import 'local_notification_service.dart';

class FirebaseInitializer {
  static Future<void> init() async {
    // 📌 1. Register background handler FIRST!
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);


    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseLogger.group("🔥 Firebase Initialized");
    FirebaseLogger.log("Project: ${DefaultFirebaseOptions.currentPlatform.projectId}");
    FirebaseLogger.endGroup();

    // 📌 2. Initialize local notifications
    await LocalNotificationService.init();

    // 📌 3. Request notification permission (Android 13+ + iOS)
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseLogger.group("🔐 Notification Permission");
    FirebaseLogger.log("Status: ${settings.authorizationStatus}");
    FirebaseLogger.endGroup();

    // Request Android 13+ local notification permission
    await LocalNotificationService.requestPermission();

    // 📌 4. Get FCM Token
    final token = await messaging.getToken();
    FirebaseLogger.group("📱 FCM TOKEN");
    FirebaseLogger.log(token ?? "No token found");
    FirebaseLogger.endGroup();

    // 📌 5. Foreground message listener - Display notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      FirebaseLogger.group("📩 Foreground Message");
      FirebaseLogger.log("Title: ${message.notification?.title}");
      FirebaseLogger.log("Body: ${message.notification?.body}");
      FirebaseLogger.log("Data: ${message.data}");
      FirebaseLogger.endGroup();

      // Show notification when app is in foreground
      if (message.notification != null) {
        LocalNotificationService.showNotification(message);
      }
    });

    // 📌 6. User tapped notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      FirebaseLogger.group("📬 Notification Clicked");
      FirebaseLogger.log("Data: ${message.data}");
      FirebaseLogger.endGroup();
    });

    // 📌 7. FCM Token Refresh Listener
    // CRITICAL: Firebase can refresh tokens anytime - must update backend
    FirebaseMessaging.instance.onTokenRefresh.listen((String newToken) async {
      FirebaseLogger.group("🔄 FCM Token Refreshed");
      FirebaseLogger.log("New Token: ${newToken.substring(0, 20)}...");
      FirebaseLogger.endGroup();

      // Only re-register if user is authenticated
      try {
        if (Get.isRegistered<AuthController>()) {
          final authController = AuthController.instance;
          if (authController.isAuthenticated.value) {
            print('📱 [FirebaseInitializer] Auto-registering device with new FCM token...');
            await UserDeviceController.instance.registerDevice();
            print('✅ [FirebaseInitializer] Device re-registered successfully');
          }
        }
      } catch (e) {
        print('⚠️ [FirebaseInitializer] Failed to re-register device: $e');
      }
    });
  }
}
