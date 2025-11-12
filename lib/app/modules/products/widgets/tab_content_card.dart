import 'package:custom_mp_app/app/global/widgets/progress/content_loader.dart';
import 'package:custom_mp_app/app/global/widgets/spacing/to_sliver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabContentCard extends StatelessWidget {
  Widget child;
  bool? isLoading;
  TabContentCard({Key? key, required this.child, this.isLoading})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (isLoading == true)
        ? ToSliver(child: ContentLoader())
        : ToSliver(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: child,
            ),
          );
  }
}
