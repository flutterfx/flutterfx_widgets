import 'package:flutter/material.dart';

class LightbulbIconPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  LightbulbIconPainter({
    this.color = Colors.black,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final double width = size.width;
    final double height = size.height;

    // Scale factors to maintain proportions at any size
    final double scaleX = width / 24;
    final double scaleY = height / 24;

    // Create a path for the lightbulb
    final path = Path();

    // Draw bulb body (circle with base)
    canvas.drawArc(
      Rect.fromCircle(
          center: Offset(12 * scaleX, 12 * scaleY), radius: 5 * scaleX),
      0,
      2 * 3.14159,
      false,
      paint,
    );

    // Draw bulb base lines
    canvas.drawLine(
      Offset(10 * scaleX, 16.584 * scaleY),
      Offset(10 * scaleX, 19 * scaleY),
      paint,
    );
    canvas.drawLine(
      Offset(14 * scaleX, 16.584 * scaleY),
      Offset(14 * scaleX, 19 * scaleY),
      paint,
    );

    // Draw rays
    // Right ray
    canvas.drawLine(
      Offset(20 * scaleX, 12 * scaleY),
      Offset(21 * scaleX, 12 * scaleY),
      paint,
    );

    // Left ray
    canvas.drawLine(
      Offset(4 * scaleX, 12 * scaleY),
      Offset(3 * scaleX, 12 * scaleY),
      paint,
    );

    // Top ray
    canvas.drawLine(
      Offset(12 * scaleX, 4 * scaleY),
      Offset(12 * scaleX, 3 * scaleY),
      paint,
    );

    // Top-right ray
    canvas.drawLine(
      Offset(17.5 * scaleX, 6.5 * scaleY),
      Offset(18.5 * scaleX, 5.5 * scaleY),
      paint,
    );

    // Top-left ray
    canvas.drawLine(
      Offset(6.5 * scaleX, 6.5 * scaleY),
      Offset(5.5 * scaleX, 5.5 * scaleY),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class LightbulbIcon extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidth;

  const LightbulbIcon({
    Key? key,
    this.size = 24,
    this.color = Colors.black,
    this.strokeWidth = 2.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: LightbulbIconPainter(
        color: color,
        strokeWidth: strokeWidth,
      ),
    );
  }
}
