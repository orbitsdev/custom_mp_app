import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:custom_mp_app/firebase_options.dart';
import 'firebase_messaging_handler.dart';
import 'firebase_logger.dart';

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

    // 📌 4. Get FCM Token
    final token = await messaging.getToken();
    FirebaseLogger.group("📱 FCM TOKEN");
    FirebaseLogger.log(token ?? "No token found");
    FirebaseLogger.endGroup();

    // 📌 5. Foreground message listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      FirebaseLogger.group("📩 Foreground Message");
      FirebaseLogger.log("Title: ${message.notification?.title}");
      FirebaseLogger.log("Body: ${message.notification?.body}");
      FirebaseLogger.log("Data: ${message.data}");
      FirebaseLogger.endGroup();
    });

    // 📌 6. User tapped notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      FirebaseLogger.group("📬 Notification Clicked");
      FirebaseLogger.log("Data: ${message.data}");
      FirebaseLogger.endGroup();
    });
  }
}
