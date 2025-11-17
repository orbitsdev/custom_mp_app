import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/global/widgets/image/online_image.dart';
import 'package:custom_mp_app/app/global/widgets/progress/shimmer_widget.dart';
import 'package:custom_mp_app/app/global/widgets/spacing/to_sliver.dart';
import 'package:custom_mp_app/app/modules/products/controllers/select_product_controller.dart';

class DetailsGallery extends StatelessWidget {
  const DetailsGallery({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SelectProductController>();

    return ToSliver(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Obx(() {
          // --- 👀 Shimmer while loading ---
          if (controller.isLoading.value) {
            return SizedBox(
              height: 70,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, __) => ShimmerWidget(
                  width: Get.size.width / 4.5,
                  height: 70,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }

          // ---  No gallery ---
          if (controller.fullGallery.isEmpty) {
            return const SizedBox.shrink();
          }

          // ---  Real images ---
          return SizedBox(
            height: 70,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: controller.fullGallery.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final img = controller.fullGallery[index];
                final isSelected = controller.selectedImage.value == img;

                return GestureDetector(
                  onTap: () => controller.selectImage(img),
                  child: Container(
                    width: Get.size.width / 4.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? AppColors.brand : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: OnlineImage(imageUrl: img),
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
