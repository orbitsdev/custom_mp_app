import 'package:custom_mp_app/app/global/widgets/progress/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';

class ProductLoadingCard extends StatelessWidget {
  final int itemCount;

  const ProductLoadingCard({
    Key? key,
    this.itemCount =
        10, // Default itemCount to 10 for better loading simulation
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAlignedGrid.count(
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      itemCount: itemCount < 10 ? itemCount : 10, // Show up to 10 loading cards
      crossAxisCount: 2,
      itemBuilder: (context, index) {
        return Container(
          constraints: BoxConstraints(minHeight: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerWidget(
                height: 170,
                width: double.infinity,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerWidget(width: 120, height: 14),
                    const Gap(8),
                    Row(
                      children: [
                        ShimmerWidget(width: Get.size.width * 0.12, height: 14),
                        const Gap(8),
                        ShimmerWidget(width: Get.size.width * 0.12, height: 14),
                      ],
                    ),
                    const Gap(8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShimmerWidget(width: Get.size.width * 0.10, height: 10),
                        ShimmerWidget(width: Get.size.width * 0.10, height: 10),
                      ],
                    ),
                    const Gap(8),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
