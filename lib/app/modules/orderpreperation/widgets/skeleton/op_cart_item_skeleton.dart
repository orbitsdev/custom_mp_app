
import 'package:custom_mp_app/app/global/widgets/progress/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';

class OpCartItemSkeleton extends StatelessWidget {
  const OpCartItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [
        /// HEADER SKELETON
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                ShimmerWidget(width: 120, height: 20),
                ShimmerWidget(width: 60, height: 16),
              ],
            ),
          ),
        ),

        /// ITEM SKELETON LIST
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children:  [
                    /// IMAGE
                    ShimmerWidget(width: 80, height: 80),

                    SizedBox(width: 12),

                    /// TEXT BLOCK
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerWidget(width: 150, height: 16),
                          SizedBox(height: 6),
                          ShimmerWidget(width: 120, height: 14),
                          SizedBox(height: 6),
                          ShimmerWidget(width: 80, height: 14),
                          SizedBox(height: 6),
                          ShimmerWidget(width: 60, height: 14),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            childCount: 3, // show 3 skeleton rows
          ),
        ),
      ],
    );
  }
}
