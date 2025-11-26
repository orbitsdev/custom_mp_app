import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_logger.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    FirebaseLogger.group("🔔 Local Notifications Initialized");
    FirebaseLogger.log("Plugin ready");
    FirebaseLogger.endGroup();
  }

  static void _onNotificationTapped(NotificationResponse response) {
    FirebaseLogger.group("👆 Notification Tapped");
    FirebaseLogger.log("Payload: ${response.payload}");
    FirebaseLogger.endGroup();
  }

  /// Show notification triggered by Firebase
  static Future<void> showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      message.notification.hashCode,
      message.notification?.title ?? 'New Message',
      message.notification?.body ?? '',
      notificationDetails,
      payload: message.data.toString(),
    );

    FirebaseLogger.group("📣 Notification Displayed");
    FirebaseLogger.log("Title: ${message.notification?.title}");
    FirebaseLogger.endGroup();
  }

  /// Android 13+ permission for local notifications
  static Future<bool?> requestPermission() async {
    if (await _isAndroid13OrHigher()) {
      return await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
    return true;
  }

  static Future<bool> _isAndroid13OrHigher() async {
    final plugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    return plugin != null;
  }

  /// DEBUG NOTIFICATION FOR DEVELOPMENT
  static Future<void> showDebugNotification({
    required String title,
    required String body,
  }) async {
    const NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    await _notificationsPlugin.show(
      999,
      title,
      body,
      details,
    );
  }
}
