# User Devices API Documentation

Base URL: `/api/mobile/user-devices`

All endpoints require authentication via Bearer token.

---

## 1. Register Device

Register or update a device for push notifications.

### Endpoint
```
POST /api/mobile/user-devices/register
```

### Headers
```
Authorization: Bearer {access_token}
Content-Type: application/json
Accept: application/json
```

### Request Body
```json
{
    "device_id": "string (required)",
    "fcm_token": "string (required)",
    "platform": "string (required: android|ios|web)",
    "device_model": "string (optional)",
    "app_version": "string (optional)"
}
```

#### Parameters Description

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `device_id` | string | Yes | Unique device identifier |
| `fcm_token` | string | Yes | Firebase Cloud Messaging token |
| `platform` | string | Yes | Must be one of: `android`, `ios`, or `web` |
| `device_model` | string | No | Device model name (e.g., "iPhone 14 Pro", "Samsung Galaxy S23") |
| `app_version` | string | No | Application version (e.g., "1.0.0") |

### Success Response (200 OK)
```json
{
    "success": true,
    "message": "Device registered successfully.",
    "data": {
        "id": 1,
        "user_id": 123,
        "device_id": "abc123xyz",
        "fcm_token": "fcm_token_here",
        "platform": "android",
        "device_model": "Samsung Galaxy S23",
        "app_version": "1.0.0",
        "is_active": true,
        "last_used_at": "2025-11-26T10:30:00.000000Z",
        "created_at": "2025-11-26T10:30:00.000000Z",
        "updated_at": "2025-11-26T10:30:00.000000Z"
    }
}
```

### Error Responses

#### Validation Error (422 Unprocessable Entity)
```json
{
    "success": false,
    "message": "The given data was invalid.",
    "errors": {
        "device_id": ["The device id field is required."],
        "fcm_token": ["The fcm token field is required."],
        "platform": ["The selected platform is invalid."]
    }
}
```

#### Unauthorized (401)
```json
{
    "success": false,
    "message": "Unauthenticated."
}
```

### Example Request (cURL)
```bash
curl -X POST "https://yourapp.com/api/mobile/user-devices/register" \
  -H "Authorization: Bearer your_access_token_here" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "device_id": "abc123xyz",
    "fcm_token": "fcm_token_here",
    "platform": "android",
    "device_model": "Samsung Galaxy S23",
    "app_version": "1.0.0"
  }'
```

### Notes
- If the same `device_id` is registered by a different user, the previous registration will be deleted
- If the device is already registered for the current user, it will be updated with new information
- The device is automatically marked as active upon registration

---

## 2. Logout Device

Deactivate a device to stop receiving push notifications.

### Endpoint
```
POST /api/mobile/user-devices/logout
```

### Headers
```
Authorization: Bearer {access_token}
Content-Type: application/json
Accept: application/json
```

### Request Body
```json
{
    "device_id": "string (required)"
}
```

#### Parameters Description

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `device_id` | string | Yes | The device ID to logout |

### Success Response (200 OK)
```json
{
    "success": true,
    "message": "Device logout successful.",
    "data": null
}
```

### Error Responses

#### Validation Error (422 Unprocessable Entity)
```json
{
    "success": false,
    "message": "The given data was invalid.",
    "errors": {
        "device_id": ["The device id field is required."]
    }
}
```

#### Unauthorized (401)
```json
{
    "success": false,
    "message": "Unauthenticated."
}
```

### Example Request (cURL)
```bash
curl -X POST "https://yourapp.com/api/mobile/user-devices/logout" \
  -H "Authorization: Bearer your_access_token_here" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "device_id": "abc123xyz"
  }'
```

### Notes
- This sets the device `is_active` flag to `false`
- The device record is not deleted, only deactivated
- User will stop receiving push notifications on this device

---

## 3. List Devices

Get all registered devices for the authenticated user.

### Endpoint
```
GET /api/mobile/user-devices
```

### Headers
```
Authorization: Bearer {access_token}
Accept: application/json
```

### Request Parameters
None

### Success Response (200 OK)
```json
{
    "success": true,
    "message": "Devices retrieved successfully.",
    "data": [
        {
            "id": 1,
            "user_id": 123,
            "device_id": "abc123xyz",
            "fcm_token": "fcm_token_here",
            "platform": "android",
            "device_model": "Samsung Galaxy S23",
            "app_version": "1.0.0",
            "is_active": true,
            "last_used_at": "2025-11-26T10:30:00.000000Z",
            "created_at": "2025-11-26T10:30:00.000000Z",
            "updated_at": "2025-11-26T10:30:00.000000Z"
        },
        {
            "id": 2,
            "user_id": 123,
            "device_id": "xyz789abc",
            "fcm_token": "another_fcm_token",
            "platform": "ios",
            "device_model": "iPhone 14 Pro",
            "app_version": "1.0.0",
            "is_active": false,
            "last_used_at": "2025-11-25T08:15:00.000000Z",
            "created_at": "2025-11-20T14:20:00.000000Z",
            "updated_at": "2025-11-25T08:15:00.000000Z"
        }
    ]
}
```

### Error Responses

#### Unauthorized (401)
```json
{
    "success": false,
    "message": "Unauthenticated."
}
```

### Example Request (cURL)
```bash
curl -X GET "https://yourapp.com/api/mobile/user-devices" \
  -H "Authorization: Bearer your_access_token_here" \
  -H "Accept: application/json"
```

### Notes
- Returns all devices (both active and inactive) for the authenticated user
- Devices are sorted by most recent first (latest)
- Useful for displaying a list of devices in user settings

---

## Common Response Fields

### UserDevice Resource

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique device record ID |
| `user_id` | integer | ID of the user who owns the device |
| `device_id` | string | Unique device identifier |
| `fcm_token` | string | Firebase Cloud Messaging token |
| `platform` | string | Device platform: `android`, `ios`, or `web` |
| `device_model` | string/null | Device model name |
| `app_version` | string/null | Application version |
| `is_active` | boolean | Whether device is active for notifications |
| `last_used_at` | datetime | Last time device was used |
| `created_at` | datetime | When device was first registered |
| `updated_at` | datetime | When device record was last updated |

---

## Authentication

All endpoints require authentication using Laravel Sanctum bearer tokens.

Include the token in the Authorization header:
```
Authorization: Bearer {your_access_token}
```

---

## Rate Limiting

These endpoints may be subject to rate limiting. Check response headers:
- `X-RateLimit-Limit`: Maximum requests allowed
- `X-RateLimit-Remaining`: Remaining requests
- `Retry-After`: Seconds to wait before retrying (on 429 errors)

---

## Error Handling

All endpoints return consistent error responses:

### Format
```json
{
    "success": false,
    "message": "Error description",
    "errors": {
        "field_name": ["Error message"]
    }
}
```

### Common HTTP Status Codes
- `200` - Success
- `401` - Unauthorized (invalid or missing token)
- `422` - Validation Error (invalid input data)
- `429` - Too Many Requests (rate limit exceeded)
- `500` - Internal Server Error
