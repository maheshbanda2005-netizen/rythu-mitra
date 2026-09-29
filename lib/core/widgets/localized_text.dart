import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/app_state_service.dart';

/// A text widget that automatically applies the appropriate font based on the current language
class LocalizedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool softWrap;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;

  const LocalizedText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
    this.strutStyle,
    this.textDirection,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateService>();
    final language = appState.currentLanguage;

    TextStyle effectiveStyle = style ?? Theme.of(context).textTheme.bodyMedium!;

    // Apply language-specific font
    switch (language) {
      case 'te':
        effectiveStyle = GoogleFonts.anekTelugu(
          fontSize: effectiveStyle.fontSize,
          fontWeight: effectiveStyle.fontWeight,
          color: effectiveStyle.color,
          height: effectiveStyle.height,
          letterSpacing: effectiveStyle.letterSpacing,
          decoration: effectiveStyle.decoration,
          decorationColor: effectiveStyle.decorationColor,
          decorationStyle: effectiveStyle.decorationStyle,
          decorationThickness: effectiveStyle.decorationThickness,
        );
        break;
      case 'hi':
        effectiveStyle = GoogleFonts.notoSansDevanagari(
          fontSize: effectiveStyle.fontSize,
          fontWeight: effectiveStyle.fontWeight,
          color: effectiveStyle.color,
          height: effectiveStyle.height,
          letterSpacing: effectiveStyle.letterSpacing,
          decoration: effectiveStyle.decoration,
          decorationColor: effectiveStyle.decorationColor,
          decorationStyle: effectiveStyle.decorationStyle,
          decorationThickness: effectiveStyle.decorationThickness,
        );
        break;
      default:
        // Use Geist for English
        effectiveStyle = GoogleFonts.geist(
          fontSize: effectiveStyle.fontSize,
          fontWeight: effectiveStyle.fontWeight,
          color: effectiveStyle.color,
          height: effectiveStyle.height,
          letterSpacing: effectiveStyle.letterSpacing,
          decoration: effectiveStyle.decoration,
          decorationColor: effectiveStyle.decorationColor,
          decorationStyle: effectiveStyle.decorationStyle,
          decorationThickness: effectiveStyle.decorationThickness,
        );
        break;
    }

    return Text(
      text,
      style: effectiveStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      strutStyle: strutStyle,
      textDirection: textDirection,
    );
  }
}

/// A localized text widget that automatically handles the common use case
class LocalizedTextWidget extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const LocalizedTextWidget(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return LocalizedText(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}