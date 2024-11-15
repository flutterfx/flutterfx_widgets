import 'package:flutter/material.dart';
import 'package:fx_2_folder/button-shimmer/design/widget_theme.dart';

class GridPatternPainter extends CustomPainter {
  final bool isDarkMode;

  GridPatternPainter({required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    // First, draw the background fill
    final backgroundPaint = Paint()
      ..color = isDarkMode ? Colors.black : Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );

    // Then draw the grid lines
    final gridPaint = Paint()
      ..color = AppTheme.getPatternColor(isDarkMode)
      ..strokeWidth = 1;

    const spacing = 20.0;

    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        gridPaint,
      );
    }

    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        gridPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
