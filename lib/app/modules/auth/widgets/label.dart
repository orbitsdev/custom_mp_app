import 'package:custom_mp_app/app/core/theme/config.dart';
import 'package:flutter/material.dart';

class Label extends StatelessWidget {

  final String text;
  const Label({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
      return Text(text, style: TextStyle(color: AppColors.textLight),);
  }
}
