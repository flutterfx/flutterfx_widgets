import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class BorderBeam extends StatefulWidget {
  const BorderBeam({
    super.key,
    required this.child,
    this.duration = 15,
    this.borderWidth = 1.5,
    this.colorFrom = const Color(0xFFFFAA40),
    this.colorTo = const Color(0xFF9C40FF),
    this.staticBorderColor = const Color(0xFFCCCCCC),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.padding = EdgeInsets.zero,
  });

  final BorderRadius borderRadius;
  final double borderWidth;
  final Widget child;
  final Color colorFrom;
  final Color colorTo;
  final double duration;
  final EdgeInsetsGeometry padding;
  final Color staticBorderColor;

  @override
  _BorderBeamState createState() => _BorderBeamState();
}

class _BorderBeamState extends State<BorderBeam>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: widget.duration.toInt()),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: BorderBeamPainter(
            progress: _animation.value,
            borderWidth: widget.borderWidth,
            colorFrom: widget.colorFrom,
            colorTo: widget.colorTo,
            staticBorderColor: widget.staticBorderColor,
            borderRadius: widget.borderRadius,
          ),
          child: Padding(
            padding: widget.padding,
            child: widget.child,
          ),
        );
      },
    );
  }
}

class BorderBeamPainter extends CustomPainter {
  BorderBeamPainter({
    required this.progress,
    required this.borderWidth,
    required this.colorFrom,
    required this.colorTo,
    required this.staticBorderColor,
    required this.borderRadius,
  });

  final BorderRadius borderRadius;
  final double borderWidth;
  final Color colorFrom;
  final Color colorTo;
  final double progress;
  final Color staticBorderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = borderRadius.toRRect(rect);

    // Draw static border
    final staticPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..color = staticBorderColor;
    canvas.drawRRect(rrect, staticPaint);

    final path = Path()..addRRect(rrect);

    final pathMetrics = path.computeMetrics().first;
    final pathLength = pathMetrics.length;

    // Adjust the animation to prevent the jump
    final animationProgress = progress % 1.0;
    final start = animationProgress * pathLength;
    final end = (start + pathLength / 4) % pathLength;

    Path extractPath;
    if (end > start) {
      extractPath = pathMetrics.extractPath(start, end);
    } else {
      extractPath = pathMetrics.extractPath(start, pathLength);
      extractPath.addPath(pathMetrics.extractPath(0, end), Offset.zero);
    }

    // Calculate gradient start and end points
    final gradientStart =
        pathMetrics.getTangentForOffset(start)?.position ?? Offset.zero;
    final gradientEnd = pathMetrics
            .getTangentForOffset((start + pathLength / 8) % pathLength)
            ?.position ??
        Offset.zero;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    paint.shader = ui.Gradient.linear(
      gradientStart,
      gradientEnd,
      [
        colorTo.withOpacity(0.0), // Transparent color for fading effect
        colorTo,
        colorFrom,
      ],
      [0.0, 0.3, 1.0],
    );

    canvas.drawPath(extractPath, paint);
  }

  @override
  bool shouldRepaint(covariant BorderBeamPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
