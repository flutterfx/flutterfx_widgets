// lib/theme/app_theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Colors - Monochromatic scheme
  static const Color primaryColor = Color(0xFF000000);
  static const Color secondaryColor = Color(0xFF333333);
  static const Color accentColor = Color(0xFF666666);
  static const Color textPrimaryColor = Color(0xFF1A1A1A);
  static const Color backgroundStartColor = Color(0xFFF8F8F8);
  static const Color backgroundEndColor = Color(0xFFFFFFFF);
  static const Color cardStartColor = Color(0xFFFFFFFF);
  static const Color cardEndColor = Color(0xFFF5F5F5);

  // Background Pattern Colors
  static const Color patternColor = Color(0xFFF0F0F0);
  static const Color patternHighlightColor = Color(0xFFFFFFFF);

  // Gradients
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      cardStartColor,
      cardEndColor,
    ],
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [
      primaryColor,
      secondaryColor,
    ],
  );

  // Background Pattern
  static BoxDecoration get pageBackground => BoxDecoration(
        color: backgroundStartColor,
        image: DecorationImage(
          image: NetworkImage(
              'data:image/svg+xml;base64,...'), // Will be replaced with pattern
          repeat: ImageRepeat.repeat,
        ),
      );

  // Shadows
  static List<BoxShadow> get cardShadows => [
        // Soft ambient shadow
        BoxShadow(
          color: primaryColor.withOpacity(0.04),
          spreadRadius: 0,
          blurRadius: 20,
          offset: const Offset(0, 0),
        ),
        // Sharp highlight
        BoxShadow(
          color: Colors.white.withOpacity(0.9),
          spreadRadius: 0,
          blurRadius: 8,
          offset: const Offset(-2, -2),
        ),
        // Main shadow
        BoxShadow(
          color: primaryColor.withOpacity(0.12),
          spreadRadius: 0,
          blurRadius: 12,
          offset: const Offset(4, 4),
        ),
      ];

  // Text Styles
  static const TextStyle titleStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
    letterSpacing: 0.4,
  );

  static TextStyle descriptionStyle = TextStyle(
    fontSize: 14.0,
    color: textPrimaryColor.withOpacity(0.75),
    letterSpacing: 0.2,
    height: 1.4,
  );

  // Spacing
  static const double cardPadding = 24.0;
  static const double cardMargin = 16.0;
  static const double cardBorderRadius = 16.0;

  // Decorative Elements
  static const double accentBarHeight = 3.0;
  static const double accentBarWidth = 60.0;
  static const double accentBarRadius = 1.5;
}
