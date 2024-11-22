import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fx_2_folder/progress-bar/progress_bar.dart';
import 'dart:ui' as ui;

class CircularProgressStrategy implements ProgressAnimationStrategy {
  final double strokeWidth;

  CircularProgressStrategy({this.strokeWidth = 8.0});

  @override
  Widget buildProgressWidget({
    required double progress,
    required Animation<double> animation,
    required BuildContext context,
    required ProgressStyle style,
  }) {
    return Container(
      width: style.width,
      height:
          style.width, // Using width for both dimensions to keep it circular
      padding: style.padding,
      child: CustomPaint(
        painter: CircularProgressPainter(
          progress: progress,
          strokeWidth: strokeWidth,
          backgroundColor: style.backgroundColor,
          progressColor: style.primaryColor,
          gradientColors: style.gradientColors,
        ),
      ),
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;
  final List<Color>? gradientColors;

  CircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.progressColor,
    this.gradientColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - strokeWidth / 2;

    // Draw background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Create the progress arc path
    final rect = Rect.fromCircle(center: center, radius: radius);
    final path = Path()
      ..addArc(
        rect,
        -pi / 2, // Start from top
        2 * pi * progress, // Progress amount
      );

    final pathMetrics = path.computeMetrics().first;
    final pathLength = pathMetrics.length;

    // Calculate gradient points based on the current progress
    final startPoint = pathMetrics.getTangentForOffset(0)?.position ?? center;
    final endPoint =
        pathMetrics.getTangentForOffset(pathLength)?.position ?? center;

    // Draw progress arc
    final progressPaint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    if (gradientColors != null && gradientColors!.length >= 2) {
      // Create a gradient that follows the arc
      progressPaint.shader = ui.Gradient.linear(
        startPoint,
        endPoint,
        [
          gradientColors![0],
          gradientColors![1],
          gradientColors![0], // Add the first color again for smooth transition
        ],
        [0.0, 0.5, 1.0],
      );
    } else {
      progressPaint.color = progressColor;
    }

    // Draw the progress path
    canvas.drawPath(path, progressPaint);
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.progressColor != progressColor;
  }
}
