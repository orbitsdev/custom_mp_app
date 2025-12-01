import 'package:custom_mp_app/app/core/routes/routes.dart';
import 'package:custom_mp_app/app/data/repositories/payment_repository.dart';
import 'package:custom_mp_app/app/global/widgets/modals/app_modal.dart';
import 'package:custom_mp_app/app/global/widgets/toasts/app_toast.dart';
import 'package:custom_mp_app/app/modules/cart/controllers/cart_controller.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class PaymentWebviewController extends GetxController {
  final PaymentRepository _paymentRepo = Get.find<PaymentRepository>();

  // UI States
  final isLoading = false.obs;
  final isVerifyingPayment = false.obs;
  final hasCompletedPayment = false.obs;

  // Arguments
  late String checkoutUrl;
  late String orderReferenceId;
  late String successUrl;
  late String cancelUrl;

  InAppWebViewController? webView;

  @override
  void onInit() {
    super.onInit();
    _loadArguments();
  }

  // ---------------------------------------------------------
  //  LOAD ARGUMENTS FROM PAYMENT PAGE
  // ---------------------------------------------------------
  void _loadArguments() {
    print('🔧 [INIT] Loading payment arguments...');
    final args = Get.arguments;

    if (args == null) {
      print('❌ [INIT] No arguments provided!');
      AppToast.error("Invalid payment arguments");
      Get.back();
      return;
    }

    checkoutUrl       = args['checkout_url'] ?? '';
    orderReferenceId  = args['order_reference_id'] ?? '';
    successUrl        = args['success_url'] ?? '';
    cancelUrl         = args['cancel_url'] ?? '';

    print('📋 [INIT] Checkout URL: $checkoutUrl');
    print('📋 [INIT] Order Ref: $orderReferenceId');
    print('📋 [INIT] Success URL: $successUrl');
    print('📋 [INIT] Cancel URL: $cancelUrl');

    if (checkoutUrl.isEmpty || orderReferenceId.isEmpty) {
      print('❌ [INIT] Missing required payment details!');
      AppToast.error("Missing payment details");
      Get.back();
    }
  }

  // ---------------------------------------------------------
  //  BACK BUTTON LOGIC
  // ---------------------------------------------------------
  Future<bool> handleBackPress() async {
    if (hasCompletedPayment.value) {
      return true;
    }

    return await _confirmExit();
  }

  Future<bool> _confirmExit() async {
    final shouldExit = await AppModal.confirm(
      title: "Exit Payment?",
      message: "Payment is still in progress. Do you want to exit?",
      confirmText: "Exit",
      cancelText: "Stay",
    );

    return shouldExit ?? false;
  }

  // ---------------------------------------------------------
  //  WEBVIEW EVENTS
  // ---------------------------------------------------------
  void onWebViewCreated(InAppWebViewController controller) {
    print('🔧 [WEBVIEW] WebView created');
    webView = controller;
  }

  void onLoadStart(InAppWebViewController controller, WebUri? url) {
    webView = controller;
    isLoading.value = true;

    if (url != null) {
      print('🌐 [WEBVIEW] Loading URL: ${url.toString()}');
      _detectRedirect(url.toString());
    }
  }

  void onLoadStop(InAppWebViewController controller, WebUri? url) {
    isLoading.value = false;

    if (url != null) {
      print('✅ [WEBVIEW] Loaded URL: ${url.toString()}');
      _detectRedirect(url.toString());
    }
  }

  void onWebError(
    InAppWebViewController controller,
    Uri? url,
    int code,
    String message,
  ) {
    isLoading.value = false;
    AppToast.error("Failed to load page");
  }

  void onHttpError(
    InAppWebViewController controller,
    WebUri? url,
    int statusCode,
    String reasonPhrase,
  ) {
    isLoading.value = false;
    AppToast.error("HTTP Error: $statusCode - $reasonPhrase");
  }

  // ---------------------------------------------------------
  //  DETECT REDIRECT FOR SUCCESS / CANCEL
  // ---------------------------------------------------------
  void _detectRedirect(String url) {
    print('🔍 [DETECT] Checking URL: $url');

    // Check for success patterns
    if (url.contains("/mobile/payment/success") ||
        url.contains("/mobile-app/success") ||
        url.contains("payment/success")) {
      print('✅ [DETECT] SUCCESS URL detected!');
      _handleSuccess(url);
    }
    // Check for cancel patterns
    else if (url.contains("/mobile/payment/cancel") ||
             url.contains("/mobile-app/cancel") ||
             url.contains("payment/cancel")) {
      print('❌ [DETECT] CANCEL URL detected!');
      _handleCancel();
    }
    else {
      print('⏭️ [DETECT] Not a payment redirect URL');
    }
  }

  // ---------------------------------------------------------
  //  PAYMENT SUCCESS FLOW
  // ---------------------------------------------------------
  void _handleSuccess(String url) {
    print('🎉 [SUCCESS] Payment success URL hit: $url');

    if (hasCompletedPayment.value) {
      print('⚠️ [SUCCESS] Already completed, skipping...');
      return;
    }

    hasCompletedPayment.value = true;

    print('✅ [SUCCESS] Payment confirmed! Redirecting immediately...');

    // Refresh cart and order preparation in background
    _refreshData();

    // Navigate to success page IMMEDIATELY (no verification, no dialog)
    // After successful payment, order status is typically "processing" (To Ship tab)
    Get.offNamed(
      Routes.paymentSuccessPage,
      arguments: {
        'order_reference_id': orderReferenceId,
        'order_status': 'processing', // Default to "To Ship" tab after payment
      },
    );
  }

  // ---------------------------------------------------------
  //  PAYMENT CANCELED FLOW
  // ---------------------------------------------------------
  void _handleCancel() {
    print('🚫 [CANCEL] Payment cancelled URL detected');
    AppModal.confirm(
      title: "Payment Cancelled",
      message: "Do you want to try again?",
      confirmText: "Retry",
      cancelText: "Close",
      onConfirm: () {
        webView?.loadUrl(
          urlRequest: URLRequest(url: WebUri(checkoutUrl)),
        );
      },
      onCancel: () {
        Get.back();
      },
    );
  }

  // ---------------------------------------------------------
  //  REFRESH CART AFTER PAYMENT
  // ---------------------------------------------------------
  void _refreshData() {
    print('🔄 [REFRESH] Refreshing cart...');

    // Refresh cart to show it's empty after successful payment
    if (Get.isRegistered<CartController>()) {
      print('🛒 [REFRESH] Fetching cart...');
      final cart = Get.find<CartController>();
      cart.fetchCart();
    }

    // Note: We don't refresh order-preparation here because:
    // 1. Cart is now empty (items were checked out)
    // 2. Order-preparation page is removed from navigation stack
    // 3. API will return "Cart is empty" error if we try to fetch it
  }

   void closeWebView() {
    if (Get.isOverlaysOpen) {
      Get.back(); // just in case
    } else if (Get.currentRoute != '/') {
      Get.back();
    }
  }


}
