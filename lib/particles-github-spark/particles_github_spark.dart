import 'dart:math' as math;
import 'package:flutter/material.dart';

enum ParticleShape { circle, star, diamond }

class RisingParticles extends StatefulWidget {
  final int quantity;
  final List<Color> colors;
  final double maxSize;
  final double minSize;

  const RisingParticles({
    Key? key,
    this.quantity = 50,
    this.colors = const [
      Color(0xFF4C40BB), // Deep purple/blue
      Color(0xFF5DEC88), // Bright green
      Color(0xFFFF4423), // Bright red/orange
      Color(0xFF8157E8), // Bright purple
    ],
    this.maxSize = 8,
    this.minSize = 3,
  }) : super(key: key);

  @override
  State<RisingParticles> createState() => _RisingParticlesState();
}

class _RisingParticlesState extends State<RisingParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<RisingParticle> particles = [];
  Size canvasSize = Size.zero;
  final math.Random random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _controller.addListener(_updateParticles);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initParticles() {
    particles.clear();
    for (int i = 0; i < widget.quantity; i++) {
      particles.add(_createParticle());
    }
  }

  RisingParticle _createParticle({double initialProgress = 0.0}) {
    // Random starting position at bottom of screen
    final x = random.nextDouble() * canvasSize.width;
    final y = canvasSize.height +
        random.nextDouble() * 20; // Slight variance in start

    // Control points for moderately pronounced S-curve
    // First control point - creates the bottom curve of S
    final cp1x = x +
        (random.nextDouble() * 60 + 30) *
            (random.nextBool() ? 1 : -1); // Moderate horizontal displacement
    final cp1y = canvasSize.height * 0.8; // Slightly higher first control point

    // Second control point - creates the top curve of S
    final cp2x = x +
        (random.nextDouble() * 60 + 30) *
            (cp1x < x ? 1 : -1); // Opposite direction, moderate displacement
    final cp2y = canvasSize.height * 0.65; // Adjusted second control point

    return RisingParticle(
      startX: x,
      startY: y,
      controlPoint1: Offset(cp1x, cp1y),
      controlPoint2: Offset(cp2x, cp2y),
      endX: x + (random.nextDouble() - 0.5) * 50,
      endY: canvasSize.height * 0.5, // Half screen height
      size: random.nextDouble() * (widget.maxSize - widget.minSize) +
          widget.minSize,
      color: widget.colors[random.nextInt(widget.colors.length)],
      shape: ParticleShape.values[random.nextInt(ParticleShape.values.length)],
      progress: initialProgress, // Random initial progress
      speed: 0.2 + random.nextDouble() * 0.3, // Random speed
    );
  }

  void _updateParticles() {
    for (final particle in particles) {
      particle.progress += particle.speed / 120; // Update based on speed

      if (particle.progress >= 1.0) {
        // Reset particle when it reaches the top
        final index = particles.indexOf(particle);
        particles[index] = _createParticle();
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        canvasSize = Size(constraints.maxWidth, constraints.maxHeight);
        if (particles.isEmpty) {
          _initParticles();
        }

        return CustomPaint(
          size: Size.infinite,
          painter: RisingParticlesPainter(
            particles: particles,
          ),
        );
      },
    );
  }
}

class RisingParticlesPainter extends CustomPainter {
  final List<RisingParticle> particles;

  RisingParticlesPainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(easedOpacity(particle.progress))
        ..style = PaintingStyle.fill;

      final path = Path();
      final currentPoint = _calculateBezierPoint(
        particle.progress,
        Offset(particle.startX, particle.startY),
        particle.controlPoint1,
        particle.controlPoint2,
        Offset(particle.endX, particle.endY),
      );

      // Save the current canvas state
      canvas.save();

      // Translate to the particle position, rotate, then translate back
      canvas.translate(currentPoint.dx, currentPoint.dy);
      canvas.rotate(particle.progress * 4 * math.pi); // 2 full rotations
      canvas.translate(-currentPoint.dx, -currentPoint.dy);

      final easedSizeValue = easedSize(particle.progress, particle.size);
      switch (particle.shape) {
        case ParticleShape.circle:
          canvas.drawCircle(currentPoint, easedSizeValue, paint);
          break;
        case ParticleShape.star:
          _drawStar(canvas, currentPoint, easedSizeValue, paint);
          break;
        case ParticleShape.diamond:
          _drawDiamond(canvas, currentPoint, easedSizeValue, paint);
          break;
      }

      // Restore the canvas state
      canvas.restore();
    }
  }

  double easedOpacity(double progress) {
    return 1.0 - Curves.easeIn.transform(progress);
  }

  double easedSize(double progress, size) {
    const minSize = 0.3; // Minimum scale (30%)
    final easedProgress = Curves.easeIn.transform(progress);
    return size * (1.0 - ((1.0 - minSize) * easedProgress));
  }

  Offset _calculateBezierPoint(
      double t, Offset start, Offset c1, Offset c2, Offset end) {
    final t1 = math.pow(1 - t, 3).toDouble();
    final t2 = 3 * math.pow(1 - t, 2) * t;
    final t3 = 3 * (1 - t) * math.pow(t, 2);
    final t4 = math.pow(t, 3).toDouble();

    final x = t1 * start.dx + t2 * c1.dx + t3 * c2.dx + t4 * end.dx;
    final y = t1 * start.dy + t2 * c1.dy + t3 * c2.dy + t4 * end.dy;

    return Offset(x, y);
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    final double fullSize = size;

    // Control point distance for the quadratic curves
    // This controls how much the sides curve inward
    final double controlPointDistance = fullSize * 0.4;

    for (int i = 0; i < 4; i++) {
      final angle = (i * math.pi / 2); // 90 degree rotation for each point

      // Calculate point position
      final pointX = center.dx + math.cos(angle) * fullSize;
      final pointY = center.dy + math.sin(angle) * fullSize;

      if (i == 0) {
        path.moveTo(pointX, pointY);
      } else {
        // Calculate control point for the quadratic curve
        final prevAngle = ((i - 1) * math.pi / 2);
        final midAngle = prevAngle + math.pi / 4; // Halfway between points

        final controlX = center.dx + math.cos(midAngle) * controlPointDistance;
        final controlY = center.dy + math.sin(midAngle) * controlPointDistance;

        // Draw curved line to next point
        path.quadraticBezierTo(controlX, controlY, pointX, pointY);
      }
    }

    // Close the path with final curve
    final controlX =
        center.dx + math.cos(7 * math.pi / 4) * controlPointDistance;
    final controlY =
        center.dy + math.sin(7 * math.pi / 4) * controlPointDistance;

    path.quadraticBezierTo(controlX, controlY, center.dx + fullSize, center.dy);

    paint.style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
  }

  void _drawDiamond(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path()
      ..moveTo(center.dx, center.dy - size)
      ..lineTo(center.dx + size, center.dy)
      ..lineTo(center.dx, center.dy + size)
      ..lineTo(center.dx - size, center.dy)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(RisingParticlesPainter oldDelegate) => true;
}

class RisingParticle {
  final double startX;
  final double startY;
  final Offset controlPoint1;
  final Offset controlPoint2;
  final double endX;
  final double endY;
  final double size;
  final Color color;
  final ParticleShape shape;
  double progress;
  final double speed;

  RisingParticle({
    required this.startX,
    required this.startY,
    required this.controlPoint1,
    required this.controlPoint2,
    required this.endX,
    required this.endY,
    required this.size,
    required this.color,
    required this.shape,
    required this.progress,
    required this.speed,
  });
}
