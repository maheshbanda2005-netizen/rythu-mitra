import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Helper class for language-specific font selection
class FontHelper {
  FontHelper._();

  /// Get appropriate text style based on current language
  static TextStyle getLanguageTextStyle({
    required String language,
    required TextStyle baseStyle,
  }) {
    // Use Anek Telugu for Telugu language
    if (language == 'te') {
      return GoogleFonts.anekTelugu(
        fontSize: baseStyle.fontSize,
        fontWeight: baseStyle.fontWeight,
        color: baseStyle.color,
        height: baseStyle.height,
        letterSpacing: baseStyle.letterSpacing,
        decoration: baseStyle.decoration,
        decorationColor: baseStyle.decorationColor,
        decorationStyle: baseStyle.decorationStyle,
        decorationThickness: baseStyle.decorationThickness,
      );
    }
    
    // Use Noto Sans Devanagari for Hindi
    if (language == 'hi') {
      return GoogleFonts.notoSansDevanagari(
        fontSize: baseStyle.fontSize,
        fontWeight: baseStyle.fontWeight,
        color: baseStyle.color,
        height: baseStyle.height,
        letterSpacing: baseStyle.letterSpacing,
        decoration: baseStyle.decoration,
        decorationColor: baseStyle.decorationColor,
        decorationStyle: baseStyle.decorationStyle,
        decorationThickness: baseStyle.decorationThickness,
      );
    }
    
    // Use Geist for English
    return GoogleFonts.geist(
      fontSize: baseStyle.fontSize,
      fontWeight: baseStyle.fontWeight,
      color: baseStyle.color,
      height: baseStyle.height,
      letterSpacing: baseStyle.letterSpacing,
      decoration: baseStyle.decoration,
      decorationColor: baseStyle.decorationColor,
      decorationStyle: baseStyle.decorationStyle,
      decorationThickness: baseStyle.decorationThickness,
    );
  }

  /// Get language-specific font family
  static String getFontFamily(String language) {
    switch (language) {
      case 'te':
        return 'Anek Telugu';
      case 'hi':
        return 'Noto Sans Devanagari';
      default:
        return 'Geist';
    }
  }

  /// Apply language-specific font to a text widget
  static Widget applyLanguageFont({
    required Widget child,
    required String language,
  }) {
    if (language == 'te') {
      return DefaultTextStyle(
        style: GoogleFonts.anekTelugu(),
        child: child,
      );
    } else if (language == 'hi') {
      return DefaultTextStyle(
        style: GoogleFonts.notoSansDevanagari(),
        child: child,
      );
    }
    return DefaultTextStyle(
      style: GoogleFonts.geist(),
      child: child,
    );
  }

  /// Get localized text style with automatic font selection
  static TextStyle getLocalizedTextStyle({
    required String language,
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    final baseStyle = TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );

    return getLanguageTextStyle(language: language, baseStyle: baseStyle);
  }
}