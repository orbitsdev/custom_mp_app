
import 'package:custom_mp_app/app/core/theme/custom_style.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Logo extends StatelessWidget {
const Logo({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        Image.asset('assets/images/logo.png',
        height: 80,
        width: 80,
        ),

        const Gap(10),
        RichText(
        text: TextSpan(
            text:  'Avante'.toUpperCase(),
            style: LogoStyle.avante,
            children: <TextSpan>[

                TextSpan(text: ' FOODS', style: LogoStyle.app),
               
            
            ]
        ),
      ),

        RichText(
        text: TextSpan(
        
            children: <TextSpan>[

             TextSpan(text: ' Fruit', style: LogoStyle.normalText),
                TextSpan(text: ' QUALITY', style: LogoStyle.redText),
                TextSpan(text: ' we commit at its', style: LogoStyle.normalText),
                TextSpan(text: ' BEST', style: LogoStyle.redText),
               
            
            ]
        ),
      ),
     
      ],
    );
  }
}