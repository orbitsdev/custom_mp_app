import 'dart:convert';

import 'package:custom_mp_app/app/config/firebase/local_notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class TestingController extends GetxController {
  static TestingController get instance => Get.find();

  /// Test promo notification with image
  Future<void> testPromoNotification() async {
    final message = RemoteMessage(
      notification: const RemoteNotification(
        title: '🎉 Special Promo!',
        body: 'Get 50% off on all seafood products today!',
      ),
      data: {
        'type': 'promo',
        'promo_id': '123',
        'image': 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800',
      },
    );

    await LocalNotificationService.showNotification(message);
  }

  /// Test product notification with image
  Future<void> testProductNotification() async {
    final message = RemoteMessage(
      notification: const RemoteNotification(
        title: '🦐 Premium Shrimp Available',
        body: 'Fresh tiger prawns just arrived! Order now while stocks last.',
      ),
      data: {
        'type': 'product',
        'product_id': '456',
        'image': 'https://images.unsplash.com/photo-1565680018434-b513d5e5fd47?w=800',
      },
    );

    await LocalNotificationService.showNotification(message);
  }

  /// Test order notification (text only)
  Future<void> testOrderNotification() async {
    final message = RemoteMessage(
      notification: const RemoteNotification(
        title: '📦 Order Update',
        body: 'Your order #ORD-12345 is now out for delivery!',
      ),
      data: {
        'type': 'order',
        'order_id': '789',
      },
    );

    await LocalNotificationService.showNotification(message);
  }

  /// Test new product notification with image
  Future<void> testNewProductNotification() async {
    final message = RemoteMessage(
      notification: const RemoteNotification(
        title: '✨ New Arrival!',
        body: 'Check out our fresh Atlantic salmon, now available in store.',
      ),
      data: {
        'type': 'new_product',
        'product_id': '999',
        'image': 'https://images.unsplash.com/photo-1574781330855-d0db8cc6a79c?w=800',
      },
    );

    await LocalNotificationService.showNotification(message);
  }

  /// Test default notification (text only)
  Future<void> testDefaultNotification() async {
    final message = RemoteMessage(
      notification: const RemoteNotification(
        title: '🔔 General Notification',
        body: 'This is a general notification without a specific type.',
      ),
      data: {
        'screen': 'home',
      },
    );

    await LocalNotificationService.showNotification(message);
  }

  /// Test long text notification (BigTextStyle)
  Future<void> testLongTextNotification() async {
    final message = RemoteMessage(
      notification: const RemoteNotification(
        title: '📢 Important Announcement',
        body:
            'We are excited to announce our new loyalty program! Earn points with every purchase and redeem them for exclusive discounts. Sign up today and get 100 bonus points. Terms and conditions apply.',
      ),
      data: {
        'type': 'promo',
      },
    );

    await LocalNotificationService.showNotification(message);
  }

  /// Test notification with broken image URL (should fallback to text-only)
  Future<void> testBrokenImageNotification() async {
    final message = RemoteMessage(
      notification: const RemoteNotification(
        title: '🔧 Testing Image Fallback',
        body: 'This notification has a broken image URL and should display as text-only.',
      ),
      data: {
        'type': 'product',
        'product_id': '000',
        'image': 'https://invalid-url-that-will-fail.com/image.jpg',
      },
    );

    await LocalNotificationService.showNotification(message);
  }

  /// Test messaging-style notification (chat conversation)
  Future<void> testMessagingNotification() async {
    final now = DateTime.now().millisecondsSinceEpoch;

    // Create a conversation with multiple messages
    final messages = [
      {
        'text': 'Hey! Are you available?',
        'timestamp': now - 120000, // 2 minutes ago
        'sender': 'John Doe',
      },
      {
        'text': 'I have a question about my order',
        'timestamp': now - 60000, // 1 minute ago
        'sender': 'John Doe',
      },
      {
        'text': 'Can you help me?',
        'timestamp': now, // Just now
        'sender': 'John Doe',
      },
    ];

    final message = RemoteMessage(
      notification: const RemoteNotification(
        title: 'John Doe',
        body: 'Can you help me?',
      ),
      data: {
        'type': 'message',
        'conversation_id': '123',
        'messages': jsonEncode(messages),
      },
    );

    await LocalNotificationService.showNotification(message);
  }

  /// Test debug notification (simplified)
  Future<void> testDebugNotification() async {
    await LocalNotificationService.showDebugNotification(
      title: '🐛 Debug Notification',
      body: 'This is a simple debug notification for testing purposes.',
    );
  }

  /// Test product ID 1 notification (sends actual notification)
  Future<void> testProductId1Notification() async {
    final message = RemoteMessage(
      notification: const RemoteNotification(
        title: '🛍️ Product #1 Available',
        body: 'Tap to view product details',
      ),
      data: {
        'type': 'product',
        'product_id': '1',
        'image': 'https://images.unsplash.com/photo-1565680018434-b513d5e5fd47?w=800',
      },
    );

    await LocalNotificationService.showNotification(message);
  }

  /// Test product ID 2 notification (sends actual notification)
  Future<void> testProductId2Notification() async {
    final message = RemoteMessage(
      notification: const RemoteNotification(
        title: '🛍️ Product #2 Available',
        body: 'Tap to view product details',
      ),
      data: {
        'type': 'product',
        'product_id': '2',
        'image': 'https://images.unsplash.com/photo-1565680018434-b513d5e5fd47?w=800',
      },
    );

    await LocalNotificationService.showNotification(message);
  }
}
