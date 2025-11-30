import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:video_player/video_player.dart';

/// Reusable video player controls widget
class VideoPlayerControls extends StatelessWidget {
  final VideoPlayerController controller;
  final VoidCallback? onClose;

  const VideoPlayerControls({
    Key? key,
    required this.controller,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black.withOpacity(0.7), Colors.transparent],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Time indicators
          ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, VideoPlayerValue value, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(value.position),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      _formatDuration(value.duration),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 4),

          // Progress indicator
          VideoProgressIndicator(
            controller,
            allowScrubbing: true,
            colors: const VideoProgressColors(
              playedColor: AppColors.brand,
              backgroundColor: Colors.grey,
              bufferedColor: Colors.white70,
            ),
          ),

          const SizedBox(height: 8),

          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(
                  FluentIcons.rewind_24_regular,
                  color: Colors.white,
                ),
                onPressed: _skipBackward,
              ),
              ValueListenableBuilder(
                valueListenable: controller,
                builder: (context, VideoPlayerValue value, child) {
                  return IconButton(
                    icon: Icon(
                      value.isPlaying
                          ? FluentIcons.pause_24_filled
                          : FluentIcons.play_24_filled,
                      color: Colors.white,
                      size: 32,
                    ),
                    onPressed: _togglePlayPause,
                  );
                },
              ),
              IconButton(
                icon: const Icon(
                  FluentIcons.fast_forward_24_regular,
                  color: Colors.white,
                ),
                onPressed: _skipForward,
              ),
            ],
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  void _togglePlayPause() {
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }
  }

  void _skipForward() {
    final currentPosition = controller.value.position;
    final newPosition = currentPosition + const Duration(seconds: 10);
    final maxDuration = controller.value.duration;

    if (newPosition < maxDuration) {
      controller.seekTo(newPosition);
    } else {
      controller.seekTo(maxDuration);
    }
  }

  void _skipBackward() {
    final currentPosition = controller.value.position;
    final newPosition = currentPosition - const Duration(seconds: 10);

    if (newPosition > Duration.zero) {
      controller.seekTo(newPosition);
    } else {
      controller.seekTo(Duration.zero);
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
