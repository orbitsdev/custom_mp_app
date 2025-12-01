import 'package:custom_mp_app/app/core/plugins/storage/storage_service.dart';
import 'package:custom_mp_app/app/data/models/onboarding/boarding.dart';
import 'package:custom_mp_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  static OnboardingController get instance => Get.find();

  final PageController pageController = PageController();
  final isLastPage = false.obs;
  final currentPage = 0.obs;

  final List<Boarding> boardingPages = boarding_data;

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onPageChanged(int index) {
    currentPage.value = index;
    isLastPage.value = index == boardingPages.length - 1;
  }

  void nextPage() {
    if (!isLastPage.value) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeIn,
      );
    } else {
      completeOnboarding();
    }
  }

  void skipToLast() {
    pageController.animateToPage(
      boardingPages.length - 1,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeIn,
    );
  }

  Future<void> completeOnboarding() async {
    // Save onboarding flag
    await StorageService.setOnboardingSeen();
    print('✅ Onboarding completed - flag saved');

    // Check if user is authenticated
    final authController = AuthController.instance;

    if (authController.isAuthenticated.value) {
      print('🏠 User authenticated → navigating to home');
      Get.offAllNamed('/home');
    } else {
      print('🔐 User not authenticated → navigating to login');
      Get.offAllNamed('/login');
    }
  }
}
