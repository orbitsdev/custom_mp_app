  // ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class MarkdownViewer extends StatelessWidget {
    final String? content;
  const MarkdownViewer({
    Key? key,
    this.content,
  }) : super(key: key);
  
    
    @override
    Widget build(BuildContext context) {
      return Html(
      data: content,
      style: {
       "h1": Style(
         
          fontSize: FontSize.xxLarge, // Adjust font size as needed
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),

        "h2": Style(
           
          fontSize: FontSize.xLarge,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),

        "h3": Style(
           
          fontSize: FontSize.large,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
        "p": Style(
          padding: HtmlPaddings.all(0),
          fontSize: FontSize.medium, // Adjust font size as needed
          color: AppColors.textDark,
        ),

        "strong": Style(
          padding: HtmlPaddings.all(0),
          fontSize: FontSize.medium,
          color: AppColors.textDark,
        ),

        "ul li": Style(
          fontSize: FontSize.medium, // Adjust font size as needed
        ),

        "figcaption": Style(
          display: Display.none,
        ),

        "img": Style(
          margin: Margins.all(0),
          width: Width(100), // Adjust width to fit the screen
          height: Height.auto(), // Adjust height to maintain aspect ratio
          display: Display.block,
          textAlign: TextAlign.center,
        ),

        "pre": Style(
          border: Border.all(color: Colors.white),
          padding: HtmlPaddings.all(0),
          backgroundColor: Color(0xff0d121b),
        ),
      },
    );
    }
  }
