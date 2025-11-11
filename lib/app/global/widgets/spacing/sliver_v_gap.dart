// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SliverVGap extends StatelessWidget {

 double value;
  SliverVGap(this.value) ;
  
  @override
  Widget build(BuildContext context){
    return SliverToBoxAdapter(child: SizedBox(height: value,));
  }
}
