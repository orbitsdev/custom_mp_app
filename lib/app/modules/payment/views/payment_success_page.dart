import 'package:custom_mp_app/app/core/routes/routes.dart';
import 'package:custom_mp_app/app/core/enums/order_status.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderReferenceId = Get.arguments?['order_reference_id'] ?? '';
    final orderStatus = Get.arguments?['order_status'] as String?;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Icon
              const Icon(
                Icons.check_circle,
                size: 120,
                color: Colors.green,
              ),
              const SizedBox(height: 32),

              // Success Title
              const Text(
                'Payment Successful!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Order Reference
              if (orderReferenceId.isNotEmpty) ...[
                const Text(
                  'Order Reference:',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  orderReferenceId,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Message
              const Text(
                'Your payment has been processed successfully.\nYour order is being prepared.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // View Order Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => _goToOrderPage(orderStatus),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'View Order',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Back to Home Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () => _goToHome(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green,
                    side: const BorderSide(color: Colors.green),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Back to Home',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],


            
          ),
        ),
      ),
    );
  }

  void _goToOrderPage(String? orderStatus) {
    // Map order status to tab index
    // Tab 0: To Pay (placed)
    // Tab 1: To Ship (processing)
    // Tab 2: To Receive (out_for_delivery)
    // Tab 3: Completed (delivered)
    // Tab 4: Cancelled (canceled)

    int initialTab = 1; // Default to "To Ship" tab after payment success

    if (orderStatus != null) {
      switch (orderStatus) {
        case 'placed':
          initialTab = 0; // To Pay
          break;
        case 'processing':
          initialTab = 1; // To Ship (most common after payment)
          break;
        case 'out_for_delivery':
          initialTab = 2; // To Receive
          break;
        case 'delivered':
          initialTab = 3; // Completed
          break;
        case 'canceled':
          initialTab = 4; // Cancelled
          break;
        default:
          initialTab = 1; // Default to To Ship
      }
    }

    Get.offNamedUntil(
      Routes.ordesrPage,
      (route) => route.settings.name == Routes.homePage,
      arguments: {'initialTab': initialTab},
    );
  }

  void _goToHome() {
    Get.offAllNamed(Routes.homePage);
  }
}
