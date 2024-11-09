import 'package:flutter/material.dart';

class AppTheme {
  // Light theme
  static final Map<String, Color> lightTheme = {
    'titleColor': const Color(0xFF2C2C2C),
    'descriptionColor': const Color(0xFF757575),
  };

  // Dark theme
  static final Map<String, Color> darkTheme = {
    'titleColor': const Color(0xFFFFFFFF),
    'descriptionColor': const Color(0xFFB0B0B0),
  };

  // Update the gradient maps to use List<Color>
  static final Map<String, List<Color>> lightGradients = {
    'backgroundGradient': const [Color(0xFFF8F8F8), Color(0xFFFFFFFF)],
    'cardGradient': const [Color(0xFFFFFFFF), Color(0xFFF8F8F8)],
    'accentGradient': const [Color(0xFF6B64F3), Color(0xFF4237F1)],
  };

  static final Map<String, List<Color>> darkGradients = {
    'backgroundGradient': const [
      Color.fromARGB(255, 0, 0, 0),
      Color.fromARGB(255, 0, 0, 0)
    ],
    'cardGradient': const [Color(0xFF2C2C2C), Color(0xFF242424)],
    'accentGradient': const [Color(0xFF8C86F5), Color(0xFF6B64F3)],
  };

  // Update the getter methods to use the correct types
  static TextStyle getTitleStyle(bool isDarkMode) => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color:
            isDarkMode ? darkTheme['titleColor']! : lightTheme['titleColor']!,
      );

  static TextStyle getDescriptionStyle(bool isDarkMode) => TextStyle(
        fontSize: 14,
        color: isDarkMode
            ? darkTheme['descriptionColor']!
            : lightTheme['descriptionColor']!,
      );

  static List<Color> getBackgroundGradient(bool isDarkMode) => isDarkMode
      ? darkGradients['backgroundGradient']!
      : lightGradients['backgroundGradient']!;

  static List<Color> getAccentGradient(bool isDarkMode) => isDarkMode
      ? darkGradients['accentGradient']!
      : lightGradients['accentGradient']!;

  static List<Color> getCardGradient(bool isDarkMode) => isDarkMode
      ? darkGradients['cardGradient']!
      : lightGradients['cardGradient']!;

  static Color getPatternColor(bool isDarkMode) =>
      isDarkMode ? const Color(0xFF3A3A3A) : const Color(0xFFE0E0E0);

  static final List<BoxShadow> cardShadows = [
    const BoxShadow(
      color: Color(0x2A000000), // Increased opacity from 0x1A to 0x2A
      offset: Offset(0, 0), // Centered offset
      blurRadius: 6, // Slightly increased blur
      spreadRadius: 0, // Added some spread
    ),
    const BoxShadow(
      color: Color(0x1A000000), // Increased opacity from 0x0D to 0x1A
      offset: Offset(0, 1), // Slight downward offset for depth
      blurRadius: 12, // Increased blur for softer shadow
      spreadRadius: 0, // Added spread for better visibility
    ),
  ];
  // Layout constants
  static const double cardMargin = 16.0;
  static const double cardBorderRadius = 16.0;
  static const double cardPadding = 24.0;
  static const double accentBarHeight = 4.0;
  static const double accentBarWidth = 48.0;
  static const double accentBarRadius = 2.0;
}
