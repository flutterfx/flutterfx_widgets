import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

// Keep existing ClockHandRevealClipper unchanged
class ClockHandRevealClipper extends CustomClipper<Path> {
  final double progress;
  ClockHandRevealClipper({required this.progress});

  @override
  Path getClip(Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    if (progress <= 0.0) return Path();
    if (progress >= 1.0) {
      return Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    }

    final startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    final path = Path();
    path.moveTo(center.dx, center.dy);
    path.lineTo(center.dx, 0);

    final rect = Rect.fromCircle(center: center, radius: size.width);
    path.arcTo(rect, startAngle, sweepAngle, true);

    path.lineTo(center.dx, center.dy);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(ClockHandRevealClipper oldClipper) =>
      oldClipper.progress != progress;
}

// Clipper for the blur wedge
class BlurWedgeClipper extends CustomClipper<Path> {
  final double progress;
  final double wedgeAngle;
  final double bandWidth;

  BlurWedgeClipper({
    required this.progress,
    required this.wedgeAngle,
    required this.bandWidth,
  });

  @override
  Path getClip(Size size) {
    if (progress <= 0.0 || progress >= 1.0) return Path();

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final startAngle = -math.pi / 2 + (2 * math.pi * progress) - wedgeAngle;

    final path = Path();
    path.moveTo(center.dx, center.dy);

    final rect = Rect.fromCircle(center: center, radius: radius);
    path.arcTo(rect, startAngle, wedgeAngle, true);
    path.lineTo(center.dx, center.dy);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(BlurWedgeClipper oldClipper) =>
      oldClipper.progress != progress ||
      oldClipper.wedgeAngle != wedgeAngle ||
      oldClipper.bandWidth != bandWidth;
}

// Gradient mask painter
class GradientMaskPainter extends CustomPainter {
  final double progress;
  final double wedgeAngle;
  final double bandWidth;
  final double wedgeOpacity;

  GradientMaskPainter({
    required this.progress,
    required this.wedgeAngle,
    required this.bandWidth,
    required this.wedgeOpacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.0 || progress >= 1.0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final startAngle = -math.pi / 2 + (2 * math.pi * progress) - wedgeAngle;

    // Create gradient for fade out effect
    final paint = Paint()
      ..shader = SweepGradient(
        colors: [
          Colors.white.withOpacity(wedgeOpacity),
          Colors.white.withOpacity(0),
        ],
        stops: [0.0, bandWidth],
        startAngle: startAngle,
        endAngle: startAngle + wedgeAngle,
        transform: GradientRotation(startAngle),
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    // Draw the wedge with gradient
    final path = Path();
    path.moveTo(center.dx, center.dy);
    path.arcTo(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      wedgeAngle,
      true,
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(GradientMaskPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.wedgeAngle != wedgeAngle ||
      oldDelegate.bandWidth != bandWidth ||
      oldDelegate.wedgeOpacity != wedgeOpacity;
}

class ClockHandRevealWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool autoStart;
  final VoidCallback? onAnimationComplete;
  final double blurSigma;
  final double wedgeAngleDegrees;
  final double wedgeOpacity;
  final double blurBandWidth;

  const ClockHandRevealWidget({
    Key? key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.autoStart = true,
    this.onAnimationComplete,
    this.blurSigma = 5.0,
    this.wedgeAngleDegrees = 10.0,
    this.wedgeOpacity = 0.7,
    this.blurBandWidth = 0.15,
  }) : super(key: key);

  @override
  ClockHandRevealWidgetState createState() => ClockHandRevealWidgetState();
}

class ClockHandRevealWidgetState extends State<ClockHandRevealWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onAnimationComplete?.call();
        }
      });

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    if (widget.autoStart) {
      _controller.forward();
    }
  }

  void startReveal() => _controller.forward(from: 0.0);
  void reverseReveal() => _controller.reverse();
  double get progress => _controller.value;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          children: [
            // Main reveal
            ClipPath(
              clipper: ClockHandRevealClipper(
                progress: _animation.value,
              ),
              child: widget.child,
            ),
            // Blur wedge
            ClipPath(
              clipper: BlurWedgeClipper(
                progress: _animation.value,
                wedgeAngle: widget.wedgeAngleDegrees * (math.pi / 180),
                bandWidth: widget.blurBandWidth,
              ),
              child: Stack(
                children: [
                  widget.child,
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: widget.blurSigma,
                        sigmaY: widget.blurSigma,
                      ),
                      child: CustomPaint(
                        painter: GradientMaskPainter(
                          progress: _animation.value,
                          wedgeAngle:
                              widget.wedgeAngleDegrees * (math.pi / 180),
                          bandWidth: widget.blurBandWidth,
                          wedgeOpacity: widget.wedgeOpacity,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// Example usage remains the same
class ExampleUsage extends StatelessWidget {
  const ExampleUsage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClockHandRevealWidget(
        duration: const Duration(seconds: 2),
        blurSigma: 10.0,
        wedgeAngleDegrees: 15.0,
        wedgeOpacity: 0.7,
        blurBandWidth: 0.15,
        child: Container(
          width: 300,
          height: 300,
          color: Colors.blue,
          child: const Center(
            child: Text(
              'Hello World!',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
