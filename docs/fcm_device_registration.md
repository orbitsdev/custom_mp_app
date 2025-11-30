# FCM Device Registration - Flutter App Implementation

## Overview

This document describes what the **Flutter mobile app sends and expects** for the User Device Registration System. This enables push notifications by registering user devices with the backend.

---

## What the App Does

### 1. Device Registration
The app automatically registers devices at these times:
- After successful login
- After signup
- On app startup (if already logged in)
- When FCM token refreshes

### 2. Device Logout
The app deactivates devices when user logs out.

---

## API Endpoints the App Calls

### Base URL
```
https://dev.avantefoods.com/api/
```

---

### 1. Register Device

**What the app sends:**

```http
POST /api/mobile/user-devices/register
Authorization: Bearer {access_token}
Content-Type: application/json
```

**Request Body:**
```json
{
  "device_id": "TP1A.220624.014",
  "fcm_token": "cynNkzM9Tn2a0u12jVrx84:APA91bE5hbFE...",
  "platform": "android",
  "device_model": "Infinix Infinix X6837",
  "app_version": "1.0.0"
}
```

**What the app expects back:**
```json
{
  "success": true,
  "message": "Device registered successfully.",
  "data": {
    "id": 10,
    "user_id": 9,
    "device_id": "TP1A.220624.014",
    "fcm_token": "cynNkzM9Tn2a0u12jVrx84:APA91bE5hbFE...",
    "platform": "android",
    "device_model": "Infinix Infinix X6837",
    "app_version": "1.0.0",
    "is_active": true,
    "last_used_at": {
      "formatted": "Nov 26, 2025 at 2:10 PM",
      "human": "0 seconds ago",
      "timestamp": 1764166223
    },
    "created_at": {
      "formatted": "Nov 26, 2025 at 2:08 PM",
      "human": "2 minutes ago",
      "timestamp": 1764166084
    },
    "updated_at": {
      "formatted": "Nov 26, 2025 at 2:10 PM",
      "human": "0 seconds ago",
      "timestamp": 1764166223
    }
  }
}
```

---

### 2. Logout Device

**What the app sends:**

```http
POST /api/mobile/user-devices/logout
Authorization: Bearer {access_token}
Content-Type: application/json
```

**Request Body:**
```json
{
  "device_id": "TP1A.220624.014"
}
```

**What the app expects back:**
```json
{
  "success": true,
  "message": "Device logout successful.",
  "data": null
}
```

---

## Device Information

### Device ID
- **Android:** Build ID (e.g., `"TP1A.220624.014"`)
- **iOS:** identifierForVendor (UUID format)
- **Type:** String

### FCM Token
- Obtained from Firebase Cloud Messaging
- **Type:** String (long token)
- **Example:** `"cynNkzM9Tn2a0u12jVrx84:APA91bE5hbFE..."`

### Platform
- **Values:** `"android"`, `"ios"`, `"web"`
- **Type:** String

### Device Model
- **Android Example:** `"Infinix Infinix X6837"`, `"Samsung Galaxy S23"`
- **iOS Example:** `"iPhone 14 Pro"`
- **Type:** String (optional)

### App Version
- **Example:** `"1.0.0"`
- **Type:** String (optional)

---

## Registration Frequency

| Event | When | Estimated Frequency |
|-------|------|---------------------|
| Login | User enters credentials | ~1-3 per day |
| Signup | New account created | Once |
| App Startup | App opens (if logged in) | ~5-10 per day |
| FCM Token Refresh | Firebase updates token | Rare (weeks/months) |
| Logout | User logs out | ~1 per day |

**Total:** ~10-15 API calls per user per day

---

## Notification Format Expected by App

The app expects notifications in this format:

### Required Fields (All Notifications)
```json
{
  "notification": {
    "title": "Notification Title",
    "body": "Notification message"
  },
  "data": {
    "type": "order|product|promo|new_product|message|default"
  }
}
```

### Notification Types

| Type | Required `data` Fields | Optional `data` Fields | App Behavior |
|------|----------------------|----------------------|--------------|
| `order` | `order_id` (string) | `image` (URL), `screen` | Opens order details page |
| `product` | `product_id` (string) | `image` (URL), `screen` | Opens product details page |
| `promo` | `promo_id` (string) | `image` (URL), `screen` | Opens promo page |
| `new_product` | `product_id` (string) | `image` (URL), `screen` | Opens product details page |
| `message` | `messages` (JSON string) | `image` (URL), `screen` | Opens chat/message screen |
| `default` | None | `image` (URL), `screen` | Opens home page |

---

### Example: Order Update Notification

**Backend should send:**
```json
{
  "notification": {
    "title": "Order Update",
    "body": "Your order #1234 is out for delivery"
  },
  "data": {
    "type": "order",
    "order_id": "1234",
    "image": "https://example.com/order-image.jpg",
    "screen": "order_details"
  }
}
```

**App will:**
- Display notification with title and body
- Show image if provided
- Open order details page when tapped

---

### Example: Product Notification

**Backend should send:**
```json
{
  "notification": {
    "title": "Price Drop Alert!",
    "body": "Product XYZ is now only ₱499"
  },
  "data": {
    "type": "product",
    "product_id": "567",
    "image": "https://example.com/product.jpg",
    "screen": "product_details"
  }
}
```

**App will:**
- Display notification with product image
- Open product details page when tapped

---

### Example: Promo Notification

**Backend should send:**
```json
{
  "notification": {
    "title": "🔥 Flash Sale!",
    "body": "Up to 50% off. Limited time only!"
  },
  "data": {
    "type": "promo",
    "promo_id": "890",
    "image": "https://example.com/promo-banner.jpg",
    "screen": "promo_page"
  }
}
```

**App will:**
- Display promo banner
- Open promotional page when tapped

---

### Example: Generic Notification

**Backend should send:**
```json
{
  "notification": {
    "title": "Welcome Back!",
    "body": "Check out what's new"
  },
  "data": {
    "type": "default",
    "screen": "home"
  }
}
```

**App will:**
- Display simple notification
- Open home page when tapped

---

## Important Data Format Requirements

### IDs Must Be Strings
```json
✅ Correct:   "order_id": "1234"
❌ Incorrect: "order_id": 1234
```

### Image Must Be URL or null
```json
✅ Correct:   "image": "https://example.com/img.jpg"
✅ Correct:   "image": null
❌ Incorrect: "image": ""
```

### Image Specifications
- Must be publicly accessible (HTTPS)
- Recommended: 1024x512px (2:1 ratio)
- Format: JPG, PNG, WebP
- Max size: 1MB

### Text Limits
- Title: Max 65 characters recommended
- Body: Max 240 characters recommended

---

## Response Format Requirements

### Timestamp Objects
The app expects timestamps in this format:
```json
{
  "formatted": "Nov 26, 2025 at 2:10 PM",
  "human": "0 seconds ago",
  "timestamp": 1764166223
}
```

### Success Response
```json
{
  "success": true,
  "message": "Success message",
  "data": { ... }
}
```

### Error Response
```json
{
  "success": false,
  "message": "Error message",
  "errors": {
    "field_name": ["Error detail"]
  }
}
```

---

## Testing

### How to Test Device Registration

1. **Login to the app**
2. **Check console logs for:**
   ```
   📱 [UserDeviceController] Registering device...
   🔑 Device ID: TP1A.220624.014
   🔔 FCM Token: cynNkzM9Tn...
   [📡 DIO LOG] POST /api/mobile/user-devices/register
   ✅ Device registered successfully
   ```

3. **Verify in database:**
   - Check `user_devices` table
   - Confirm `device_id` and `fcm_token` are stored
   - Confirm `is_active = true`

### How to Test Notifications

1. **Get FCM token from app logs**
2. **Send test notification via Firebase Console** or API
3. **Verify notification appears on device**
4. **Tap notification → verify app opens correct screen**

### Test Notification (cURL Example)
```bash
curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: Bearer YOUR_SERVER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "registration_ids": ["FCM_TOKEN_FROM_DATABASE"],
    "notification": {
      "title": "Test Order Update",
      "body": "Your order #999 is ready"
    },
    "data": {
      "type": "order",
      "order_id": "999",
      "image": null
    }
  }'
```

---

## Summary for Backend Team

### What Backend Needs to Know

1. ✅ **The app sends device info to these endpoints:**
   - `POST /api/mobile/user-devices/register`
   - `POST /api/mobile/user-devices/logout`

2. ✅ **The app expects specific response formats** (see above)

3. ✅ **The app expects notifications in specific format** (see notification types)

4. ✅ **Important data requirements:**
   - IDs must be strings
   - Images must be HTTPS URLs or null
   - Timestamps must have 3 fields (formatted, human, timestamp)

5. ✅ **The app is already implemented and working:**
   - Registration happens automatically
   - Device info is sent correctly
   - Ready to receive notifications

---

## Questions Backend Team Should Answer

1. Are the API endpoints working correctly?
2. Is the `user_devices` table created?
3. Are devices being stored in the database?
4. Can you send test notifications to registered devices?
5. Are timestamps returned in the correct format?

---

## Status

**Flutter Implementation:** ✅ Complete
**Backend Integration:** ⏳ Pending

**Ready for:** Backend testing and notification sending implementation

---

## Contact

For questions about what the app sends/expects, contact the Flutter developer.

For implementation questions, refer to existing API documentation.
