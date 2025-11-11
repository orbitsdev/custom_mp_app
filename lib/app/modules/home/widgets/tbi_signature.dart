import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TbiSignature extends StatelessWidget {
  const TbiSignature({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'DOST-SKSU STEP APP TBI Assisted Project',
            style: Get.textTheme.bodySmall?.copyWith(
              color: Colors.grey[700], // Slightly darker for better readability
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4), // Slight spacing between the lines
          Text(
            'COSTOMP © 2024',
            style: Get.textTheme.bodySmall?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
