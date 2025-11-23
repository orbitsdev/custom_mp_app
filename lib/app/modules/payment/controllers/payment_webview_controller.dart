import 'package:custom_mp_app/app/core/routes/routes.dart';
import 'package:custom_mp_app/app/data/repositories/payment_repository.dart';
import 'package:custom_mp_app/app/global/widgets/modals/app_modal.dart';
import 'package:custom_mp_app/app/global/widgets/toasts/app_toast.dart';
import 'package:custom_mp_app/app/modules/cart/controllers/cart_controller.dart';
import 'package:custom_mp_app/app/modules/orderpreparation/controllers/order_preparation_controller.dart';
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
  Future<void> _handleSuccess(String url) async {
    print('🎉 [SUCCESS] Payment success URL hit: $url');

    if (isVerifyingPayment.value || hasCompletedPayment.value) {
      print('⚠️ [SUCCESS] Already verifying or completed, skipping...');
      return;
    }

    print('🔄 [SUCCESS] Starting payment verification...');
    isVerifyingPayment.value = true;
    hasCompletedPayment.value = true;

    // Verify payment in background without showing modal
    print('📡 [SUCCESS] Fetching order status for: $orderReferenceId');
    final result = await _paymentRepo.fetchOrderStatus(orderReferenceId);

    result.fold(
      (failure) {
        print('❌ [SUCCESS] Verification failed: ${failure.message}');
        isVerifyingPayment.value = false;

        AppModal.error(
          title: "Verification Failed",
          message: "Unable to confirm payment.\n${failure.message}",
          onConfirm: () => _finishPayment(),
        );
      },
      (status) {
        print('✅ [SUCCESS] Order status received: isPaid=${status.isPaid}');
        isVerifyingPayment.value = false;

        if (status.isPaid) {
          print('💰 [SUCCESS] Payment confirmed! Order: ${status.orderReferenceId}');

          AppModal.success(
            title: "Payment Successful!",
            message: "Order ${status.orderReferenceId} confirmed.",
            onConfirm: () => _finishPayment(),
          );
        } else {
          print('⏳ [SUCCESS] Payment still pending...');
          AppModal.error(
            title: "Payment Pending",
            message: "Your payment is still processing.",
            onConfirm: () => _finishPayment(),
          );
        }
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
  //  AFTER VERIFICATION → CLEANUP + NAVIGATION
  // ---------------------------------------------------------
  void _finishPayment() {
    print('🧹 [CLEANUP] Starting cleanup after payment...');

    // 1. Refresh cart to remove checked-out items
    if (Get.isRegistered<CartController>()) {
      print('🛒 [CLEANUP] Refreshing cart...');
      final cart = Get.find<CartController>();
      cart.fetchCart();
    }

    // 2. Refresh order preparation
    if (Get.isRegistered<OrderPreparationController>()) {
      print('📦 [CLEANUP] Refreshing order preparation...');
      final op = Get.find<OrderPreparationController>();
      op.fetchOrderPreparation();
    }

    // 3. Navigate to order page and remove payment, order-preparation, cart from stack
    // Stack before: home -> cart -> order-preparation -> payment
    // Stack after:  home -> order page
    print('📄 [CLEANUP] Redirecting to order page...');
    Get.offNamedUntil(
      Routes.orderPage,
      (route) => route.settings.name == Routes.homePage,
    );
  }

   void closeWebView() {
    if (Get.isOverlaysOpen) {
      Get.back(); // just in case
    } else if (Get.currentRoute != '/') {
      Get.back();
    }
  }


}
