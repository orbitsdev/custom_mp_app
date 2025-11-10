import 'package:custom_mp_app/app/global/widgets/lottie/app_lottie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:custom_mp_app/app/core/theme/app_colors.dart';

// Global Widgets
import 'package:custom_mp_app/app/global/widgets/modals/app_modal.dart';
import 'package:custom_mp_app/app/global/widgets/toasts/app_toast.dart';
import 'package:custom_mp_app/app/global/widgets/pages/app_status_page.dart';


class ModalPage extends StatelessWidget {
  const ModalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<_DemoItem> demos = [
      // 🔹 MODALS
      _DemoItem(
        group: 'MODALS',
        title: '✅ Success Modal',
        color: AppColors.green,
        onTap: () => AppModal.success(
          title: 'Success!',
          message: 'Your action was completed successfully.',
        ),
      ),
      _DemoItem(
        group: 'MODALS',
        title: '❌ Error Modal',
        color: AppColors.error,
        onTap: () => AppModal.error(
          title: 'Error',
          message: 'Something went wrong. Please try again.',
        ),
      ),
      _DemoItem(
        group: 'MODALS',
        title: '⚠️ Confirmation Modal',
        color: AppColors.amber,
        onTap: () => AppModal.confirm(
          title: 'Are you sure?',
          message: 'Do you really want to proceed?',
          onConfirm: () => AppModal.success(message: 'Confirmed!'),
        ),
      ),
      _DemoItem(
        group: 'MODALS',
        title: '⏳ Loading Modal (2s)',
        color: AppColors.indigo,
        onTap: () async {
          AppModal.loading(title: 'Loading, please wait...');
          await Future.delayed(const Duration(seconds: 2));
          AppModal.close();
          AppModal.success(message: 'Loading finished!');
        },
      ),

      // 🔹 TOASTS
      _DemoItem(
        group: 'TOASTS',
        title: '🍞 Success Toast',
        color: AppColors.green,
        onTap: () => AppToast.success("Profile saved successfully!"),
      ),
      _DemoItem(
        group: 'TOASTS',
        title: '🍞 Error Toast',
        color: AppColors.error,
        onTap: () => AppToast.error("Invalid password!"),
      ),
    
      _DemoItem(
        group: 'TOASTS',
        title: 'ℹ️ Info Toast',
        color: AppColors.indigo,
        onTap: () => AppToast.info("Syncing data with the server..."),
      ),

      // 🔹 STATUS PAGES
      _DemoItem(
        group: 'STATUS PAGES',
        title: '📶 No Internet',
        color: AppColors.amber,
        onTap: () => Get.to(() => AppStatusPage(
          title: "No Internet Connection",
          message: "Please check your Wi-Fi or mobile data and try again.",
          lottieAsset: AppLotties.error,
          onRetry: () => Get.back(),
        )),
      ),
      _DemoItem(
        group: 'STATUS PAGES',
        title: '🔒 Session Expired',
        color: AppColors.error,
        onTap: () => Get.to(() => AppStatusPage(
          title: "Session Expired",
          message: "Your session has expired. Please log in again.",
          lottieAsset: AppLotties.confirm,
          onRetry: () {
            Get.back(); // Normally you'd navigate to login
            AppModal.loading(title: 'Logging out...');
            Future.delayed(const Duration(seconds: 2), () {
              AppModal.close();
              AppModal.success(message: 'Redirected to login!');
            });
          },
        )),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback System Showcase'),
        backgroundColor: AppColors.brand,
        centerTitle: true,
      ),
      backgroundColor: AppColors.brandBackground,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionTitle('🪟 MODALS'),
          ..._buildDemoSection(demos.where((d) => d.group == 'MODALS')),
          const SizedBox(height: 16),
          _buildSectionTitle('🍞 TOASTS'),
          ..._buildDemoSection(demos.where((d) => d.group == 'TOASTS')),
          const SizedBox(height: 16),
          _buildSectionTitle('📄 STATUS PAGES'),
          ..._buildDemoSection(demos.where((d) => d.group == 'STATUS PAGES')),
        ],
      ),
    );
  }

  // Build section header
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(
        title,
        style: Get.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
    );
  }

  // Build demo list
  List<Widget> _buildDemoSection(Iterable<_DemoItem> items) {
    return items
        .map(
          (demo) => Card(
            color: Colors.white,
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              title: Text(
                demo.title,
                style: Get.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: demo.color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 10),
                ),
                onPressed: demo.onTap,
                child: const Text(
                  "Show",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        )
        .toList();
  }
}

class _DemoItem {
  final String group; // MODALS / TOASTS / STATUS PAGES
  final String title;
  final Color color;
  final VoidCallback onTap;
  _DemoItem({
    required this.group,
    required this.title,
    required this.color,
    required this.onTap,
  });
}
