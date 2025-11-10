import 'package:flutter/material.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';
import 'app_colors.dart';
import 'gradients.dart';

class ButtonStyles {
  // Gradient button with rounded radius
  static final GradientButtonStyle gradientRounded = GradientElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    gradient: AppGradients.primary,
  );

  // Gradient button with no radius
  static final GradientButtonStyle gradientNoRadius = GradientElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    shape: const RoundedRectangleBorder(),
    gradient: AppGradients.primary,
  );

  // Solid button
  static final ButtonStyle solid = ElevatedButton.styleFrom(
    backgroundColor: AppColors.brand,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );

}


final GradientButtonStyle GRADIENT_ELEVATED_BUTTON_STYLE =
    GradientElevatedButton.styleFrom(
      foregroundColor: Colors.white,
   shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
  gradient: LinearGradient(
    colors: [
      AppColors.brand,
      AppColors.brandDark,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ),
);

final GradientButtonStyle GRADIENT_ELEVATED_BUTTON_STYLE_NO_RADIUS =
    GradientElevatedButton.styleFrom(
      foregroundColor: Colors.white,
   shape: const RoundedRectangleBorder(
  ),
  gradient: LinearGradient(
    colors: [
      AppColors.brand,
      AppColors.brandDark,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ),
);

final IconButtonStyle = IconButton.styleFrom(
  backgroundColor: AppColors.errorLight
);

final ButtonStyle ELEVATED_BUTTON_SOCIALITE_STYLE = ElevatedButton.styleFrom(
  backgroundColor: Colors.white,
  foregroundColor: Colors.black,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
);
final ButtonStyle ELEVATED_BUTTON_STYLE = ElevatedButton.styleFrom(
  backgroundColor:Colors.white,
  foregroundColor: AppColors.brand,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
);
final ButtonStyle ELEVATED_BUTTON_STYLE_PRIMARY = ElevatedButton.styleFrom(
  backgroundColor: AppColors.brand,
  foregroundColor: Colors.white,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
);