import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class TrumiaTypography {
  TrumiaTypography._();

  static TextStyle base({
    double size = 14,
    FontWeight weight = FontWeight.w500,
    Color color = TrumiaColors.textPrimary,
    double letterSpacing = 0,
    double? height,
  }) {
    return GoogleFonts.notoSans(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle get heroBalance => base(
        size: 56,
        weight: FontWeight.w700,
        letterSpacing: -1.1,
        height: 1.0,
      );

  static TextStyle get heroBalanceSuffix => base(
        size: 28,
        weight: FontWeight.w600,
        color: TrumiaColors.textSecondary,
        height: 1.0,
      );

  static TextStyle get heroSubtitle => base(
        size: 16,
        weight: FontWeight.w400,
        color: TrumiaColors.textSecondary,
      );

  static TextStyle get screenTitle => base(
        size: 18,
        weight: FontWeight.w600,
      );

  static TextStyle get groupHeader => base(
        size: 17,
        weight: FontWeight.w700,
      );

  static TextStyle get listTitle => base(
        size: 16,
        weight: FontWeight.w600,
      );

  static TextStyle get listSubtitle => base(
        size: 13,
        weight: FontWeight.w400,
        color: TrumiaColors.textSecondary,
      );

  static TextStyle get amount => base(
        size: 16,
        weight: FontWeight.w600,
      );

  static TextStyle get amountSecondary => base(
        size: 13,
        weight: FontWeight.w500,
        color: TrumiaColors.textSecondary,
      );

  static TextStyle get buttonLabel => base(
        size: 14,
        weight: FontWeight.w600,
      );

  static TextStyle get pillLabel => base(
        size: 14,
        weight: FontWeight.w600,
      );

  static TextStyle get sectionLabel => base(
        size: 13,
        weight: FontWeight.w500,
        color: TrumiaColors.textTertiary,
      );

  static TextStyle get cardLogo => GoogleFonts.notoSansMono(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        letterSpacing: 1.2,
      );

  static TextStyle get cardNumber => GoogleFonts.notoSansMono(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.white,
        letterSpacing: 1.4,
      );
}
