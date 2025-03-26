import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? color;
  final TextAlign? textAlign;
  final double? letterSpacing;
  final double? height;
  final double? wordSpacing;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDecorationStyle? decorationStyle;
  final String? fontFamily; // Custom Google Font (Poppins or Montserrat)

  const CustomText({
    super.key,
    required this.text,
    this.fontWeight = FontWeight.w500,
    this.fontSize,
    this.color,
    this.textAlign,
    this.letterSpacing,
    this.maxLines,
    this.decorationStyle,
    this.overflow,
    this.height,
    this.wordSpacing,
    this.fontFamily = "Poppins",
  });

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle;

    // If a custom font is provided, use it, else default to Google Fonts
    if (fontFamily == 'Poppins') {
      textStyle = poppinsTextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
        wordSpacing: wordSpacing,
      );
    } else if (fontFamily == 'Montserrat') {
      textStyle = montserratTextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
        wordSpacing: wordSpacing,
      );
    } else {
      // Default to a simple style if no font family is provided
      textStyle = TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
        wordSpacing: wordSpacing,
      );
    }

    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      style: textStyle,
    );
  }

  // Helper method for Poppins text style
  static TextStyle poppinsTextStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
    double? wordSpacing,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      wordSpacing: wordSpacing,
    );
  }

  // Helper method for Montserrat text style
  static TextStyle montserratTextStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
    double? wordSpacing,
  }) {
    return GoogleFonts.montserrat(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      wordSpacing: wordSpacing,
    );
  }
}