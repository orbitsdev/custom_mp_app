import 'package:custom_mp_app/app/modules/testing/controllers/testing_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TestingPage extends StatelessWidget {
  const TestingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TestingController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Testing'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            const Text(
              'Test Different Notification Types',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Click any button to trigger a test notification',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Promo Notification
            _NotificationTestButton(
              icon: Icons.local_offer,
              label: 'Promo Notification',
              description: 'With image - shows BigPictureStyle',
              color: Colors.orange,
              onPressed: controller.testPromoNotification,
            ),
            const SizedBox(height: 16),

            // Product Notification
            _NotificationTestButton(
              icon: Icons.shopping_bag,
              label: 'Product Notification',
              description: 'With image - product update',
              color: Colors.blue,
              onPressed: controller.testProductNotification,
            ),
            const SizedBox(height: 16),

            // Order Notification
            _NotificationTestButton(
              icon: Icons.inventory_2,
              label: 'Order Notification',
              description: 'Text only - order status update',
              color: Colors.green,
              onPressed: controller.testOrderNotification,
            ),
            const SizedBox(height: 16),

            // New Product Notification
            _NotificationTestButton(
              icon: Icons.new_releases,
              label: 'New Product Notification',
              description: 'With image - new arrival',
              color: Colors.purple,
              onPressed: controller.testNewProductNotification,
            ),
            const SizedBox(height: 16),

            // Default Notification
            _NotificationTestButton(
              icon: Icons.notifications,
              label: 'Default Notification',
              description: 'Text only - general notification',
              color: Colors.grey,
              onPressed: controller.testDefaultNotification,
            ),
            const SizedBox(height: 16),

            // Long Text Notification
            _NotificationTestButton(
              icon: Icons.text_fields,
              label: 'Long Text Notification',
              description: 'Tests BigTextStyle (expandable)',
              color: Colors.teal,
              onPressed: controller.testLongTextNotification,
            ),
            const SizedBox(height: 16),

            // Broken Image Notification
            _NotificationTestButton(
              icon: Icons.broken_image,
              label: 'Broken Image Fallback',
              description: 'Tests fallback to text-only',
              color: Colors.red,
              onPressed: controller.testBrokenImageNotification,
            ),
            const SizedBox(height: 16),

            // Messaging Notification
            _NotificationTestButton(
              icon: Icons.chat_bubble,
              label: 'Messaging Notification',
              description: 'Chat style with multiple messages',
              color: Colors.indigo,
              onPressed: controller.testMessagingNotification,
            ),
            const SizedBox(height: 16),

            // Debug Notification
            _NotificationTestButton(
              icon: Icons.bug_report,
              label: 'Debug Notification',
              description: 'Simple test notification',
              color: Colors.amber,
              onPressed: controller.testDebugNotification,
            ),
            const SizedBox(height: 32),

            // Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'Testing Notes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '• Notifications use different channels based on type\n'
                    '• Images are cached to avoid re-downloading\n'
                    '• Messaging style shows conversation with multiple messages\n'
                    '• Tap notifications to test navigation handling\n'
                    '• Check Firebase logs for detailed debugging',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationTestButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final Color color;
  final VoidCallback onPressed;

  const _NotificationTestButton({
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      child: Row(
        children: [
          Icon(icon, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }
}
