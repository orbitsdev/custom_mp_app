// import 'package:firebase_analytics/firebase_analytics.dart';

// class Analytics {
//   // Singleton instance for FirebaseAnalytics
//   static final FirebaseAnalytics _instance = FirebaseAnalytics.instance;

//   /// Logs a custom event with the given [name] and optional [parameters].
//   ///
//   /// - [name]: The name of the event to log.
//   /// - [parameters]: A map of key-value pairs representing additional event data (optional).
//   static Future<void> logEvent({
//     required String name,
//     Map<String, Object>? parameters, // Change to Map<String, Object> to match Firebase's requirement
//   }) async {
//     try {
//       // Filter out null values from parameters
//       parameters?.removeWhere((key, value) => value == null);

//       // Log the event with Firebase Analytics
//       await _instance.logEvent(name: name, parameters: parameters);

     
//     } catch (e) {
//       print('Error logging Analytics event: $name, error: $e');
//     }
//   }

//   /// Logs a custom screen view with the given [screenName].
//   ///
//   /// - [screenName]: The name of the screen to log.
//   static Future<void> logScreenView({
//     required String screenName,
//   }) async {
//     try {
//       await _instance.logScreenView(screenName: screenName);
     
//     } catch (e) {
//       print('Error logging screen view: $screenName, error: $e');
//     }
//   }


//    static Future<void> logLogin({
//     required String loginMethod,
//   }) async {
//     try {
//       await _instance.logLogin(loginMethod: loginMethod);
//     } catch (e) {
//       print('Error logging login event: $e');
//     }
//   }

//   /// Logs a sign-up event with the given [signUpMethod].
//   static Future<void> logSignUp({
//     required String signUpMethod,
//   }) async {
//     try {
//       await _instance.logSignUp(signUpMethod: signUpMethod);
//     } catch (e) {
//       print('Error logging sign-up event: $e');
//     }
//   }

//   /// Logs an add-to-cart event with the given details.
//    static Future<void> logAddToCart({
//     required String itemId,
//     required String itemName,
//     required double price,
//     required String currency,
//     required int quantity,
//   }) async {
//     try {
//       await _instance.logEvent(
//         name: 'add_to_cart',
//         parameters: {
//           'item_id': itemId, // Correct parameter naming
//           'item_name': itemName,
//           'price': price,
//           'currency': currency,
//           'quantity': quantity,
//         },
//       );
//     } catch (e) {
//       print('Error logging add-to-cart event: $e');
//     }
//   }
//    static Future<void> logUserActivity({required String activity}) async {
//     try {
//       await _instance.logEvent(
//         name: 'user_activity',
//         parameters: {'activity': activity},
//       );
//     } catch (e) {
//       print('Error logging user activity: $activity, error: $e');
//     }
//   }
//   static Future<void> setUserProperty({required String propertyName, required String value}) async {
//   try {
//     await _instance.setUserProperty(name: propertyName, value: value);
//   } catch (e) {
//     print('Error setting user property: $propertyName, error: $e');
//   }
// }

// static Future<void> logViewItem({
//   required String itemId,
//   required String itemName,
//   String? category, // Optional parameter for item category
// }) async {
//   try {
//     await _instance.logEvent(
//       name: 'view_item',
//       parameters: {
//         'item_id': itemId, // The unique identifier for the item
//         'item_name': itemName, // The name of the item being viewed
//         'currency': 'PHP', // The currency of the price
        
//       },
//     );
//   } catch (e) {
//     print('Error logging view item event: $e');
//   }
// }


// }
