import 'package:custom_mp_app/app/config/firebase/firebase_messaging_handler.dart';
import 'package:custom_mp_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:custom_mp_app/app/modules/user_device/controllers/user_device_controller.dart';
import 'package:custom_mp_app/app/modules/notifications/controllers/notification_controller.dart';
import 'package:custom_mp_app/app/modules/orders/controllers/orders_controller.dart';
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
      LocalNotificationService.onSystemNotificationTap(initialMessage.data);
    });
  }

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    LocalNotificationService.onSystemNotificationTap(message.data);
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
    print( "📩 Foreground Message ${message.toString()}" );

    FirebaseLogger.endGroup();

    // Show notification
    if (message.notification != null) {
      LocalNotificationService.showNotification(message);
    }

    // Auto-refresh data when notification arrives (Shopee-like UX)
    _handleNotificationDataRefresh(message.data);
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

  /// Auto-refresh data when notification arrives (Shopee/Lazada-like UX)
  /// Keeps app data fresh without user manually refreshing
  static void _handleNotificationDataRefresh(Map<String, dynamic> data) {
    final type = data['type'] as String?;

    FirebaseLogger.group("🔄 Auto-refreshing data for notification type: $type");

    try {
      // Always refresh notification count when any notification arrives
      if (Get.isRegistered<NotificationController>()) {
        FirebaseLogger.log("📬 Refreshing notification count...");
        NotificationController.instance.fetchUnreadCount();
      }

      // Type-specific refresh
      switch (type) {
        case 'order_status_update':
          _refreshOrderData(data);
          break;

        case 'product':
          // Product notifications don't need data refresh
          FirebaseLogger.log("🛍️ Product notification - no refresh needed");
          break;

        default:
          FirebaseLogger.log("⚠️ Unknown notification type: $type");
      }
    } catch (e) {
      FirebaseLogger.log("❌ Error during auto-refresh: $e");
    }

    FirebaseLogger.endGroup();
  }

  /// Refresh order-related data when order notification arrives
  static void _refreshOrderData(Map<String, dynamic> data) {
    FirebaseLogger.log("📦 Refreshing order data...");

    if (!Get.isRegistered<OrdersController>()) {
      FirebaseLogger.log("⏳ OrdersController not registered - skipping");
      return;
    }

    final ordersController = OrdersController.instance;

    // Invalidate cache to force fresh data on next fetch
    ordersController.invalidateAllCaches();

    // Refresh all order counts (To Pay, To Ship, To Receive, etc.)
    ordersController.refreshAllCounts();

    FirebaseLogger.log("✅ Order data refresh triggered");
  }
}
