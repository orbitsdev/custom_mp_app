import 'package:get/get.dart';

/// Notification Binding
///
/// NotificationController is registered in HomeBinding as permanent.
/// This binding just ensures the controller is available (already created by HomeBinding).
class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    // NotificationController is already registered in HomeBinding as permanent
    // We just need to ensure it's available (no need to create it again)
    // The controller will be found via Get.find<NotificationController>()
  }
}
