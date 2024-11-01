import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fx_2_folder/tools/curves.dart';

class StepRotatingShape extends StatefulWidget {
  final double size;
  final Duration rotationDuration;
  final Duration pauseDuration;
  final Color color;

  const StepRotatingShape({
    super.key,
    this.size = 100,
    this.rotationDuration = const Duration(milliseconds: 300),
    this.pauseDuration = const Duration(milliseconds: 200),
    this.color = const Color(0xFF8157E8),
  });

  @override
  State<StepRotatingShape> createState() => _StepRotatingShapeState();
}

class _StepRotatingShapeState extends State<StepRotatingShape>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.rotationDuration,
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: math.pi / 2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _startNextRotation();
      }
    });

    _startRotation();
  }

  void _startNextRotation() async {
    await Future.delayed(widget.pauseDuration);
    if (!mounted) return;

    _currentStep = (_currentStep + 1) % 4;
    if (_currentStep == 0) {
      _controller.value = 0;
    }
    _startRotation();
  }

  void _startRotation() {
    if (!mounted) return;
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Add a SizedBox to constrain the size
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            size: Size(widget.size, widget.size),
            painter: StarPainter(
              rotationAngle:
                  _currentStep * (math.pi / 2) + _rotationAnimation.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class StarPainter extends CustomPainter {
  final double rotationAngle;
  final Color color;

  StarPainter({
    required this.rotationAngle,
    required this.color,
  });

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    final double fullSize =
        size * 0.8; // Adjust size to 80% of the container to ensure it fits
    final double controlPointDistance = fullSize * 0.4;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotationAngle);
    canvas.translate(-center.dx, -center.dy);

    for (int i = 0; i < 4; i++) {
      final angle = (i * math.pi / 2);

      final pointX = center.dx + math.cos(angle) * fullSize;
      final pointY = center.dy + math.sin(angle) * fullSize;

      if (i == 0) {
        path.moveTo(pointX, pointY);
      } else {
        final prevAngle = ((i - 1) * math.pi / 2);
        final midAngle = prevAngle + math.pi / 4;

        final controlX = center.dx + math.cos(midAngle) * controlPointDistance;
        final controlY = center.dy + math.sin(midAngle) * controlPointDistance;

        path.quadraticBezierTo(controlX, controlY, pointX, pointY);
      }
    }

    final controlX =
        center.dx + math.cos(7 * math.pi / 4) * controlPointDistance;
    final controlY =
        center.dy + math.sin(7 * math.pi / 4) * controlPointDistance;

    path.quadraticBezierTo(controlX, controlY, center.dx + fullSize, center.dy);

    paint.style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final shapeSize = size.width /
        2; // Use half of the width directly, since we're working with radius

    _drawStar(canvas, center, shapeSize, paint);
  }

  @override
  bool shouldRepaint(StarPainter oldDelegate) {
    return oldDelegate.rotationAngle != rotationAngle ||
        oldDelegate.color != color;
  }
}
