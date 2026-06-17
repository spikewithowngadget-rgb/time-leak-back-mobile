import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppStyle {
  static const String _appFont = 'Arial';

  /// Шрифт бренда TimeLeak (логотип / название) — без Arial.
  static TextStyle brand(
    double size, {
    Color? color,
    FontWeight? fontWeight,
    double? height,
  }) {
    return GoogleFonts.mulish(
      fontSize: size,
      color: color,
      fontWeight: fontWeight ?? FontWeight.w700,
      height: height,
    );
  }

  static TextStyle style(
    double size, {
    Color? color,
    FontWeight? fontWeight,
    double? height,
    double? letterSpacing,
    FontStyle? fontStyle,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: _appFont,
      fontSize: size,
      color: color,
      fontWeight: fontWeight ?? FontWeight.w400,
      height: height,
      letterSpacing: letterSpacing,
      fontStyle: fontStyle,
      decoration: decoration,
    );
  }
}
