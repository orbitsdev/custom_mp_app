# Local Notification Service Documentation

## Overview

The `LocalNotificationService` provides a flexible, Firebase-integrated notification system for the mobile app. It automatically adapts notification styles based on content type and supports multiple notification formats including text, images, and messaging conversations.

## Features

✅ **Multiple Notification Styles**
- BigTextStyle (expandable text)
- BigPictureStyle (image notifications)
- MessagingStyle (chat conversations)

✅ **Flexible Channel Management**
- Separate channels for different notification types
- Customizable priority and importance

✅ **Image Caching**
- App logo pre-loaded and cached
- Remote images downloaded via DioClient

✅ **Navigation Handling**
- Tap handlers for each notification type
- JSON payload for navigation data

✅ **Firebase Integration**
- Works seamlessly with Firebase Cloud Messaging (FCM)
- Background and foreground notification handling

---

## Notification Types & Channels

| Type | Channel ID | Channel Name | Use Case |
|------|------------|--------------|----------|
| `promo` | `promo_channel` | Promotions | Special offers, discounts |
| `product` | `product_channel` | Products | Product updates |
| `order` | `order_channel` | Orders | Order status updates |
| `new_product` | `new_product_channel` | New Arrivals | New product announcements |
| `message` / `chat` | `message_channel` | Messages | Chat and direct messages |
| `default` | `default_channel` | General | Fallback for other types |

---

## How to Use

### Basic Text Notification

Send a text-only notification (uses BigTextStyle - expandable):

```dart
final message = RemoteMessage(
  notification: const RemoteNotification(
    title: 'Order Shipped',
    body: 'Your order #12345 has been shipped and is on the way!',
  ),
  data: {
    'type': 'order',
    'order_id': '12345',
  },
);

await LocalNotificationService.showNotification(message);
```

**Firebase Payload (JSON):**
```json
{
  "notification": {
    "title": "Order Shipped",
    "body": "Your order #12345 has been shipped and is on the way!"
  },
  "data": {
    "type": "order",
    "order_id": "12345"
  }
}
```

---

### Image Notification

Send notification with an image (uses BigPictureStyle):

```dart
final message = RemoteMessage(
  notification: const RemoteNotification(
    title: '🎉 Flash Sale!',
    body: 'Get 50% off on all seafood today only!',
  ),
  data: {
    'type': 'promo',
    'promo_id': '789',
    'image': 'https://example.com/promo-banner.jpg',  // ← Image URL
  },
);

await LocalNotificationService.showNotification(message);
```

**Firebase Payload (JSON):**
```json
{
  "notification": {
    "title": "🎉 Flash Sale!",
    "body": "Get 50% off on all seafood today only!"
  },
  "data": {
    "type": "promo",
    "promo_id": "789",
    "image": "https://example.com/promo-banner.jpg"
  }
}
```

**Important Notes:**
- Image will be downloaded using `DioClient` (logged in console)
- If image fails to download, falls back to text-only
- Supports any image format (PNG, JPG, WEBP)

---

### Messaging Notification (Chat Style)

Send a chat-style notification with conversation history (uses MessagingStyle):

```dart
final now = DateTime.now().millisecondsSinceEpoch;

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
    title: 'John Doe',  // Conversation title
    body: 'Can you help me?',  // Latest message
  ),
  data: {
    'type': 'message',
    'conversation_id': '123',
    'messages': jsonEncode(messages),  // ← JSON array of messages
  },
);

await LocalNotificationService.showNotification(message);
```

**Firebase Payload (JSON):**
```json
{
  "notification": {
    "title": "John Doe",
    "body": "Can you help me?"
  },
  "data": {
    "type": "message",
    "conversation_id": "123",
    "messages": "[{\"text\":\"Hey! Are you available?\",\"timestamp\":1234567890000,\"sender\":\"John Doe\"},{\"text\":\"I have a question about my order\",\"timestamp\":1234567950000,\"sender\":\"John Doe\"},{\"text\":\"Can you help me?\",\"timestamp\":1234568010000,\"sender\":\"John Doe\"}]"
  }
}
```

**Message Object Format:**
```dart
{
  'text': 'Message content',           // Required: Message text
  'timestamp': 1234567890000,          // Required: Unix timestamp in milliseconds
  'sender': 'Sender Name',             // Required: Name of message sender
}
```

---

## Navigation Handling

When users tap notifications, the app routes them based on the `type` field in the `data` payload.

### Current Tap Handlers

| Type | Handler Method | Navigation Route |
|------|----------------|------------------|
| `promo` | `_handlePromoTap` | Promo detail page |
| `product` | `_handleProductTap` | Product details page |
| `order` | `_handleOrderTap` | Order detail page |
| `new_product` | `_handleNewProductTap` | Product details page |
| `default` | `_handleDefaultTap` | Custom screen navigation |

### Adding Custom Navigation

To add navigation for a notification type, uncomment the route in the handler:

**Example:**
```dart
static void _handleOrderTap(Map<String, dynamic> data) {
  FirebaseLogger.log("📍 Navigate to Order: ${data['order_id']}");

  // Uncomment to enable navigation:
  Get.toNamed(Routes.orderDetailPage, arguments: data['order_id']);
}
```

---

## Testing Notifications

Use the built-in testing page to test all notification types:

1. Navigate to the testing page:
   ```dart
   Get.toNamed(Routes.testingPage);
   ```

2. Or add a button in your UI:
   ```dart
   ElevatedButton(
     onPressed: () => Get.toNamed(Routes.testingPage),
     child: const Text('Test Notifications'),
   )
   ```

3. The testing page includes buttons for:
   - Promo notifications (with image)
   - Product notifications (with image)
   - Order notifications (text only)
   - New product notifications (with image)
   - Default notifications
   - Long text notifications
   - Broken image fallback
   - **Messaging notifications (chat style)** ✨ NEW
   - Debug notifications

---

## Firebase Cloud Messaging (FCM) Integration

### Backend: Sending Notifications via FCM API

**Endpoint:** `https://fcm.googleapis.com/v1/projects/{project-id}/messages:send`

**Example: Text Notification**
```json
{
  "message": {
    "token": "{device_fcm_token}",
    "notification": {
      "title": "Order Update",
      "body": "Your order #12345 is out for delivery"
    },
    "data": {
      "type": "order",
      "order_id": "12345"
    },
    "android": {
      "priority": "high"
    }
  }
}
```

**Example: Image Notification**
```json
{
  "message": {
    "token": "{device_fcm_token}",
    "notification": {
      "title": "🎉 Special Offer",
      "body": "50% off all products today!"
    },
    "data": {
      "type": "promo",
      "promo_id": "789",
      "image": "https://cdn.example.com/promo-banner.jpg"
    },
    "android": {
      "priority": "high"
    }
  }
}
```

**Example: Messaging Notification**
```json
{
  "message": {
    "token": "{device_fcm_token}",
    "notification": {
      "title": "Sarah Johnson",
      "body": "Can you help me with my order?"
    },
    "data": {
      "type": "message",
      "conversation_id": "conv_123",
      "messages": "[{\"text\":\"Hey there!\",\"timestamp\":1234567890000,\"sender\":\"Sarah Johnson\"},{\"text\":\"Can you help me with my order?\",\"timestamp\":1234567950000,\"sender\":\"Sarah Johnson\"}]"
    },
    "android": {
      "priority": "high"
    }
  }
}
```

### PHP Example (Backend)

```php
use Google\Client as GoogleClient;

function sendNotification($fcmToken, $title, $body, $data = []) {
    // Get access token using service account
    $client = new GoogleClient();
    $client->setAuthConfig('/path/to/service-account.json');
    $client->addScope('https://www.googleapis.com/auth/firebase.messaging');
    $accessToken = $client->fetchAccessTokenWithAssertion()['access_token'];

    $url = 'https://fcm.googleapis.com/v1/projects/your-project-id/messages:send';

    $notification = [
        'message' => [
            'token' => $fcmToken,
            'notification' => [
                'title' => $title,
                'body' => $body,
            ],
            'data' => $data,
            'android' => [
                'priority' => 'high',
            ],
        ],
    ];

    $headers = [
        'Authorization: Bearer ' . $accessToken,
        'Content-Type: application/json',
    ];

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($notification));

    $response = curl_exec($ch);
    curl_close($ch);

    return json_decode($response, true);
}

// Usage examples:

// 1. Text notification
sendNotification(
    $userFcmToken,
    'Order Shipped',
    'Your order #12345 is on the way!',
    ['type' => 'order', 'order_id' => '12345']
);

// 2. Image notification
sendNotification(
    $userFcmToken,
    '🎉 Flash Sale!',
    'Get 50% off today!',
    [
        'type' => 'promo',
        'promo_id' => '789',
        'image' => 'https://cdn.example.com/banner.jpg'
    ]
);

// 3. Messaging notification
$messages = [
    ['text' => 'Hey!', 'timestamp' => time() * 1000, 'sender' => 'John'],
    ['text' => 'Are you there?', 'timestamp' => time() * 1000 + 60000, 'sender' => 'John'],
];

sendNotification(
    $userFcmToken,
    'John Doe',
    'Are you there?',
    [
        'type' => 'message',
        'conversation_id' => '123',
        'messages' => json_encode($messages)
    ]
);
```

---

## Advanced Configuration

### Custom Sound

To add a custom notification sound:

1. Add sound file to `android/app/src/main/res/raw/notification.mp3`
2. Uncomment the sound line in notification details:
   ```dart
   sound: RawResourceAndroidNotificationSound('notification'),
   ```

### Android 13+ Permissions

The service automatically handles notification permissions on Android 13+:

```dart
await LocalNotificationService.requestPermission();
```

This is called during app initialization in `main.dart`.

---

## Architecture Benefits

✅ **Centralized** - Single service for all notification types
✅ **Flexible** - Easily add new notification types
✅ **Type-Safe** - Uses RemoteMessage from Firebase
✅ **Logged** - Integrated with FirebaseLogger for debugging
✅ **Consistent** - Uses DioClient for all network requests
✅ **Cached** - Images and app logo cached for performance

---

## Troubleshooting

### Notification not showing?
1. Check Firebase logs in console: `[🔔 Local Notifications]`
2. Verify notification permissions are granted
3. Ensure app is initialized: `LocalNotificationService.init()`

### Image not loading?
1. Check image URL in DioClient logs: `[📡 DIO LOG]`
2. Verify image URL is accessible (not behind authentication)
3. Falls back to text-only if image fails

### Messaging style not working?
1. Verify `messages` JSON format matches documentation
2. Check timestamps are in milliseconds (not seconds)
3. Review FirebaseLogger for parsing errors

### Navigation not working?
1. Uncomment navigation route in tap handler methods
2. Verify route is registered in `Routes` class
3. Check payload contains required data (e.g., `order_id`)

---

## Summary: Proper Payload Formats

### 1. Text Only
```json
{
  "notification": {"title": "...", "body": "..."},
  "data": {"type": "order"}
}
```

### 2. With Image
```json
{
  "notification": {"title": "...", "body": "..."},
  "data": {"type": "promo", "image": "https://..."}
}
```

### 3. Messaging (Chat)
```json
{
  "notification": {"title": "Sender Name", "body": "Latest message"},
  "data": {
    "type": "message",
    "messages": "[{\"text\":\"...\",\"timestamp\":123...,\"sender\":\"...\"}]"
  }
}
```

---

**Last Updated:** November 2025
**Version:** 1.0
**Maintainer:** Claude Code
