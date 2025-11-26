import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_logger.dart';


Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  FirebaseLogger.group('📩 BACKGROUND MESSAGE RECEIVED');

  FirebaseLogger.log("Message ID: ${message.messageId}");
  FirebaseLogger.log("Title: ${message.notification?.title}");
  FirebaseLogger.log("Body: ${message.notification?.body}");
  FirebaseLogger.log("Data: ${message.data}");

  FirebaseLogger.endGroup();
}
