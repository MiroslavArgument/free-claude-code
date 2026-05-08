import 'package:flutter/material.dart';

import 'colors.dart';
import 'typography.dart';

class TrumiaTheme {
  TrumiaTheme._();

  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: TrumiaColors.bgPrimary,
      colorScheme: base.colorScheme.copyWith(
        primary: TrumiaColors.accentGreen,
        secondary: TrumiaColors.accentGreenDark,
        surface: TrumiaColors.surfaceElevated,
        onSurface: TrumiaColors.textPrimary,
      ),
      textTheme: base.textTheme.apply(
        fontFamily: TrumiaTypography.base().fontFamily,
        displayColor: TrumiaColors.textPrimary,
        bodyColor: TrumiaColors.textPrimary,
      ),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
    );
  }
}
