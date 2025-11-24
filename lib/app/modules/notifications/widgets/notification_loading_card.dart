import 'package:custom_mp_app/app/global/widgets/progress/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Notification Loading Card
///
/// Shows shimmer effect while loading notifications
class NotificationLoadingCard extends StatelessWidget {
  final int itemCount;

  const NotificationLoadingCard({
    Key? key,
    this.itemCount = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(16),
      itemCount: itemCount,
      separatorBuilder: (context, index) => Gap(12),
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon shimmer
              ShimmerWidget(
                width: 48,
                height: 48,
                borderRadius: BorderRadius.circular(10),
              ),

              Gap(12),

              // Content shimmer
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerWidget(
                      width: double.infinity,
                      height: 14,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    Gap(8),
                    ShimmerWidget(
                      width: double.infinity,
                      height: 12,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    Gap(4),
                    ShimmerWidget(
                      width: 120,
                      height: 12,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    Gap(8),
                    ShimmerWidget(
                      width: 80,
                      height: 10,
                      borderRadius: BorderRadius.circular(4),
                    ),
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
