import 'package:custom_mp_app/app/core/routes/routes.dart';
import 'package:custom_mp_app/app/data/repositories/payment_repository.dart';
import 'package:custom_mp_app/app/global/widgets/modals/app_modal.dart';
import 'package:custom_mp_app/app/global/widgets/toasts/app_toast.dart';
import 'package:custom_mp_app/app/modules/orderpreparation/controllers/order_preparation_controller.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class PaymentWebviewController extends GetxController {
  final PaymentRepository _paymentRepo = PaymentRepository();

  // Loading states
  final isLoading = false.obs;
  final isVerifyingPayment = false.obs;
  final hasCompletedPayment = false.obs;

  // Arguments from navigation
  late String checkoutUrl;
  late String orderReferenceId;
  late String successUrl;
  late String cancelUrl;

  // WebView controller
  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    _loadArguments();
  }

  /// Load arguments passed from navigation
  void _loadArguments() {
    final args = Get.arguments as Map<String, dynamic>?;

    if (args == null) {
      AppToast.error('Invalid payment session');
      Get.back();
      return;
    }

    checkoutUrl = args['checkout_url'] as String? ?? '';
    orderReferenceId = args['order_reference_id'] as String? ?? '';
    successUrl = args['success_url'] as String? ?? '';
    cancelUrl = args['cancel_url'] as String? ?? '';

    if (checkoutUrl.isEmpty || orderReferenceId.isEmpty) {
      AppToast.error('Invalid payment data');
      Get.back();
    }
  }

  /// Handle Android back button press
  Future<bool> handleBackPress() async {
    // If payment is completed, allow exit
    if (hasCompletedPayment.value) {
      return true;
    }

    // If payment is in progress, show confirmation
    return await confirmExit();
  }

  /// Show confirmation dialog before exiting
  Future<bool> confirmExit() async {
    bool shouldExit = false;

    AppModal.confirm(
      title: "Exit Payment?",
      message:
          "You are currently processing a payment. Are you sure you want to exit?",
      confirmText: "Yes, Exit",
      cancelText: "Stay",
      onConfirm: () {
        shouldExit = true;
      },
      onCancel: () {
        shouldExit = false;
      },
    );

    // Wait a bit for the modal to be dismissed
    await Future.delayed(const Duration(milliseconds: 100));
    return shouldExit;
  }

  /// WebView started loading
  void onWebViewStart(InAppWebViewController controller, WebUri? url) {
    webViewController = controller;
    isLoading.value = true;

    if (url != null) {
      _checkRedirect(url.toString());
    }
  }

  /// WebView finished loading
  void onWebViewStop(InAppWebViewController controller, WebUri? url) {
    isLoading.value = false;

    if (url != null) {
      _checkRedirect(url.toString());
    }
  }

  /// WebView encountered an error
  void onWebViewError(
    InAppWebViewController controller,
    Uri? url,
    int code,
    String message,
  ) {
    isLoading.value = false;
    AppToast.error('Page load error: $message');
  }

  /// WebView HTTP error
  void onHttpError(
    InAppWebViewController controller,
    Uri? url,
    int statusCode,
    String description,
  ) {
    isLoading.value = false;
    AppToast.error('HTTP error: $statusCode');
  }

  /// Check if current URL is a redirect (success/cancel)
  void _checkRedirect(String url) {
    print('🌐 WebView URL: $url');

    if (url.contains('/mobile/payment/success')) {
      _handleSuccessRedirect(url);
    } else if (url.contains('/mobile/payment/cancel')) {
      _handleCancelRedirect(url);
    }
  }

  /// Handle success redirect
  Future<void> _handleSuccessRedirect(String url) async {
    // Prevent multiple calls
    if (isVerifyingPayment.value || hasCompletedPayment.value) {
      return;
    }

    isVerifyingPayment.value = true;

    // Extract order reference from URL
    final uri = Uri.parse(url);
    final ref = uri.queryParameters['ref'] ?? orderReferenceId;

    print('✅ Payment success detected. Verifying order: $ref');

    // Show loading modal
    AppModal.loading(title: 'Verifying payment...');

    // Wait a moment for backend webhook to process
    await Future.delayed(const Duration(seconds: 2));

    // Fetch order status
    final result = await _paymentRepo.fetchOrderStatus(ref);

    result.fold(
      (failure) {
        AppModal.close();
        isVerifyingPayment.value = false;

        AppModal.error(
          title: 'Verification Failed',
          message:
              'Unable to verify payment status. Please check your orders.\n\n${failure.message}',
          onConfirm: () {
            _closeAndNavigate();
          },
        );
      },
      (orderStatus) {
        AppModal.close();
        isVerifyingPayment.value = false;

        if (orderStatus.isPaid) {
          hasCompletedPayment.value = true;

          AppModal.success(
            title: 'Payment Successful!',
            message:
                'Your order ${orderStatus.orderReferenceId} has been confirmed.',
            onConfirm: () {
              _closeAndNavigate();
            },
          );
        } else {
          AppModal.error(
            title: 'Payment Pending',
            message:
                'Your payment is being processed. Please check your orders later.\n\nOrder: ${orderStatus.orderReferenceId}',
            onConfirm: () {
              _closeAndNavigate();
            },
          );
        }
      },
    );
  }

  /// Handle cancel redirect
  void _handleCancelRedirect(String url) {
    print('❌ Payment cancelled detected');

    AppModal.confirm(
      title: 'Payment Cancelled',
      message: 'Your payment was cancelled. Would you like to try again?',
      confirmText: 'Try Again',
      cancelText: 'Close',
      onConfirm: () {
        // Reload checkout URL
        webViewController?.loadUrl(
          urlRequest: URLRequest(url: WebUri(checkoutUrl)),
        );
      },
      onCancel: () {
        Get.back(); // Close WebView
      },
    );
  }

  /// Close WebView and navigate to home
  void _closeAndNavigate() {
    // Refresh order preparation if controller exists
    try {
      if (Get.isRegistered<OrderPreparationController>()) {
        final opController = Get.find<OrderPreparationController>();
        // opController.fetchOrderPreparation();
      }
    } catch (e) {
      print('⚠️ OrderPreparationController not found: $e');
    }

    // Navigate to home and clear stack
    Get.offAllNamed(Routes.homePage);
  }

  /// Manually close WebView
  void closeWebView() {
    Get.back();
  }
}