import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:fx_2_folder/stacked-cards/stacked_card.dart';

class GlowingThreadWidget extends StatefulWidget {
  final Widget child;
  final Color threadColor;
  final Color glowColor;
  final double topSpacing;
  final double bottomSpacing;
  final double curvature;
  final double wrapCurvature;
  final double duration;
  final double glowWidth;
  final bool debugMode;

  const GlowingThreadWidget({
    super.key,
    required this.child,
    this.threadColor = Colors.white,
    this.glowColor = const Color(0xFF9C40FF),
    this.topSpacing = 0.2,
    this.bottomSpacing = 0.15,
    this.curvature = 0.3,
    this.wrapCurvature = 0.05,
    this.duration = 3.0,
    this.glowWidth = 4.0,
    this.debugMode = false,
  });

  @override
  State<GlowingThreadWidget> createState() => _GlowingThreadWidgetState();
}

class _GlowingThreadWidgetState extends State<GlowingThreadWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        LayoutBuilder(
          builder: (context, constraints) {
            return AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: GlowingThreadPainter(
                    progress: _animation.value,
                    threadColor: widget.threadColor,
                    glowColor: widget.glowColor,
                    topSpacing: widget.topSpacing,
                    bottomSpacing: widget.bottomSpacing,
                    curvature: widget.curvature,
                    wrapCurvature: widget.wrapCurvature,
                    glowWidth: widget.glowWidth,
                    debugMode: widget.debugMode,
                  ),
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class GlowingThreadPainter extends CustomPainter {
  final double progress;
  final Color threadColor;
  final Color glowColor;
  final double topSpacing;
  final double bottomSpacing;
  final double curvature;
  final double wrapCurvature;
  final double glowWidth;
  final bool debugMode;

  GlowingThreadPainter({
    required this.progress,
    required this.threadColor,
    required this.glowColor,
    required this.topSpacing,
    required this.bottomSpacing,
    required this.curvature,
    required this.wrapCurvature,
    required this.glowWidth,
    required this.debugMode,
  });

  void _drawThread(
      Canvas canvas, Size size, Paint paint, int index, bool isGlow) {
    const threadCount = 4;

    // Calculate points
    final startPoint = Offset(
      size.width * (0.1 + index * bottomSpacing),
      size.height,
    );
    final endPoint = Offset(
      size.width * (0.2 + index * topSpacing),
      0,
    );

    // Control points for the main curve
    final controlPoint1 = Offset(
      startPoint.dx + (endPoint.dx - startPoint.dx) * 0.5,
      startPoint.dy - size.height * curvature,
    );
    final controlPoint2 = Offset(
      endPoint.dx - (endPoint.dx - startPoint.dx) * 0.5,
      endPoint.dy + size.height * curvature,
    );

    // Create the complete thread path
    final path = Path();

    // Bottom wrap
    path.moveTo(
      startPoint.dx - size.width * wrapCurvature * 1.2,
      startPoint.dy,
    );
    path.quadraticBezierTo(
      startPoint.dx - size.width * wrapCurvature,
      startPoint.dy + size.height * wrapCurvature * 1.5,
      startPoint.dx,
      startPoint.dy,
    );

    // Main curve
    path.cubicTo(
      controlPoint1.dx,
      controlPoint1.dy,
      controlPoint2.dx,
      controlPoint2.dy,
      endPoint.dx,
      endPoint.dy,
    );

    // Top wrap
    path.quadraticBezierTo(
      endPoint.dx + size.width * wrapCurvature,
      endPoint.dy - size.height * wrapCurvature,
      endPoint.dx + size.width * wrapCurvature * 1.2,
      endPoint.dy,
    );

    if (isGlow) {
      final pathMetrics = path.computeMetrics().first;
      final pathLength = pathMetrics.length;

      // Modified glow segment calculations for smoother transition
      final glowSegmentLength = pathLength * 0.3; // Increased segment length
      final start = (progress + index * 0.25) % 1.0 * pathLength;
      final end = (start + glowSegmentLength) % pathLength;

      Path extractPath;
      if (end > start) {
        extractPath = pathMetrics.extractPath(start, end);
      } else {
        extractPath = pathMetrics.extractPath(start, pathLength);
        extractPath.addPath(pathMetrics.extractPath(0, end), Offset.zero);
      }

      // Create a more subtle glow effect
      final gradientStart =
          pathMetrics.getTangentForOffset(start)?.position ?? Offset.zero;
      final gradientEnd = pathMetrics
              .getTangentForOffset(
                  (start + glowSegmentLength * 0.5) % pathLength)
              ?.position ??
          Offset.zero;

      // Outer glow (subtle ambient glow)
      final outerGlowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = glowWidth * 2.0
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

      outerGlowPaint.shader = ui.Gradient.linear(
        gradientStart,
        gradientEnd,
        [
          glowColor.withOpacity(0.0),
          glowColor.withOpacity(0.15),
          glowColor.withOpacity(0.0),
        ],
        [0.0, 0.5, 1.0],
      );

      // Middle glow (main glow body)
      final middleGlowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = glowWidth * 1.2
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

      middleGlowPaint.shader = ui.Gradient.linear(
        gradientStart,
        gradientEnd,
        [
          glowColor.withOpacity(0.0),
          glowColor.withOpacity(0.4),
          glowColor.withOpacity(0.0),
        ],
        [0.0, 0.5, 1.0],
      );

      // Inner glow (core brightness)
      final innerGlowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = glowWidth * 0.8
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      innerGlowPaint.shader = ui.Gradient.linear(
        gradientStart,
        gradientEnd,
        [
          glowColor.withOpacity(0.0),
          glowColor.withOpacity(0.8),
          glowColor.withOpacity(0.0),
        ],
        [0.0, 0.5, 1.0],
      );

      // Draw glow layers in reverse order for better blend
      canvas.drawPath(extractPath, outerGlowPaint);
      canvas.drawPath(extractPath, middleGlowPaint);
      canvas.drawPath(extractPath, innerGlowPaint);
    } else {
      // Make the base thread slightly transparent
      final basePaint = Paint()
        ..color = threadColor.withOpacity(0.6)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(path, basePaint);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Draw base threads first
    for (var i = 0; i < 4; i++) {
      _drawThread(canvas, size, Paint(), i, false);
    }

    // Draw glowing effects on top
    for (var i = 0; i < 4; i++) {
      _drawThread(canvas, size, Paint(), i, true);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class GlowingThreadDemo extends StatelessWidget {
  const GlowingThreadDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color:
              const ui.Color.fromARGB(255, 0, 0, 0), // Deep purple background
          child: CustomPaint(
            painter: GridPatternPainter(isDarkMode: true),
          ),
        ),
        Center(
          child: SizedBox(
            width: 200,
            height: 100,
            child: GlowingThreadWidget(
              threadColor: const Color(0xFF80FFDB).withOpacity(0.4),
              glowColor: const Color(0xFFFFD700), // Golden glow
              glowWidth: 3.0,
              duration: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2D00F7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B6B), // Coral
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'ELECTRIC',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
