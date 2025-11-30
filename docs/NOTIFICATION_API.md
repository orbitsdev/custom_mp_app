# Notification API Documentation

## Overview

The Notification API provides endpoints for managing user notifications in the mobile app. It uses a **two-table system**:
- **`notifications` table** - User's in-app notification inbox (what users see)
- **`notification_logs` table** - FCM push notification delivery tracking (for admin/debugging)

## Base URL
```
https://dev.avantefoods.com/api
```

## Authentication

All endpoints require authentication using Laravel Sanctum bearer tokens.

**Header:**
```
Authorization: Bearer {your_token}
Accept: application/json
```

---

## Endpoints

### 1. Get All Notifications

Retrieve all notifications for the authenticated user (paginated).

**Endpoint:** `GET /notifications`

**Headers:**
```json
{
  "Authorization": "Bearer {token}",
  "Accept": "application/json"
}
```

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `page` | integer | No | Page number (default: 1) |
| `per_page` | integer | No | Items per page (default: 20) |

**Success Response (200 OK):**
```json
{
  "status": true,
  "message": "Notifications retrieved successfully",
  "data": {
    "items": [
      {
        "id": "3a20784a-e0d3-49db-a2d4-c56780a31905",
        "type": "order_status_update",
        "title": "Order Update",
        "body": "Your order has been shipped",
        "data": {
          "order_id": "43",
          "screen": "order_details",
          "status": "shipped"
        },
        "read_at": null,
        "is_read": false,
        "created_at": "2025-11-27T05:25:19.000000Z"
      }
    ],
    "pagination": {
      "current_page": 1,
      "last_page": 3,
      "per_page": 20,
      "total": 45,
      "next_page_url": "https://dev.avantefoods.com/api/notifications?page=2",
      "prev_page_url": null
    }
  }
}
```

**Example Request:**
```bash
curl -X GET "https://dev.avantefoods.com/api/notifications?page=1" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Accept: application/json"
```

---

### 2. Get Unread Notifications

Retrieve only unread notifications for the authenticated user (paginated).

**Endpoint:** `GET /notifications/unread`

**Headers:**
```json
{
  "Authorization": "Bearer {token}",
  "Accept": "application/json"
}
```

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `page` | integer | No | Page number (default: 1) |
| `per_page` | integer | No | Items per page (default: 20) |

**Success Response (200 OK):**
```json
{
  "status": true,
  "message": "Unread notifications retrieved successfully",
  "data": {
    "items": [
      {
        "id": "bf3c99c2-9627-4604-9952-d10f8344a385",
        "type": "order_status_update",
        "title": "Order Delivered",
        "body": "Your order has been delivered",
        "data": {
          "order_id": "43",
          "screen": "order_details"
        },
        "read_at": null,
        "is_read": false,
        "created_at": "2025-11-27T05:25:08.000000Z"
      }
    ],
    "pagination": {
      "current_page": 1,
      "last_page": 1,
      "per_page": 20,
      "total": 5,
      "next_page_url": null,
      "prev_page_url": null
    }
  }
}
```

**Example Request:**
```bash
curl -X GET "https://dev.avantefoods.com/api/notifications/unread" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Accept: application/json"
```

---

### 3. Get Unread Notification Count

Get the count of unread notifications (useful for badge display).

**Endpoint:** `GET /notifications/unread-count`

**Headers:**
```json
{
  "Authorization": "Bearer {token}",
  "Accept": "application/json"
}
```

**Success Response (200 OK):**
```json
{
  "status": true,
  "message": "Unread count retrieved successfully",
  "data": {
    "count": 5
  }
}
```

**Example Request:**
```bash
curl -X GET "https://dev.avantefoods.com/api/notifications/unread-count" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Accept: application/json"
```

---

### 4. Mark Notification as Read

Mark a specific notification as read.

**Endpoint:** `POST /notifications/{id}/mark-read`

**Headers:**
```json
{
  "Authorization": "Bearer {token}",
  "Accept": "application/json"
}
```

**URL Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `id` | string (UUID) | Yes | Notification ID |

**Success Response (200 OK):**
```json
{
  "status": true,
  "message": "Notification marked as read",
  "data": {
    "id": "3a20784a-e0d3-49db-a2d4-c56780a31905",
    "type": "order_status_update",
    "title": "Order Update",
    "body": "Your order has been shipped",
    "data": {
      "order_id": "43",
      "screen": "order_details"
    },
    "read_at": "2025-11-30T08:18:59.000000Z",
    "is_read": true,
    "created_at": "2025-11-27T05:25:19.000000Z"
  }
}
```

**Error Response (404 Not Found):**
```json
{
  "status": false,
  "message": "Notification not found"
}
```

**Example Request:**
```bash
curl -X POST "https://dev.avantefoods.com/api/notifications/3a20784a-e0d3-49db-a2d4-c56780a31905/mark-read" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Accept: application/json"
```

---

### 5. Mark All Notifications as Read

Mark all unread notifications as read for the authenticated user.

**Endpoint:** `POST /notifications/mark-all-read`

**Headers:**
```json
{
  "Authorization": "Bearer {token}",
  "Accept": "application/json"
}
```

**Success Response (200 OK):**
```json
{
  "status": true,
  "message": "All notifications marked as read",
  "data": {
    "updated_count": 13
  }
}
```

**Example Request:**
```bash
curl -X POST "https://dev.avantefoods.com/api/notifications/mark-all-read" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Accept: application/json"
```

---

### 6. Delete Notification

Delete a specific notification from the user's inbox.

**Endpoint:** `DELETE /notifications/{id}`

**Headers:**
```json
{
  "Authorization": "Bearer {token}",
  "Accept": "application/json"
}
```

**URL Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `id` | string (UUID) | Yes | Notification ID |

**Success Response (200 OK):**
```json
{
  "status": true,
  "message": "Notification deleted successfully",
  "data": null
}
```

**Error Response (404 Not Found):**
```json
{
  "status": false,
  "message": "Notification not found"
}
```

**Example Request:**
```bash
curl -X DELETE "https://dev.avantefoods.com/api/notifications/3a20784a-e0d3-49db-a2d4-c56780a31905" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Accept: application/json"
```

---

### 7. Clear All Read Notifications

Delete all read notifications for the authenticated user.

**Endpoint:** `DELETE /notifications/read/clear`

**Headers:**
```json
{
  "Authorization": "Bearer {token}",
  "Accept": "application/json"
}
```

**Success Response (200 OK):**
```json
{
  "status": true,
  "message": "Read notifications cleared successfully",
  "data": {
    "deleted_count": 25
  }
}
```

**Example Request:**
```bash
curl -X DELETE "https://dev.avantefoods.com/api/notifications/read/clear" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Accept: application/json"
```

---

## Notification Types

The `type` field indicates what kind of notification it is. Common types include:

| Type | Description | Data Fields |
|------|-------------|-------------|
| `order_status_update` | Order status changed | `order_id`, `status`, `screen` |
| `product` | Product update/promotion | `product_id`, `screen` |
| `promo` | Promotional notification | `promo_id`, `screen` |
| `welcome` | Welcome notification | `screen` |
| `general` | General notification | Custom fields |

---

## Response Structure

All responses follow the same structure:

**Success Response:**
```json
{
  "status": true,
  "message": "Success message",
  "data": { /* response data */ }
}
```

**Error Response:**
```json
{
  "status": false,
  "message": "Error message",
  "errors": { /* validation errors if applicable */ }
}
```

---

## Notification Object

Each notification object contains:

| Field | Type | Description |
|-------|------|-------------|
| `id` | string (UUID) | Unique notification identifier |
| `type` | string | Notification type (e.g., "order_status_update") |
| `title` | string | Notification title |
| `body` | string | Notification message body |
| `data` | object | Additional data payload (varies by type) |
| `read_at` | string/null | ISO 8601 timestamp when read (null if unread) |
| `is_read` | boolean | Whether notification has been read |
| `created_at` | string | ISO 8601 timestamp when created |

---

## Error Codes

| Status Code | Description |
|-------------|-------------|
| 200 | Success |
| 400 | Bad Request (validation error) |
| 401 | Unauthorized (invalid/missing token) |
| 404 | Not Found (notification doesn't exist) |
| 500 | Internal Server Error |

---

## Testing Endpoints (Admin Only)

These endpoints are for testing notification delivery. They should only be used for development/testing.

### Send Flexible Notification

**Endpoint:** `POST /notification/send-flex`

**Request Body:**
```json
{
  "token": "FCM_DEVICE_TOKEN",
  "title": "Test Notification",
  "body": "This is a test notification",
  "data": {
    "custom_key": "custom_value",
    "screen": "home"
  },
  "notification_type": "test"
}
```

**Success Response:**
```json
{
  "status": true,
  "message": "Flexible notification queued.",
  "data": null
}
```

---

## How It Works

1. **Notification Created**: When an event occurs (order status change, new promo, etc.), the system creates:
   - Entry in `notifications` table (user inbox)
   - Entry in `notification_logs` table (FCM tracking)
   - FCM push notification sent to user's device

2. **User Receives**: User receives push notification on their device AND sees it in the in-app notification inbox

3. **User Interacts**:
   - Opens notification → Mark as read
   - Clears notifications → Delete
   - Badge count updates in real-time

4. **Data Flow**:
   ```
   Event (Order Status Change)
        ↓
   SendFirebaseNotificationJob
        ↓
   ├─→ Create NotificationLog (FCM tracking)
   ├─→ Send FCM Push Notification
   └─→ Create Notification (In-app inbox)
        ↓
   User Views via API
   ```

---

## Best Practices

1. **Polling vs Real-time**:
   - Poll `/notifications/unread-count` periodically for badge updates
   - Use FCM for real-time push notifications

2. **Performance**:
   - Use pagination for notification lists
   - Cache unread count on device, refresh periodically

3. **User Experience**:
   - Mark as read when user taps notification
   - Show badge with unread count
   - Group notifications by date

4. **Error Handling**:
   - Handle 401 errors by re-authenticating
   - Retry failed requests with exponential backoff
   - Show user-friendly error messages

---

## Example Integration (Flutter/Dart)

```dart
// Get unread count for badge
Future<int> getUnreadCount() async {
  final response = await dio.get(
    '/notifications/unread-count',
    options: Options(headers: {'Authorization': 'Bearer $token'}),
  );
  return response.data['data']['count'];
}

// Get notifications
Future<List<Notification>> getNotifications({int page = 1}) async {
  final response = await dio.get(
    '/notifications',
    queryParameters: {'page': page},
    options: Options(headers: {'Authorization': 'Bearer $token'}),
  );
  return (response.data['data']['items'] as List)
      .map((item) => Notification.fromJson(item))
      .toList();
}

// Mark as read
Future<void> markAsRead(String notificationId) async {
  await dio.post(
    '/notifications/$notificationId/mark-read',
    options: Options(headers: {'Authorization': 'Bearer $token'}),
  );
}

// Mark all as read
Future<void> markAllAsRead() async {
  await dio.post(
    '/notifications/mark-all-read',
    options: Options(headers: {'Authorization': 'Bearer $token'}),
  );
}
```

---

## Support

For issues or questions, please contact the development team or refer to the main API documentation.

**Last Updated:** 2025-11-30
**API Version:** 1.0
