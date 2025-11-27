import 'dart:convert';
import 'package:custom_mp_app/app/core/routes/routes.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dio/dio.dart';

import 'package:custom_mp_app/app/core/plugins/dio/dio_client.dart';
import 'package:custom_mp_app/app/global/widgets/toasts/app_toast.dart';
import 'package:get/get.dart';
import 'firebase_logger.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static ByteArrayAndroidBitmap? _appLogoIcon;

  static const String _notificationSound = 'notification';

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
      onDidReceiveNotificationResponse: onLocalNotificationTap,
    );

    await _createNotificationChannel();

    await _loadAppLogo();

    FirebaseLogger.group("🔔 Local Notifications Initialized");
    FirebaseLogger.log("Plugin ready");
    FirebaseLogger.log("Channel created with sound");
    FirebaseLogger.log("App logo loaded: ${_appLogoIcon != null}");
    FirebaseLogger.endGroup();
  }

  static Future<void> _createNotificationChannel() async {
    FirebaseLogger.log(
      '🔊 Creating channel_id_10 with sound: $_notificationSound',
    );

    final androidPlugin =
        _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidPlugin != null) {
      final channel = AndroidNotificationChannel(
        'channel_id_10',
        'Avante Foods',
        description: 'All Avante Foods notifications',
        importance: Importance.max,
        playSound: true,
        sound: RawResourceAndroidNotificationSound(_notificationSound),
        enableVibration: true,
      );

      await androidPlugin.createNotificationChannel(channel);
      FirebaseLogger.log(
        "📢 Channel created: ${channel.id} with sound enabled",
      );
    }
  }

  static Future<void> _loadAppLogo() async {
    try {
      final ByteData bytes = await rootBundle.load('assets/images/logo.png');
      final Uint8List byteArray = bytes.buffer.asUint8List();
      _appLogoIcon = ByteArrayAndroidBitmap(byteArray);
    } catch (e) {
      FirebaseLogger.log("⚠️ No custom logo found, using launcher icon");
      _appLogoIcon = null;
    }
  }

  static void onLocalNotificationTap(NotificationResponse response) {
    FirebaseLogger.group("👆 Notification Tapped");
    FirebaseLogger.log("Payload: ${response.payload}");

    if (response.payload == null || response.payload!.isEmpty) {
      FirebaseLogger.endGroup();
      return;
    }

    try {
      final data = jsonDecode(response.payload!);
      final type = data['type'] as String?;

      FirebaseLogger.log("Type: $type");
      FirebaseLogger.endGroup();

      switch (type) {
        case 'product':
          _handleProductTap(data);
          break;
        case 'order':
          _handleOrderTap(data);
          break;
        default:
          FirebaseLogger.log("⚠️ Unknown notification type: $type");
      }
    } catch (e) {
      FirebaseLogger.log("❌ Error parsing payload: $e");
      FirebaseLogger.endGroup();
    }
  }

  

  static void _handleProductTap(Map<String, dynamic> data) {
    FirebaseLogger.log("📍 Navigate to Product: ${data['product_id']}");

    final productId = data['product_id'];
    if (productId != null) {
      final id =
          productId is int ? productId : int.tryParse(productId.toString());
      if (id != null) {
       
        AppToast.info("🛍️ Product notification tapped: ID $id");
       
      }
    }
  }

  static void _handleOrderTap(Map<String, dynamic> data) {
    FirebaseLogger.log("📍 Navigate to Order: ${data['order_id']}");

    final orderId = data['order_id'];
    if (orderId != null) {
      final id = orderId is int ? orderId : int.tryParse(orderId.toString());
      if (id != null) {
        // Testing: Show toast instead of navigation
        AppToast.info("📦 Order notification tapped: ID $id");
        // TODO: Uncomment when ready for production
        // Get.toNamed(Routes.orderDetailPage, arguments: id);
      }
    }
  }

  static Future<void> showNotification(RemoteMessage message) async {
    final type = message.data['type'] as String?;
    final imageUrl = message.data['image'] as String?;
    final messages = message.data['messages'] as String?;
    final title = message.notification?.title ?? 'Notification';
    final body = message.notification?.body ?? '';

    FirebaseLogger.group("📣 Showing Notification");
    FirebaseLogger.log("Type: $type");
    FirebaseLogger.log("Has Image: ${imageUrl != null}");
    FirebaseLogger.log("Has Messages: ${messages != null}");

    const channelId = 'channel_id_10';
    const channelName = 'Avante Foods';
    const channelDescription = 'All Avante Foods notifications';

    AndroidNotificationDetails androidDetails;

    if (messages != null && messages.isNotEmpty) {
      androidDetails = _buildMessagingNotification(
        channelId,
        channelName,
        channelDescription,
        title,
        messages,
      );
    } else if (imageUrl != null && imageUrl.isNotEmpty) {
      final image = await _downloadImage(imageUrl);

      if (image != null) {
        androidDetails = AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: channelDescription,
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          sound: RawResourceAndroidNotificationSound(_notificationSound),
          icon: '@mipmap/ic_launcher',
          largeIcon: _appLogoIcon,
          styleInformation: BigPictureStyleInformation(
            image,
            contentTitle: title,
            summaryText: body,
            htmlFormatContent: true,
            htmlFormatContentTitle: true,
            htmlFormatSummaryText: true,
          ),
          showWhen: true,
          enableVibration: true,
        );
      } else {
        androidDetails = _buildTextOnlyNotification(
          channelId,
          channelName,
          channelDescription,
          title,
          body,
        );
      }
    } else {
      androidDetails = _buildTextOnlyNotification(
        channelId,
        channelName,
        channelDescription,
        title,
        body,
      );
    }

    await _notificationsPlugin.show(
      message.notification.hashCode,
      title,
      body,
      NotificationDetails(android: androidDetails),
      payload: jsonEncode(message.data),
    );

    FirebaseLogger.log("✅ Displayed: $title");
    FirebaseLogger.endGroup();
  }

  static AndroidNotificationDetails _buildTextOnlyNotification(
    String channelId,
    String channelName,
    String channelDescription,
    String title,
    String body,
  ) {
    return AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(_notificationSound),
      icon: '@mipmap/ic_launcher',
      largeIcon: _appLogoIcon,
      styleInformation: BigTextStyleInformation(
        body,
        contentTitle: title,
        htmlFormatContent: true,
        htmlFormatContentTitle: true,
      ),
      showWhen: true,
      enableVibration: true,
    );
  }

  static AndroidNotificationDetails _buildMessagingNotification(
    String channelId,
    String channelName,
    String channelDescription,
    String conversationTitle,
    String messagesJson,
  ) {
    try {
      final List<dynamic> messagesList = jsonDecode(messagesJson);

      final messagingStyle = MessagingStyleInformation(
        Person(name: 'You', key: 'user_key'),
        conversationTitle: conversationTitle,
        groupConversation: messagesList.length > 1,
        messages:
            messagesList.map((msg) {
              return Message(
                msg['text'] ?? '',
                DateTime.fromMillisecondsSinceEpoch(
                  msg['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
                ),
                Person(
                  name: msg['sender'] ?? 'Unknown',
                  key: 'sender_${msg['sender']}',
                ),
              );
            }).toList(),
      );

      return AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound(_notificationSound),
        icon: '@mipmap/ic_launcher',
        largeIcon: _appLogoIcon,
        styleInformation: messagingStyle,
        showWhen: true,
        enableVibration: true,
        category: AndroidNotificationCategory.message,
      );
    } catch (e) {
      FirebaseLogger.log("⚠️ Failed to parse messages: $e");

      return _buildTextOnlyNotification(
        channelId,
        channelName,
        channelDescription,
        conversationTitle,
        'New messages received',
      );
    }
  }

  static Future<ByteArrayAndroidBitmap?> _downloadImage(String url) async {
    try {
      final response = await DioClient.public.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200 && response.data != null) {
        return ByteArrayAndroidBitmap(response.data);
      }
    } catch (e) {
      FirebaseLogger.log("⚠️ Failed to download image: $e");
    }
    return null;
  }

  static Future<bool?> requestPermission() async {
    if (await _isAndroid13OrHigher()) {
      return await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }
    return true;
  }

  static Future<bool> _isAndroid13OrHigher() async {
    final plugin =
        _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    return plugin != null;
  }

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

    await _notificationsPlugin.show(999, title, body, details);
  }

  static void onSystemNotificationTap(Map<String, dynamic> data) {
    FirebaseLogger.group("📬 FCM Notification Tapped");
    FirebaseLogger.log("Data: $data");
    FirebaseLogger.endGroup();

    final type = data['type'];

    switch (type) {
      case 'product':
        _handleProductTap(data);
        break;

      case 'order':
        _handleOrderTap(data);
        break;

      default:
        FirebaseLogger.log("⚠️ Unknown notification type: $type");
    }
  }
}
