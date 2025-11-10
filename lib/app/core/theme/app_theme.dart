import 'package:flutter/material.dart';
import 'app_colors.dart';

import 'package:google_fonts/google_fonts.dart';
class AppTheme {
static ThemeData AVANTE_THEME = ThemeData(
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.brand,
      
    ),
    textSelectionTheme: TextSelectionThemeData(
      selectionHandleColor: AppColors.brand,
      cursorColor:AppColors.brand,
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero
      ),
     rangeSelectionOverlayColor: WidgetStatePropertyAll(AppColors.brandDark),
      elevation: 0,
      

      ),
    textTheme: GoogleFonts.robotoTextTheme(
      
    ).copyWith(

       titleLarge:  GoogleFonts.robotoTextTheme().titleLarge!.copyWith(
        color: AppColors.textDark,
       
      ),
      titleMedium:  GoogleFonts.robotoTextTheme().titleMedium!.copyWith(
        color: AppColors.textDark,

     
      ),
      titleSmall:  GoogleFonts.robotoTextTheme().titleSmall!.copyWith(
        color: AppColors.textDark,

    

      ),
      bodyLarge:  GoogleFonts.robotoTextTheme().bodyLarge!.copyWith(
       color: AppColors.textDark,

   
      ),
      bodyMedium:  GoogleFonts.robotoTextTheme().bodyMedium!.copyWith(
                color: AppColors.textDark,

      ),
      bodySmall:  GoogleFonts.robotoTextTheme().bodySmall!.copyWith(
       color: AppColors.textDark,

     
      ),

    
    ),
    useMaterial3: true,
    colorSchemeSeed: AppColors.brand,
  );

  static ThemeData theme = ThemeData(
    
    textSelectionTheme: TextSelectionThemeData(
      selectionHandleColor: AppColors.gold,
      cursorColor: AppColors.gold,
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero
      ),
     rangeSelectionOverlayColor: WidgetStatePropertyAll(AppColors.brandDark),
      elevation: 0,
      

      ),
    textTheme: GoogleFonts.robotoTextTheme().copyWith(

       titleLarge:  GoogleFonts.robotoTextTheme().titleLarge!.copyWith(
        // height: 32.0 / 22.0,
        fontWeight: FontWeight.bold,
        // color: kMainTextColor,
        letterSpacing: 0.5,
      ),
      titleMedium:  GoogleFonts.robotoTextTheme().titleMedium!.copyWith(
        // fontSize: 17.0,
        // height: 27.0 / 17.0,
        // color: kMainTextColor,
        letterSpacing: 0.5,
        fontWeight: FontWeight.bold,
      ),
      titleSmall:  GoogleFonts.robotoTextTheme().titleSmall!.copyWith(
        // fontSize: 15.0,
        // height: 25.0 / 15.0,
        fontWeight: FontWeight.bold,
        // color: kMainTextColor,
        letterSpacing: 0.5,
      ),
      bodyLarge:  GoogleFonts.robotoTextTheme().bodyLarge!.copyWith(
        // fontSize: 17.0,
        // height: 27.0 / 17.0,
        // color: kMainTextColor,
        letterSpacing: 0.5,
      ),
      bodyMedium:  GoogleFonts.robotoTextTheme().bodyMedium!.copyWith(
        // fontSize: 14.0,
        // height: 25.0 / 15.0,
         color: Colors.black,
        letterSpacing: 0.5,
      ),
      bodySmall:  GoogleFonts.robotoTextTheme().bodySmall!.copyWith(
        fontSize: 12,
        // height: 15.0 / 12.0,
        // color: kMainTextColor,
        letterSpacing: 0.5,
      ),

      // displayLarge: TextStyle(fontSize: 57.0),
      // displayMedium: TextStyle(fontSize: 45.0),
      // displaySmall: TextStyle(fontSize: 34.0),
      // headlineLarge: TextStyle(fontSize: 32.0),
      // headlineMedium: TextStyle(fontSize: 28.0),
      // headlineSmall: TextStyle(fontSize: 24.0),
      // titleLarge: TextStyle(fontSize: 20.0),
      // titleMedium: TextStyle(fontSize: 16.0),
      // titleSmall: TextStyle(fontSize: 14.0),
      // bodyLarge: TextStyle(fontSize: 16.0), // Adjust as needed
      // bodyMedium: TextStyle(fontSize: 14.0),
      // bodySmall: TextStyle(fontSize: 12.0),
     
    ),
    useMaterial3: true,
    colorSchemeSeed: AppColors.brand,
  );
  static ThemeData theme2 = ThemeData(
    
    textSelectionTheme: TextSelectionThemeData(
      selectionHandleColor: AppColors.goldBright,
      cursorColor: AppColors.goldBright,
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero
      ),
     rangeSelectionOverlayColor: WidgetStatePropertyAll(AppColors.brandDark),
      elevation: 0,
      

      ),
    textTheme: GoogleFonts.oswaldTextTheme().copyWith(

       titleLarge:  GoogleFonts.oswaldTextTheme().titleLarge!.copyWith(
        // height: 32.0 / 22.0,
        fontWeight: FontWeight.bold,
        // color: kMainTextColor,
        letterSpacing: 0.5,
      ),
      titleMedium:  GoogleFonts.oswaldTextTheme().titleMedium!.copyWith(
        // fontSize: 17.0,
        // height: 27.0 / 17.0,
        // color: kMainTextColor,
        letterSpacing: 0.5,
        fontWeight: FontWeight.bold,
      ),
      titleSmall:  GoogleFonts.oswaldTextTheme().titleSmall!.copyWith(
        // fontSize: 15.0,
        // height: 25.0 / 15.0,
        fontWeight: FontWeight.bold,
        // color: kMainTextColor,
        letterSpacing: 0.5,
      ),
      bodyLarge:  GoogleFonts.oswaldTextTheme().bodyLarge!.copyWith(
        // fontSize: 17.0,
        // height: 27.0 / 17.0,
        // color: kMainTextColor,
        letterSpacing: 0.5,
      ),
      bodyMedium:  GoogleFonts.oswaldTextTheme().bodyMedium!.copyWith(
        // fontSize: 14.0,
        // height: 25.0 / 15.0,
         color: Colors.black,
        letterSpacing: 0.5,
      ),
      bodySmall:  GoogleFonts.oswaldTextTheme().bodySmall!.copyWith(
        fontSize: 12,
        // height: 15.0 / 12.0,
        // color: kMainTextColor,
        letterSpacing: 0.5,
      ),


    ),
    useMaterial3: true,
    colorSchemeSeed: AppColors.brand,
  );
}
