import 'package:custom_mp_app/app/core/routes/routes.dart';
import 'package:custom_mp_app/app/data/repositories/payment_repository.dart';
import 'package:custom_mp_app/app/global/widgets/modals/app_modal.dart';
import 'package:custom_mp_app/app/global/widgets/toasts/app_toast.dart';
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
    final args = Get.arguments;

    if (args == null) {
      AppToast.error("Invalid payment arguments");
      Get.back();
      return;
    }

    checkoutUrl       = args['checkout_url'] ?? '';
    orderReferenceId  = args['order_reference_id'] ?? '';
    successUrl        = args['success_url'] ?? '';
    cancelUrl         = args['cancel_url'] ?? '';

    if (checkoutUrl.isEmpty || orderReferenceId.isEmpty) {
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
    bool shouldExit = false;

    AppModal.confirm(
      title: "Exit Payment?",
      message: "Payment is still in progress. Do you want to exit?",
      confirmText: "Exit",
      cancelText: "Stay",
      onConfirm: () => shouldExit = true,
    );

    await Future.delayed(const Duration(milliseconds: 200));
    return shouldExit;
  }

  // ---------------------------------------------------------
  //  WEBVIEW EVENTS
  // ---------------------------------------------------------
  void onLoadStart(InAppWebViewController controller, WebUri? url) {
    webView = controller;
    isLoading.value = true;

    if (url != null) {
      _detectRedirect(url.toString());
    }
  }

  void onLoadStop(InAppWebViewController controller, WebUri? url) {
    isLoading.value = false;

    if (url != null) {
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
    if (url.contains("/mobile/payment/success")) {
      _handleSuccess(url);
    } else if (url.contains("/mobile/payment/cancel")) {
      _handleCancel();
    }
  }

  // ---------------------------------------------------------
  //  PAYMENT SUCCESS FLOW
  // ---------------------------------------------------------
  Future<void> _handleSuccess(String url) async {
    if (isVerifyingPayment.value || hasCompletedPayment.value) return;

    isVerifyingPayment.value = true;

    AppModal.loading(title: "Verifying payment...");

    await Future.delayed(const Duration(seconds: 2));

    final result = await _paymentRepo.fetchOrderStatus(orderReferenceId);

    result.fold(
      (failure) {
        AppModal.close();
        isVerifyingPayment.value = false;

        AppModal.error(
          title: "Verification Failed",
          message: "Unable to confirm payment.\n${failure.message}",
          onConfirm: () => _finishPayment(),
        );
      },
      (status) {
        AppModal.close();
        isVerifyingPayment.value = false;

        if (status.isPaid) {
          hasCompletedPayment.value = true;

          AppModal.success(
            title: "Payment Successful!",
            message: "Order ${status.orderReferenceId} confirmed.",
            onConfirm: () => _finishPayment(),
          );
        } else {
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
    if (Get.isRegistered<OrderPreparationController>()) {
      final op = Get.find<OrderPreparationController>();
      op.fetchOrderPreparation();
    }

    Get.offAllNamed(Routes.homePage);
  }

   void closeWebView() {
    if (Get.isOverlaysOpen) {
      Get.back(); // just in case
    } else if (Get.currentRoute != '/') {
      Get.back();
    }
  }

  
}
