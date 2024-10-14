import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final String text;
  final double fontSize;
  final List<Color> gradientColors;

  const GradientText({
    Key? key,
    required this.text,
    required this.fontSize,
    required this.gradientColors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: gradientColors,
          stops: [0.0, 0.3, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds);
      },
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          // height: fontSize * 1.2,
          fontWeight: FontWeight.bold,
          height: 1, // Equivalent to leading-none
          letterSpacing: -1.5, // App
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
