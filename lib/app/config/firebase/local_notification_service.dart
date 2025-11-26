import 'dart:convert';
import 'package:custom_mp_app/app/core/routes/routes.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dio/dio.dart';

import 'package:custom_mp_app/app/core/plugins/dio/dio_client.dart';
import 'package:get/get.dart';
import 'firebase_logger.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Cache for app logo to avoid loading it multiple times
  static ByteArrayAndroidBitmap? _appLogoIcon;

  // Notification sound file (must exist in android/app/src/main/res/raw/)
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
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // CRITICAL: Create channel with sound BEFORE any notifications
    await _createNotificationChannel();

    // Pre-load app logo for notifications
    await _loadAppLogo();

    FirebaseLogger.group("🔔 Local Notifications Initialized");
    FirebaseLogger.log("Plugin ready");
    FirebaseLogger.log("Channel created with sound");
    FirebaseLogger.log("App logo loaded: ${_appLogoIcon != null}");
    FirebaseLogger.endGroup();
  }

  /// Create notification channel with sound configuration
  /// CRITICAL: Must create channel BEFORE showing notifications
  static Future<void> _createNotificationChannel() async {
    FirebaseLogger.log('🔊 Creating channel_id_10 with sound: $_notificationSound');

    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

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
      FirebaseLogger.log("📢 Channel created: ${channel.id} with sound enabled");
    }
  }

  /// Load app logo from assets for use as large icon
  static Future<void> _loadAppLogo() async {
    try {
      // Try to load custom logo first (if you have it)
      final ByteData bytes = await rootBundle.load('assets/images/logo.png');
      final Uint8List byteArray = bytes.buffer.asUint8List();
      _appLogoIcon = ByteArrayAndroidBitmap(byteArray);
    } catch (e) {
      // If no custom logo, that's okay - will use default launcher icon
      FirebaseLogger.log("⚠️ No custom logo found, using launcher icon");
      _appLogoIcon = null;
    }
  }

  /// Handle notification tap - Navigate based on type and data
  static void _onNotificationTapped(NotificationResponse response) {
    FirebaseLogger.group("👆 Notification Tapped");
    FirebaseLogger.log("Payload: ${response.payload}");

    if (response.payload == null || response.payload!.isEmpty) {
      FirebaseLogger.endGroup();
      return;
    }

    try {
      final data = jsonDecode(response.payload!);
      final type = data['type'] as String?;
      final screen = data['screen'] as String?;

      FirebaseLogger.log("Type: $type");
      FirebaseLogger.log("Screen: $screen");
      FirebaseLogger.endGroup();

      // Route based on notification type
      switch (type) {
        case 'promo':
          _handlePromoTap(data);
          break;
        case 'product':
          _handleProductTap(data);
          break;
        case 'order':
        case 'order_notification':  // Support old format too
          _handleOrderTap(data);
          break;
        case 'new_product':
          _handleNewProductTap(data);
          break;
        default:
          _handleDefaultTap(data);
      }
    } catch (e) {
      FirebaseLogger.log("❌ Error parsing payload: $e");
      FirebaseLogger.endGroup();
    }
  }

  // ═══════════════════════════════════════════════════════════
  // TAP HANDLERS - Customize navigation for each type
  // ═══════════════════════════════════════════════════════════

  static void _handlePromoTap(Map<String, dynamic> data) {
    FirebaseLogger.log("📍 Navigate to Promo: ${data['promo_id']}");
    // TODO: Uncomment when route is ready
    // Get.toNamed(Routes.promoDetail, arguments: data['promo_id']);
  }

  static void _handleProductTap(Map<String, dynamic> data) {
    FirebaseLogger.log("📍 Navigate to Product: ${data['product_id']}");

    final productId = data['product_id'];
    if (productId != null) {
      // Convert to int if it's a string
      final id = productId is int ? productId : int.tryParse(productId.toString());
      if (id != null) {
        Get.toNamed(Routes.productDetailsPage, arguments: id);
      }
    }
  }

  static void _handleOrderTap(Map<String, dynamic> data) {
    FirebaseLogger.log("📍 Navigate to Order: ${data['order_id']}");

    final orderId = data['order_id'];
    if (orderId != null) {
      // Convert to int if it's a string
      final id = orderId is int ? orderId : int.tryParse(orderId.toString());
      if (id != null) {
        Get.toNamed(Routes.orderDetailPage, arguments: id);
      }
    }
  }

  static void _handleNewProductTap(Map<String, dynamic> data) {
    FirebaseLogger.log("📍 Navigate to New Product: ${data['product_id']}");

    final productId = data['product_id'];
    if (productId != null) {
      // Convert to int if it's a string
      final id = productId is int ? productId : int.tryParse(productId.toString());
      if (id != null) {
        Get.toNamed(Routes.productDetailsPage, arguments: id);
      }
    }
  }

  static void _handleDefaultTap(Map<String, dynamic> data) {
    final screen = data['screen'] as String?;
    FirebaseLogger.log("📍 Navigate to: $screen");
    // Handle custom screen navigation if provided
  }

  // ═══════════════════════════════════════════════════════════
  // MAIN SHOW NOTIFICATION - Handles all types
  // ═══════════════════════════════════════════════════════════

  /// Show notification triggered by Firebase
  /// Automatically adapts style based on data.type and data.image
  static Future<void> showNotification(RemoteMessage message) async {
    final type = message.data['type'] as String?;
    final imageUrl = message.data['image'] as String?;
    final messages = message.data['messages'] as String?; // For messaging style
    final title = message.notification?.title ?? 'Notification';
    final body = message.notification?.body ?? '';

    FirebaseLogger.group("📣 Showing Notification");
    FirebaseLogger.log("Type: $type");
    FirebaseLogger.log("Has Image: ${imageUrl != null}");
    FirebaseLogger.log("Has Messages: ${messages != null}");

    // Use single channel for all notifications (like old working project)
    const channelId = 'channel_id_10';
    const channelName = 'Avante Foods';
    const channelDescription = 'All Avante Foods notifications';

    // Build Android notification with all features
    AndroidNotificationDetails androidDetails;

    // Check if this is a messaging notification
    if (messages != null && messages.isNotEmpty) {
      // Show MessagingStyle notification (chat conversation)
      androidDetails = _buildMessagingNotification(
        channelId,
        channelName,
        channelDescription,
        title,
        messages,
      );
    } else if (imageUrl != null && imageUrl.isNotEmpty) {
      // Download image for notification
      final image = await _downloadImage(imageUrl);

      if (image != null) {
        // Show with image (Big Picture Style)
        androidDetails = AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: channelDescription,
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          sound: RawResourceAndroidNotificationSound(_notificationSound),
          icon: '@mipmap/ic_launcher',
          largeIcon: _appLogoIcon,  // App logo on the side
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
        // Image download failed, show text-only
        androidDetails = _buildTextOnlyNotification(
          channelId,
          channelName,
          channelDescription,
          title,
          body,
        );
      }
    } else {
      // No image, show text-only with BigTextStyle (expandable)
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

  /// Build text-only notification with BigTextStyle (expandable)
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
      largeIcon: _appLogoIcon,  // App logo on the side
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

  /// Build messaging-style notification (chat conversation)
  /// Expected messages format: JSON array of message objects
  /// [{"text": "Hello!", "timestamp": 1234567890, "sender": "John"}]
  static AndroidNotificationDetails _buildMessagingNotification(
    String channelId,
    String channelName,
    String channelDescription,
    String conversationTitle,
    String messagesJson,
  ) {
    try {
      // Parse messages JSON
      final List<dynamic> messagesList = jsonDecode(messagesJson);

      // Create messaging style
      final messagingStyle = MessagingStyleInformation(
        Person(
          name: 'You', // The current user
          key: 'user_key',
          // Note: Person icon requires AndroidIcon type, not ByteArrayAndroidBitmap
          // We'll use the default icon instead
        ),
        conversationTitle: conversationTitle,
        groupConversation: messagesList.length > 1,
        messages: messagesList.map((msg) {
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
      // Fallback to text-only notification
      return _buildTextOnlyNotification(
        channelId,
        channelName,
        channelDescription,
        conversationTitle,
        'New messages received',
      );
    }
  }

  /// Download image from URL for notification using DioClient
  static Future<ByteArrayAndroidBitmap?> _downloadImage(String url) async {
    try {
      final response = await DioClient.public.get(
        url,
        options: Options(
          responseType: ResponseType.bytes, // Get raw bytes for image
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return ByteArrayAndroidBitmap(response.data);
      }
    } catch (e) {
      FirebaseLogger.log("⚠️ Failed to download image: $e");
    }
    return null;
  }

  /// Android 13+ permission for local notifications
  static Future<bool?> requestPermission() async {
    if (await _isAndroid13OrHigher()) {
      return await _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
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
