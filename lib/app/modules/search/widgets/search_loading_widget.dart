import 'package:custom_mp_app/app/global/widgets/progress/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Search Loading Widget
///
/// Shows shimmer skeleton while loading search results
class SearchLoadingWidget extends StatelessWidget {
  final int itemCount;

  const SearchLoadingWidget({
    Key? key,
    this.itemCount = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: itemCount,
      separatorBuilder: (context, index) => Divider(height: 0.5, color: Colors.grey[200]),
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Search icon shimmer
              ShimmerWidget(
                width: 20,
                height: 20,
                borderRadius: BorderRadius.circular(4),
              ),

              Gap(12),

              // Product name shimmer
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerWidget(
                      width: double.infinity,
                      height: 14,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    Gap(6),
                    ShimmerWidget(
                      width: 150,
                      height: 14,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ),

              Gap(12),

              // Arrow icon shimmer
              ShimmerWidget(
                width: 16,
                height: 16,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        );
      },
    );
  }
}
