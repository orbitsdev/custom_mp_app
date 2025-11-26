import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'firebase_logger.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Cache for app logo to avoid loading it multiple times
  static ByteArrayAndroidBitmap? _appLogoIcon;

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

    // Pre-load app logo for notifications
    await _loadAppLogo();

    FirebaseLogger.group("🔔 Local Notifications Initialized");
    FirebaseLogger.log("Plugin ready");
    FirebaseLogger.log("App logo loaded: ${_appLogoIcon != null}");
    FirebaseLogger.endGroup();
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
    // TODO: Uncomment when ready
    // Get.toNamed(Routes.productDetailsPage, arguments: data['product_id']);
  }

  static void _handleOrderTap(Map<String, dynamic> data) {
    FirebaseLogger.log("📍 Navigate to Order: ${data['order_id']}");
    // TODO: Uncomment when ready
    // Get.toNamed(Routes.orderDetailPage, arguments: data['order_id']);
  }

  static void _handleNewProductTap(Map<String, dynamic> data) {
    FirebaseLogger.log("📍 Navigate to New Product: ${data['product_id']}");
    // TODO: Uncomment when ready
    // Get.toNamed(Routes.productDetailsPage, arguments: data['product_id']);
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
    final title = message.notification?.title ?? 'Notification';
    final body = message.notification?.body ?? '';

    FirebaseLogger.group("📣 Showing Notification");
    FirebaseLogger.log("Type: $type");
    FirebaseLogger.log("Has Image: ${imageUrl != null}");

    // Determine channel based on type
    String channelId;
    String channelName;
    String channelDescription;

    switch (type) {
      case 'promo':
        channelId = 'promo_channel';
        channelName = 'Promotions';
        channelDescription = 'Special offers and promotions';
        break;
      case 'product':
        channelId = 'product_channel';
        channelName = 'Products';
        channelDescription = 'Product updates and new arrivals';
        break;
      case 'order':
      case 'order_notification':
        channelId = 'order_channel';
        channelName = 'Orders';
        channelDescription = 'Order status updates';
        break;
      case 'new_product':
        channelId = 'new_product_channel';
        channelName = 'New Arrivals';
        channelDescription = 'New product announcements';
        break;
      default:
        channelId = 'default_channel';
        channelName = 'General';
        channelDescription = 'General notifications';
    }

    // Build Android notification with all features
    AndroidNotificationDetails androidDetails;

    if (imageUrl != null && imageUrl.isNotEmpty) {
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
          // sound: RawResourceAndroidNotificationSound('notification'),  // Uncomment if you have custom sound
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
      // sound: RawResourceAndroidNotificationSound('notification'),  // Uncomment if you have custom sound
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

  /// Download image from URL for notification
  static Future<ByteArrayAndroidBitmap?> _downloadImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return ByteArrayAndroidBitmap(response.bodyBytes);
      }
    } catch (e) {
      FirebaseLogger.log("⚠️ Failed to download image: $e");
    }
    return null;
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
