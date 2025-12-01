import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/modules/home/views/product_page.dart';
import 'package:custom_mp_app/app/modules/myprofile/views/my_profile_page.dart';
import 'package:custom_mp_app/app/modules/notifications/views/notifications_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart' as hero;

import 'package:custom_mp_app/app/modules/home/controllers/home_controller.dart';
import 'my_order_page.dart';


class HomePage extends GetView<HomeController> {
   HomePage({super.key});

  final List<Widget> _pages = const [
    ProductPage(),
    MyOrderPage(),
    NotificationsPage(),
    MyProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() => _pages[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            elevation: 0,
            backgroundColor: AppColors.brandDark,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withValues(alpha: 0.7),
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 12,
            currentIndex: controller.selectedIndex.value,
            onTap: controller.onItemTapped,
            items: const [
              BottomNavigationBarItem(
                activeIcon: hero.HeroIcon(hero.HeroIcons.home, style: hero.HeroIconStyle.solid, size: 24),
                icon: hero.HeroIcon(hero.HeroIcons.home, style: hero.HeroIconStyle.outline, size: 24),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                activeIcon: hero.HeroIcon(hero.HeroIcons.shoppingBag, style: hero.HeroIconStyle.solid, size: 24),
                icon: hero.HeroIcon(hero.HeroIcons.shoppingBag, style: hero.HeroIconStyle.outline, size: 24),
                label: 'Orders',
              ),
              BottomNavigationBarItem(
                activeIcon: hero.HeroIcon(hero.HeroIcons.bell, style: hero.HeroIconStyle.solid, size: 24),
                icon: hero.HeroIcon(hero.HeroIcons.bell, style: hero.HeroIconStyle.outline, size: 24),
                label: 'Notifications',
              ),
              BottomNavigationBarItem(
                activeIcon: hero.HeroIcon(hero.HeroIcons.user, style: hero.HeroIconStyle.solid, size: 24),
                icon: hero.HeroIcon(hero.HeroIcons.user, style: hero.HeroIconStyle.outline, size: 24),
                label: 'My Profile',
              ),
            ],
          )),
    );
  }
}
