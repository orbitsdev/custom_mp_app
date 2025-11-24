import 'package:custom_mp_app/app/modules/payment/controllers/payment_webview_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PaymentWebviewController>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await controller.handleBackPress();
        if (shouldPop && context.mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Payment"),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              final shouldExit = await controller.handleBackPress();
              if (shouldExit) controller.closeWebView();
            },
          ),
        ),

        // ----------------------------------------------------------
        // WEBVIEW + LOADING OVERLAY
        // ----------------------------------------------------------
        body: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(controller.checkoutUrl),
              ),
              onWebViewCreated: controller.onWebViewCreated,
              onLoadStart: controller.onLoadStart,
              onLoadStop: controller.onLoadStop,
              onReceivedError: (webCtrl, request, error) {
                controller.onWebError(
                  webCtrl,
                  request.url,
                  error.type.toNativeValue() ?? -1,
                  error.description,
                );
              },
            
             
              shouldInterceptRequest: (webViewController, request) async {
              // print("Request URL: ${request.url}"); // Debugging request
                return null;
              },
              onLoadResource: (webViewController, resource) async {
                //print("Resource URL: ${resource.url}"); // Debugging resource
              },
              onReceivedHttpError: (webCtrl, request, response) {
                controller.onHttpError(
                  webCtrl,
                  request.url,
                  
                  response.statusCode ?? 0,
                  response.reasonPhrase ?? "HTTP Error",
                );
              },

              onReceivedServerTrustAuthRequest: (controller, challenge) async {
                // Allow SSL for DEV
                return ServerTrustAuthResponse(
                  action: ServerTrustAuthResponseAction.PROCEED,
                );
              },
            ),

            // ----------------------------------------------------------
            // LOADING INDICATOR
            // ----------------------------------------------------------
            Obx(() {
              return controller.isLoading.value
                  ? Container(
                      color: Colors.black.withOpacity(0.05),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : const SizedBox.shrink();
            })
          ],
        ),
      ),
    );
  }
}
