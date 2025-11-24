import 'package:custom_mp_app/app/global/widgets/progress/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';

class OrderLoadingCard extends StatelessWidget {
  final int itemCount;

  const OrderLoadingCard({
    Key? key,
    this.itemCount = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(12.0),
      sliver: SliverMasonryGrid.count(
        childCount: itemCount,
        crossAxisCount: 1,
        mainAxisSpacing: 12,
        crossAxisSpacing: 0,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: Order ID + Status Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       ShimmerWidget(width: 150, height: 16),
                      const Gap(8),
                      ShimmerWidget(
                        width: 80,
                        height: 24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ],
                  ),
                  const Gap(12),

                  // Date info row
                  Row(
                    children: [
                      ShimmerWidget(
                        width: 16,
                        height: 16,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      const Gap(8),
                       ShimmerWidget(width: 120, height: 13),
                    ],
                  ),
                  const Gap(6),

                  // Items count row
                  Row(
                    children: [
                      ShimmerWidget(
                        width: 16,
                        height: 16,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      const Gap(8),
                       ShimmerWidget(width: 80, height: 13),
                    ],
                  ),
                  const Gap(6),

                  // Address/Pickup row
                  Row(
                    children: [
                      ShimmerWidget(
                        width: 16,
                        height: 16,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      const Gap(8),
                       Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerWidget(width: 100, height: 13),
                            Gap(4),
                            Padding(
                              padding: EdgeInsets.only(left: 0),
                              child: ShimmerWidget(width: 200, height: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(12),

                  // Payment info row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Payment status badge
                      ShimmerWidget(
                        width: 70,
                        height: 28,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      // Total price
                       ShimmerWidget(width: 80, height: 18),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
