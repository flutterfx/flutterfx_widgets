import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class LightEffectWidgetDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GradientControlPage(),
    );
  }
}

class GradientControlPage extends StatefulWidget {
  const GradientControlPage({super.key});

  @override
  State<GradientControlPage> createState() => _GradientControlPageState();
}

class _GradientControlPageState extends State<GradientControlPage> {
  double startAngle = 33.7 * pi / 180; // -45 degrees
  double sweepAngle = pi / 2; // 90 degrees
  double gradientRadius = 0.8;
  bool showDebugElements = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: GradientDemo(
                startAngle: startAngle,
                sweepAngle: sweepAngle,
                gradientRadius: gradientRadius,
                showDebugElements: showDebugElements,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.black87,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showDebugElements) ...[
                  _buildControlLabel(
                      'Angle: ${(startAngle * 180 / pi).toStringAsFixed(1)}°'),
                  Slider(
                    value: startAngle,
                    min: -pi,
                    max: pi,
                    onChanged: (value) => setState(() => startAngle = value),
                  ),
                ],
                CheckboxListTile(
                  title: const Text('Debug'),
                  value: showDebugElements,
                  onChanged: (value) =>
                      setState(() => showDebugElements = value ?? true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }
}

class GradientDemo extends StatelessWidget {
  final double startAngle;
  final double sweepAngle;
  final double gradientRadius;
  final bool showDebugElements;

  const GradientDemo({
    super.key,
    required this.startAngle,
    required this.sweepAngle,
    required this.gradientRadius,
    required this.showDebugElements,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 250, // Increased height to accommodate the blur rectangle
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CustomPaint(
            size: const Size(300, 250),
            painter: GradientPainter(
              startAngle: startAngle,
              sweepAngle: sweepAngle,
              gradientRadius: gradientRadius,
              showDebugElements: showDebugElements,
            ),
          ),
          Positioned(
            bottom: -50, // Position it half outside
            left: 0,
            right: 0,
            height: 100, // Total height of blur rectangle
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 0,
                  sigmaY: 10,
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 0,
                    sigmaY: 10,
                  ),
                  child: Container(
                    color: Colors.white.withOpacity(0.00001),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GradientPainter extends CustomPainter {
  final double startAngle;
  final double sweepAngle;
  final double gradientRadius;
  final bool showDebugElements;

  GradientPainter({
    required this.startAngle,
    required this.sweepAngle,
    required this.gradientRadius,
    required this.showDebugElements,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Draw white rectangle
    final backgroundPaint = Paint()..color = Colors.white;
    canvas.drawRect(rect, backgroundPaint);

    // Calculate centers for both gradients
    final leftCenter = Offset(size.width / 4, 0);
    final rightCenter = Offset(3 * size.width / 4, 0);
    final radius = size.height * gradientRadius;

    // Left gradient
    final leftGradientPaint = Paint()
      ..shader = SweepGradient(
        center: Alignment(-0.5, 0), // Left center
        startAngle: startAngle,
        endAngle: startAngle + sweepAngle,
        colors: [
          Colors.white.withOpacity(0),
          Colors.black,
        ],
        stops: const [0.0, 1.0],
      ).createShader(rect)
      ..style = PaintingStyle.fill;

    // Right gradient (mirrored)
    final rightGradientPaint = Paint()
      ..shader = SweepGradient(
        center: Alignment(0.5, 0), // Right center
        startAngle: pi - startAngle - sweepAngle,
        endAngle: pi - startAngle,
        colors: [
          Colors.black,
          Colors.white.withOpacity(0),
        ],
        stops: const [0.0, 1.0],
      ).createShader(rect)
      ..style = PaintingStyle.fill;

    // Draw both gradients
    canvas.drawRect(rect, leftGradientPaint);
    canvas.drawRect(rect, rightGradientPaint);

    if (!showDebugElements) return;

    // Debug elements for both centers
    final centerPointPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    canvas.drawCircle(leftCenter, 4, centerPointPaint);
    canvas.drawCircle(rightCenter, 4, centerPointPaint);

    // Debug circles
    final debugCirclePaint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw dashed circles for both gradients
    _drawDashedCircle(canvas, leftCenter, radius, debugCirclePaint);
    _drawDashedCircle(canvas, rightCenter, radius, debugCirclePaint);

    // Corner points
    final cornerPointPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset.zero, 3, cornerPointPaint);
    canvas.drawCircle(Offset(size.width, 0), 3, cornerPointPaint);
    canvas.drawCircle(Offset(0, size.height), 3, cornerPointPaint);
    canvas.drawCircle(Offset(size.width, size.height), 3, cornerPointPaint);
  }

  void _drawDashedCircle(
      Canvas canvas, Offset center, double radius, Paint paint) {
    const dashLength = 5;
    const dashSpace = 5;
    double currentAngle = 0;

    while (currentAngle < 2 * pi) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        currentAngle,
        dashLength / radius,
        false,
        paint,
      );
      currentAngle += (dashLength + dashSpace) / radius;
    }
  }

  @override
  bool shouldRepaint(GradientPainter oldDelegate) =>
      oldDelegate.startAngle != startAngle ||
      oldDelegate.sweepAngle != sweepAngle ||
      oldDelegate.gradientRadius != gradientRadius ||
      oldDelegate.showDebugElements != showDebugElements;
}
