# Firebase Messaging Background Handler — Complete Guide (Flutter)

## 1. App States Overview

Your Flutter app can be in 3 possible states:

### **1️⃣ Foreground**
- App is open and on screen.
- Handler used:
```
FirebaseMessaging.onMessage.listen(...)
```
- You can update UI, show dialogs, navigate.

---

### **2️⃣ Background**
- App is minimized or behind other apps.
- Handler:
```
firebaseMessagingBackgroundHandler(RemoteMessage message)
```
- Runs even if app is not visible.
- Cannot show UI.
- Can log, save data, update database.

---

### **3️⃣ Terminated**
- App is fully closed/swiped away.
- STILL receives **data messages**.
- Background handler executes in a special background isolate.

---

## 2. Why the Background Handler Works Even When App is Closed

Because Android/iOS allow Firebase Messaging to:
- Wake up a small process
- Deliver the incoming push
- Run your background handler

Even when:
✔ App is installed  
✔ App is not running  
✔ Phone is locked  
✔ App was removed from recent apps  

---

## 3. Notification vs Data Message

### **Notification Message (from Firebase Console)**
```
{
  "notification": {
    "title": "Promo",
    "body": "50% OFF!"
  }
}
```
- OS displays notification automatically.
- Background handler **DOES NOT RUN**.
- Handler runs ONLY when user taps notification.

---

### **Data Message (Required for background handler)**
```
{
  "data": {
    "order_id": "123",
    "type": "order_accepted"
  }
}
```
- Works in **foreground**, **background**, and **terminated**.
- Always delivered to `firebaseMessagingBackgroundHandler`.

---

## 4. Background Handler Requirements

Background handler **must**:
✔ Be top-level  
✔ Not inside any class  
✔ Not inside main()  
✔ No UI code allowed  

Example:
```dart
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("BG Message: ${message.data}");
}
```

---

## 5. Real-World Use Cases

| Use Case | Type | Works When App Closed? | Why |
|---------|------|-------------------------|-----|
| Order status update | Data | ✅ YES | Critical |
| Delivery rider location | Data | ✅ YES | Real-time updates |
| Chat messages | Data | ✅ YES | Needs background |
| Promo notifications | Notification | ❌ NO | Console only |

---

## 6. Full Firebase Messaging Initialization Flow

### **Step 1 — Register background handler FIRST**
```dart
FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
```

### **Step 2 — Initialize Firebase**
```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

### **Step 3 — Request permissions**
```dart
await messaging.requestPermission(alert: true, badge: true, sound: true);
```

### **Step 4 — Get FCM token**
```dart
final token = await messaging.getToken();
```

### **Step 5 — Foreground listener**
```dart
FirebaseMessaging.onMessage.listen((message) { ... });
```

### **Step 6 — When user taps notification**
```dart
FirebaseMessaging.onMessageOpenedApp.listen((message) { ... });
```

---

## 7. How to Test Background Handler

Send a **data-only** message:
```
{
  "to": "<FCM_TOKEN>",
  "data": {
    "hello": "background"
  }
}
```

Expected log:
```
===== 📩 BACKGROUND MESSAGE RECEIVED =====
Data: {hello: background}
===== END =====
```

Works even if:
✔ App closed  
✔ Phone locked  
✔ App killed from recent apps  

---

## 8. Quick Behavior Summary

| Feature | Foreground | Background | Terminated |
|--------|------------|------------|------------|
| Receive Data Message | ✅ | ✅ | ✅ |
| Receive Notification Message | ✅ | ❌ | ❌ |
| Background Handler Runs | ❌ | ✅ | ✅ |
| UI Allowed | ✅ | ❌ | ❌ |

---

## 9. Important Rules to Remember

- Firebase Console **cannot** send data messages alone → must use POST API or Postman.
- Notification + Data is allowed, but background handler receives **only the data part**.
- All logic that must run when app is closed → put in background handler.

---

## 10. Keep This Guide
This `.md` file contains everything needed to understand how Firebase Messaging behaves in Flutter.
