# Firebase Messaging (FCM) — Complete Overview & Best Practices
This document explains how Firebase Cloud Messaging works, how tokens are generated, how multi-device systems work, and how to properly handle shared devices in production apps like Grab, GCash, Shopee, TikTok, etc.

---

## 🔥 1. What is Firebase Cloud Messaging (FCM)?
FCM is Google’s push notification service used to send notifications from a backend (Laravel) to mobile devices (Flutter).

### Key Points:
- Backend sends messages → Firebase → Device  
- Works even if the app is closed  
- Completely FREE  
- Most reliable push system in the world  

---

## 📱 2. How FCM Works (Simple Flow)
1. Flutter app installs → asks Firebase for a token  
2. Firebase returns a **unique FCM token**  
3. Flutter sends the token to Laravel  
4. Laravel saves token to database  
5. Laravel selects which token(s) to send notifications to  
6. Firebase delivers notifications to device(s)

---

## 🔑 3. Why FCM Token Is Important
The token uniquely identifies a device installation.

- Phone A → token A  
- Phone B → token B  
- Tablet C → token C  

Backend **never generates** tokens.  
Only the device generates it.

---

## 📌 4. WHY Multi-Token Per User Is Standard
Modern users often use multiple devices:
- Phone  
- Second phone  
- Tablet  
- Emulator  
- Web browser  

That’s why professional apps store **multiple tokens** per user.

Examples:
- Shopee  
- Lazada  
- Facebook  
- TikTok  
- GCash  
- Grab (customer side)

---

## 🗄️ 5. Recommended `user_devices` Table Structure

| Column | Purpose |
|--------|---------|
| id | Primary key |
| user_id | Linked user |
| fcm_token | Token for notifications |
| device_id | Unique physical device ID |
| device_model | Ex: Samsung A52 |
| platform | android / ios / web |
| app_version | Ex: 1.0.5 |
| is_active | true/false |
| last_used_at | Last time device was active |
| created_at | Timestamp |
| updated_at | Timestamp |

This is the **standard used by real apps**.

---

## 🧠 6. Why Each Field Matters

### `fcm_token`
Needed to send notifications.

### `device_id`
Prevents cross-user notifications on shared devices.

### `is_active`
Used to restrict notifications to select devices.

### `last_used_at`
Used for cleanup to remove devices inactive for 6–12 months.

---

## 🚗 7. Real-World Scenarios

### Shopee / Lazada / Facebook
- All devices receive notifications  
- Multi-device fully supported  

### Grab Driver App
- Only ONE active device can receive booking requests  
- Uses `device_id` and `is_active`  

### Banking apps (GCash, BPI, BDO)
- Only MOST RECENT device receives notifications  
- Prioritizes security  

---

## 🧩 8. Handling Shared Devices (Very Important)

### Problem:
- User A logs in on a phone  
- User B borrows phone and logs in  
- Device token linked to User B  
- If User A logs in again → cross-user notification risk  

### ⭐ PROFESSIONAL SOLUTION

#### On Login:
1. Identify device by `device_id`  
2. DELETE any device record belonging to OTHER users  
3. Store/update FCM token for current user  
4. Set `is_active = true`  
5. Update `last_used_at`  

Laravel example:
```php
UserDevice::where('device_id', $request->device_id)
    ->where('user_id', '!=', $user->id)
    ->delete();

UserDevice::updateOrCreate(
    ['user_id' => $user->id, 'device_id' => $request->device_id],
    [
        'fcm_token' => $request->fcm_token,
        'device_model' => $request->device_model,
        'platform' => $request->platform,
        'app_version' => $request->app_version,
        'is_active' => true,
        'last_used_at' => now(),
    ]
);
```

#### On Logout:
```php
UserDevice::where('device_id', $deviceId)
    ->update(['is_active' => false]);
```

#### On App Reopen:
- Flutter refreshes token  
- Backend updates `last_used_at`  

#### On Token Cleanup:
Delete devices inactive for 6–12 months:
```php
UserDevice::where('last_used_at', '<', now()->subMonths(12))->delete();
```

---

## 📡 9. Sending Notifications (Backend)

To send to all active devices:
```php
$tokens = UserDevice::where('user_id', $id)
    ->where('is_active', true)
    ->pluck('fcm_token');

$messaging->sendMulticast($message, $tokens->toArray());
```

Backend decides who receives messages:
- role-based  
- driver-only  
- admin-only  
- nearest driver  
- last active device  

---

## 🧨 10. Final Summary

- FCM token comes from the DEVICE  
- Backend saves token + device info  
- Multi-device per user is STANDARD  
- Device ownership must be handled correctly  
- Shared devices require token cleanup logic  
- `device_id` prevents cross-user notifications  
- `is_active` controls which device receives messages  
- `last_used_at` helps cleanup inactive devices  
- Professional apps NEVER delete device on logout  
- They only set `is_active = false`  

---

## ✔ This setup is used by:
- Grab  
- Angkas  
- Shopee  
- Lazada  
- GCash  
- Facebook  
- TikTok  
- Uber  
