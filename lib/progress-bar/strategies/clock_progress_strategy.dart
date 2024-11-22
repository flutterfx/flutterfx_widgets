import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:fx_2_folder/progress-bar/progress_bar.dart';

class PizzaProgressStrategy implements ProgressAnimationStrategy {
  @override
  Widget buildProgressWidget({
    required double progress,
    required Animation<double> animation,
    required BuildContext context,
    required ProgressStyle style,
  }) {
    return Container(
      width: style.width,
      height: style.height,
      padding: style.padding,
      child: CustomPaint(
        painter: PizzaProgressPainter(
          progress: progress,
          fillColor: style.primaryColor,
          backgroundColor: style.backgroundColor,
        ),
      ),
    );
  }
}

class PizzaProgressPainter extends CustomPainter {
  final double progress;
  final Color fillColor;
  final Color backgroundColor;

  PizzaProgressPainter({
    required this.progress,
    required this.fillColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    // Draw the background circle
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, bgPaint);

    // Draw the progress arc
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from the top
      progress * 2 * math.pi, // Sweep clockwise
      true, // Use center
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(PizzaProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
