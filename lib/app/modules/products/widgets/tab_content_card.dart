import 'package:custom_mp_app/app/global/widgets/progress/content_loader.dart';
import 'package:custom_mp_app/app/global/widgets/spacing/to_sliver.dart';
import 'package:flutter/material.dart';

class TabContentCard extends StatelessWidget {
  final Widget child;
  final bool? isLoading;

  const TabContentCard({
    Key? key,
    required this.child,
    this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading == true) {
      return const ToSliver(child: ContentLoader());
    }

    // add bottom padding to avoid overlap with BottomSheet
    final bottomPadding =
        MediaQuery.of(context).viewInsets.bottom + 80; // ~Add to Cart height

    return ToSliver(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: child,
        ),
      ),
    );
  }
}
