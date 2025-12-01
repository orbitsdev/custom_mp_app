import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/core/theme/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

class TermsOfUsePage extends StatefulWidget {
  const TermsOfUsePage({Key? key}) : super(key: key);

  @override
  State<TermsOfUsePage> createState() => _TermsOfUsePageState();
}

class _TermsOfUsePageState extends State<TermsOfUsePage> {
  InAppWebViewController? webViewController;
  bool isLoading = true;

  @override
  void dispose() {
    webViewController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandBackground,
      appBar: AppBar(
        backgroundColor: AppColors.brand,
        elevation: 0,
        leading: IconButton(
          icon: HeroIcon(HeroIcons.arrowLeft, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Terms of Use',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          // Loading indicator
          if (isLoading)
            LinearProgressIndicator(
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.brand),
            ),

          // WebView
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri.uri(Uri.parse('https://dev.avantefoods.com/terms-of-use')),
              ),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onLoadStart: (controller, url) {
                setState(() {
                  isLoading = true;
                });
              },
              onLoadStop: (controller, url) async {
                setState(() {
                  isLoading = false;
                });

                // Hide the backend's back button using JavaScript
                await controller.evaluateJavascript(source: '''
                  (function() {
                    // Hide common back button selectors
                    var backButtons = document.querySelectorAll('a[href*="back"], button[class*="back"], .back-button, [class*="Back"]');
                    backButtons.forEach(function(btn) {
                      if (btn.textContent.toLowerCase().includes('back')) {
                        btn.style.display = 'none';
                      }
                    });

                    // Also try to hide by text content
                    var allLinks = document.querySelectorAll('a');
                    allLinks.forEach(function(link) {
                      if (link.textContent.trim() === '← Back' || link.textContent.trim() === 'Back') {
                        link.style.display = 'none';
                      }
                    });
                  })();
                ''');
              },
              onLoadError: (controller, url, code, message) {
                setState(() {
                  isLoading = false;
                });
              },
              initialSettings: InAppWebViewSettings(
                useHybridComposition: true,
                javaScriptEnabled: true,
                supportZoom: false,
              ),
            ),
          ),

          // Bottom Button
          Container(
            height: 80,
                        width: Get.size.width,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () => Get.back(),
              style: ELEVATED_BUTTON_STYLE_PRIMARY,
              child: Text(
                'I Understand',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
