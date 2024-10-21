import 'dart:math' as math;
import 'package:flutter/material.dart';

class SweepingReveal extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool reveal;
  final double blurSigma;

  const SweepingReveal({
    Key? key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.reveal = true,
    this.blurSigma = 5.0,
  }) : super(key: key);

  @override
  _SweepingRevealState createState() => _SweepingRevealState();
}

class _SweepingRevealState extends State<SweepingReveal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(begin: 0, end: 1)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_controller);
    if (widget.reveal) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(SweepingReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.reveal != oldWidget.reveal) {
      if (widget.reveal) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

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
        return ClipPath(
          clipper: _SweepingClipper(_animation.value),
          child: Stack(
            children: [
              widget.child,
              Positioned.fill(
                child: CustomPaint(
                  painter: _BlurPainter(_animation.value, widget.blurSigma),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SweepingClipper extends CustomClipper<Path> {
  final double progress;

  _SweepingClipper(this.progress);

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, size.height / 2);
    path.addArc(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2 + size.width / 2,
      ),
      -math.pi / 2,
      2 * math.pi * progress,
    );
    path.lineTo(size.width / 2, size.height / 2);
    return path;
  }

  @override
  bool shouldReclip(_SweepingClipper oldClipper) =>
      progress != oldClipper.progress;
}

class _BlurPainter extends CustomPainter {
  final double progress;
  final double blurSigma;

  _BlurPainter(this.progress, this.blurSigma);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.transparent
      ..maskFilter =
          MaskFilter.blur(BlurStyle.normal, blurSigma * (1 - progress));

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      2 * math.pi * progress - math.pi / 2,
      math.pi / 18, // Small angle for blur edge
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
