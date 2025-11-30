import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/data/models/reviews/review_model.dart';
import 'package:custom_mp_app/app/global/widgets/video/media_viewer_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class ReviewCardWidget extends StatelessWidget {
  final ReviewModel review;

  const ReviewCardWidget({
    Key? key,
    required this.review,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // User info & rating
          _buildUserHeader(),

          const SizedBox(height: 8),

          // Comment
          if (review.hasComment) ...[
            Text(
              review.comment!,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: AppColors.textDark,
                height: 1.4,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
          ],

          // Media attachments
          if (review.hasAttachments) ...[
            const SizedBox(height: 8),
            _buildAttachments(),
            const SizedBox(height: 8),
          ],

          // Date
          Text(
            _formatDate(review.createdAt),
            style: Get.textTheme.bodySmall?.copyWith(
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserHeader() {
    return Row(
      children: [
        // Avatar
        CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.brand.withOpacity(0.1),
          backgroundImage: review.user.avatarUrl != null
              ? CachedNetworkImageProvider(review.user.avatarUrl!)
              : null,
          child: review.user.avatarUrl == null
              ? Text(
                  review.user.name[0].toUpperCase(),
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: AppColors.brand,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),

        const SizedBox(width: 8),

        // Name & rating
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                review.user.name,
                style: Get.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              _buildStars(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStars() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < review.rating
              ? FluentIcons.star_24_filled
              : FluentIcons.star_24_regular,
          color: AppColors.gold,
          size: 12,
        );
      }),
    );
  }

  Widget _buildAttachments() {
    return MasonryGridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 6,
      crossAxisSpacing: 6,
      itemCount: review.attachments.length,
      itemBuilder: (context, index) {
        final attachment = review.attachments[index];

        return GestureDetector(
          onTap: () {
            // Open fullscreen media viewer with PageView
            Get.to(
              () => MediaViewerWidget(
                mediaFiles: review.attachments,
                initialIndex: index,
              ),
              transition: Transition.fadeIn,
              duration: const Duration(milliseconds: 200),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 85,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Image/Video thumbnail
                  CachedNetworkImage(
                    imageUrl: attachment.url,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey.shade100,
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.brand,
                            ),
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: Colors.grey.shade100,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              attachment.isVideo
                                  ? FluentIcons.video_24_regular
                                  : FluentIcons.image_24_regular,
                              color: Colors.grey.shade400,
                              size: 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              attachment.isVideo ? 'Video' : 'Image',
                              style: Get.textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade500,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Gradient overlay (stronger for videos)
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(
                            attachment.isVideo ? 0.4 : 0.15,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Play icon for videos
                  if (attachment.isVideo)
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.brand,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          FluentIcons.play_24_filled,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return timeago.format(date, locale: 'en_short');
    } catch (e) {
      return dateString;
    }
  }
}
