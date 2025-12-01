import 'package:custom_mp_app/app/modules/home/views/product_page.dart';
import 'package:custom_mp_app/app/modules/home/views/wishlist_coming_soon_page.dart';
import 'package:custom_mp_app/app/modules/myprofile/views/my_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart' as hero;

import 'package:custom_mp_app/app/modules/home/controllers/home_controller.dart';
import 'my_order_page.dart';


class HomePage extends GetView<HomeController> {
   HomePage({super.key});

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const ProductPage(),
      const MyOrderPage(),
      const WishlistComingSoonPage(),
      MyProfilePage(scaffoldKey: scaffoldKey),
    ];

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Obx(() => pages[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            elevation: 0,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFFEFAF33),
            unselectedItemColor: const Color(0xFF8B8B8B),
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 11,
            unselectedFontSize: 11,
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
                label: 'My Orders',
              ),
              BottomNavigationBarItem(
                activeIcon: hero.HeroIcon(hero.HeroIcons.heart, style: hero.HeroIconStyle.solid, size: 24),
                icon: hero.HeroIcon(hero.HeroIcons.heart, style: hero.HeroIconStyle.outline, size: 24),
                label: 'Wishlist',
              ),
              BottomNavigationBarItem(
                activeIcon: hero.HeroIcon(hero.HeroIcons.user, style: hero.HeroIconStyle.solid, size: 24),
                icon: hero.HeroIcon(hero.HeroIcons.user, style: hero.HeroIconStyle.outline, size: 24),
                label: 'Account',
              ),
            ],
          )),
    );
  }
}
