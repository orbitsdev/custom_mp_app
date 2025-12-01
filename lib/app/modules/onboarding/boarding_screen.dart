import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:custom_mp_app/app/modules/onboarding/widgets/board_content_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingScreen extends StatelessWidget {
  const BoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();

    return Scaffold(
      body: Stack(
        children: [
          // PageView
          PageView.builder(
            onPageChanged: controller.onPageChanged,
            physics: const ClampingScrollPhysics(),
            controller: controller.pageController,
            itemCount: controller.boardingPages.length,
            itemBuilder: (context, index) => BoardContent(
              boarding: controller.boardingPages[index],
            ),
          ),

          // Skip button (only show if not last page)
          Obx(
            () => !controller.isLastPage.value
                ? Positioned(
                    top: 40,
                    right: 20,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onPressed: controller.skipToLast,
                      child: Text(
                        'Skip'.toUpperCase(),
                        style: Get.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ).animate().scale(),
                  )
                : const SizedBox.shrink(),
          ),

          // Bottom controls (page indicator and button)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(),
              child: Container(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SmoothPageIndicator(
                      onDotClicked: (index) =>
                          controller.pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeIn,
                      ),
                      controller: controller.pageController,
                      count: controller.boardingPages.length,
                      effect: const ScrollingDotsEffect(
                        spacing: 12,
                        activeDotColor: Colors.white,
                        dotColor: Colors.white54,
                        activeDotScale: 1.5,
                        dotHeight: 14,
                        dotWidth: 14,
                      ),
                    ),
                    Gap(Get.size.height * 0.04),
                    Obx(
                      () => SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: controller.nextPage,
                          child: Text(
                            controller.isLastPage.value
                                ? 'Get Started'.toUpperCase()
                                : 'NEXT'.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                      ).animate().fadeIn(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}