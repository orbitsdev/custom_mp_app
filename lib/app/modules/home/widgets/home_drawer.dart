
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/core/utils/path_helpers.dart';
import 'package:custom_mp_app/app/global/widgets/image/local_image.dart';
import 'package:custom_mp_app/app/global/widgets/modals/app_modal.dart';
import 'package:custom_mp_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:custom_mp_app/app/modules/home/widgets/tbi_signature.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Container(
        color: Colors.white, // Background color for the drawer
        child: Column(
          children: [
            // App Logo and Name
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orangeAccent, // Matches your app's color scheme
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Logo
                    // Icon(
                    //   Icons.shopping_cart, // Replace with your actual app logo image
                    //   size: 50,
                    //   color: Colors.white,
                    // ),
                    Container(
                      width: 90,
                      height: 90,
                      child: LocalImage(imageUrl: PathHelpers.imagePath('logo.png'))),
                    SizedBox(height: 8),
                    // App Name
                    Text(
                      'Avante Foods ',
                      style: Get.textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            // Drawer Content
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    Icons.star,
                    'Featured',
                    () {
                     
                        // Get.to(()=> FeaturedProductsScreen(), transition: Transition.cupertino);
                    },
                  ),
                  _buildDrawerItem(
                    Icons.trending_up,
                    'Trending',
                    () {
                     
                        // Get.to(()=> TrendingProductScreen(), transition: Transition.cupertino);
                    },
                  ),
                  _buildDrawerItem(
                    Icons.local_fire_department,
                    'Best-Seller',
                    () {
                   
                        // Get.to(()=> BestSellerProductScreen(), transition: Transition.cupertino);
                    },
                  ),
                  _buildDrawerItem(
                    Icons.new_releases,
                    'New Arrivals',
                    () {
                    
                        // Get.to(()=> NewProductScreen(), transition: Transition.cupertino);
                    },
                  ),
                  Divider(color: AppColors.brandBackground),
                ],
              ),
            ),

            // Logout Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text(
                  'Logout',
                  style: Get.textTheme.bodyLarge?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () => _handleLogout(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.red.withOpacity(0.3)),
                ),
              ),
            ),

            TbiSignature(),
          ],
        ),
      ),
    );
  }

  // Handle logout with confirmation
  Future<void> _handleLogout(BuildContext context) async {
    Get.back(); // Close drawer first

    final shouldLogout = await AppModal.confirm(
      title: 'Logout',
      message: 'Are you sure you want to logout?',
      confirmText: 'Logout',
      cancelText: 'Cancel',
    );

    if (shouldLogout == true) {
      final authController = Get.find<AuthController>();
      await authController.logout();
    }
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.orangeAccent),
      title: Text(
        title,
        style: Get.textTheme.bodyLarge?.copyWith(color: Colors.black87),
      ),
      onTap: onTap,
    );
  }

  void _logDrawerItemTap(String itemName) {
    // Analytics.logEvent(
    //   name: 'drawer_item_tap',
    //   parameters: {
    //     'item_name': itemName,
    //   },
    // );

    // // Optionally log user activity for further tracking
    // Analytics.logUserActivity(
    //   activity: 'User tapped on $itemName in drawer',
    // );
  }
}
