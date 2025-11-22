import 'package:custom_mp_app/app/modules/payment/controllers/payment_webview_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class PaymentWebviewPage extends StatelessWidget {
  const PaymentWebviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PaymentWebviewController>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await controller.handleBackPress();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Payment'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              final shouldClose = await controller.handleBackPress();
              if (shouldClose) {
                controller.closeWebView();
              }
            },
          ),
        ),
        body: Stack(
          children: [
            // WebView
            InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(controller.checkoutUrl),
              ),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                domStorageEnabled: true,
                databaseEnabled: true,
                useOnLoadResource: true,
                useOnDownloadStart: true,
                useShouldOverrideUrlLoading: true,
                mediaPlaybackRequiresUserGesture: false,
                allowsInlineMediaPlayback: true,
                supportZoom: false,
                userAgent: 'Mozilla/5.0 (Linux; Android 11) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36',
              ),
              onLoadStart: controller.onWebViewStart,
              onLoadStop: controller.onWebViewStop,
              onReceivedError: (webController, request, error) {
                controller.onWebViewError(
                  webController,
                  request.url,
                  error.type.toNativeValue() ?? -1,
                  error.description,
                );
              },
              onReceivedHttpError: (webController, request, response) {
                controller.onHttpError(
                  webController,
                  request.url,
                  response.statusCode ?? 0,
                  response.reasonPhrase ?? 'Unknown error',
                );
              },
              onReceivedServerTrustAuthRequest: (webController, challenge) async {
                // Allow all SSL certificates (for dev environment)
                return ServerTrustAuthResponse(
                  action: ServerTrustAuthResponseAction.PROCEED,
                );
              },
            ),

            // Loading indicator
            Obx(
              () => controller.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}