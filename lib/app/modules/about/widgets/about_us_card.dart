import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AboutUsCard extends StatelessWidget {
  final String title;
  final String content;
  const AboutUsCard({Key? key, required this.title, required this.content})
    : super(key: key);
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '${title}',
            style: textTheme.bodyLarge!.copyWith(
              color: AppColors.brand,
              fontWeight: FontWeight.w100,
            ),
          ),
          Text('${content}', style: textTheme.bodyMedium!.copyWith()),
        ],
      ),
    );
  }
}
