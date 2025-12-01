import 'package:custom_mp_app/app/data/models/onboarding/boarding.dart';
import 'package:flutter/material.dart';

class BoardContent extends StatelessWidget {
  final Boarding boarding;

  const BoardContent({
    Key? key,
    required this.boarding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(boarding.image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
