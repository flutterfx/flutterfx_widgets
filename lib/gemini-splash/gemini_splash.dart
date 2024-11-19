import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedSparkle extends StatefulWidget {
  final double size;
  final Color color;
  final Duration duration;

  const AnimatedSparkle({
    super.key,
    this.size = 50.0,
    this.color = Colors.pink,
    this.duration = const Duration(milliseconds: 1300),
  });

  @override
  State<AnimatedSparkle> createState() => _AnimatedSparkleState();
}

class _AnimatedSparkleState extends State<AnimatedSparkle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _starScale;
  late Animation<double> _circleRadius;
  late Animation<double> _circleOpacity;
  late Animation<double> _rotationAnimation;
  late Animation<double> _positionAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    // Star scale animation
    _starScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
    ));

    // Circle radius animation
    _circleRadius = Tween<double>(
      begin: 0.0,
      end: widget.size * 0.20,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    // Circle opacity animation
    _circleOpacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 0.9, curve: Curves.easeOut),
    ));

    // Rotation animation (90 degrees clockwise)
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: math.pi / 2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
    ));

    // Position animation (moving upward)
    _positionAnimation = Tween<double>(
      begin: 0.0,
      end: -60.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.9, curve: Curves.easeOut),
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _positionAnimation.value),
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Star (back layer)
                Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: Transform.scale(
                    scale: _starScale.value,
                    child: CustomPaint(
                      size: Size(widget.size, widget.size),
                      painter: StarPainter(color: widget.color),
                    ),
                  ),
                ),
                // Circle (front layer)
                Opacity(
                  opacity: _circleOpacity.value,
                  child: Container(
                    width: _circleRadius.value * 2,
                    height: _circleRadius.value * 2,
                    decoration: BoxDecoration(
                      color: widget.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class StarPainter extends CustomPainter {
  final Color color;

  StarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final path = Path();
    final radius = size.width / 2 * 0.8; // Star size
    final controlPointDistance =
        size.width * 0.4 * 0.5; // Control point distance

    for (int i = 0; i < 4; i++) {
      final angle = (i * math.pi / 2);
      final pointX = center.dx + math.cos(angle) * radius;
      final pointY = center.dy + math.sin(angle) * radius;

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

    // Close the shape with the final curve
    final controlX =
        center.dx + math.cos(7 * math.pi / 4) * controlPointDistance;
    final controlY =
        center.dy + math.sin(7 * math.pi / 4) * controlPointDistance;
    path.quadraticBezierTo(controlX, controlY, center.dx + radius, center.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(StarPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

// Usage Example:
class SparkleDemo extends StatelessWidget {
  const SparkleDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedSparkle(
          size: 50,
          color: Colors.pink,
          duration: Duration(milliseconds: 1500),
        ),
      ),
    );
  }
}
