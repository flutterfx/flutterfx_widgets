import 'dart:math' as math;
import 'package:flutter/material.dart';

class OrbitingDot {
  final double orbitRadius;
  final double baseHeight;
  final Color color;
  final double dotSize;
  double angle;
  final double startAngle;

  OrbitingDot({
    required this.orbitRadius,
    required this.baseHeight,
    required this.color,
    required this.startAngle,
    this.dotSize = 4.0,
    this.angle = 0.0,
  });

  Offset getPosition() {
    final x = math.cos(angle) * orbitRadius;
    final z = math.sin(angle) * orbitRadius;
    final yOffset = z * 0.1;
    return Offset(x, baseHeight + yOffset);
  }
}

class FestiveTree extends StatefulWidget {
  final double maxRadius;
  final double height;
  final int numberOfOrbits;
  final int dotsPerOrbit; // New parameter for dots per orbit
  final List<Color> dotColors;

  const FestiveTree({
    Key? key,
    this.maxRadius = 200.0,
    this.height = 400.0,
    this.numberOfOrbits = 14,
    this.dotsPerOrbit = 8, // Default value for dots per orbit
    this.dotColors = const [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
    ],
  }) : super(key: key);

  @override
  State<FestiveTree> createState() => _FestiveTreeState();
}

class _FestiveTreeState extends State<FestiveTree>
    with SingleTickerProviderStateMixin {
  late List<OrbitingDot> dots;
  late AnimationController _controller;
  bool isChaoticMode = false;

  @override
  void initState() {
    super.initState();
    _initializeDots();
    _setupAnimation();
  }

  void _initializeDots() {
    dots = [];

    for (int orbitIndex = 0; orbitIndex < widget.numberOfOrbits; orbitIndex++) {
      // Calculate orbit properties
      final radiusProgress = orbitIndex / (widget.numberOfOrbits - 1);
      final orbitRadius = widget.maxRadius * radiusProgress;
      final heightProgress = orbitIndex / (widget.numberOfOrbits - 1);
      final height = heightProgress * widget.height;

      // Create multiple dots for each orbit
      for (int dotIndex = 0; dotIndex < widget.dotsPerOrbit; dotIndex++) {
        // Distribute dots evenly around the orbit
        final startAngle = (dotIndex / widget.dotsPerOrbit) * math.pi * 2;

        // Alternate colors within the same orbit for more variety
        final colorIndex = (orbitIndex + dotIndex) % widget.dotColors.length;

        // Vary dot sizes slightly for more visual interest
        final baseDotSize = 4.0;
        final randomSize =
            baseDotSize * (0.8 + math.Random().nextDouble() * 0.4);

        dots.add(
          OrbitingDot(
            orbitRadius: orbitRadius,
            baseHeight: height,
            color: widget.dotColors[colorIndex],
            startAngle: startAngle,
            dotSize: randomSize,
          ),
        );
      }
    }
  }

  void _setupAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8), // Slightly slower for better effect
    )..addListener(_updateDotPositions);

    _controller.repeat();
  }

  void _updateDotPositions() {
    setState(() {
      for (var dot in dots) {
        dot.angle = dot.startAngle + (_controller.value * math.pi * 2);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.maxRadius * 2,
      height: widget.height,
      child: CustomPaint(
        painter: OrbitingDotsPainter(
          dots: dots,
          starColor: Colors.yellow,
          showOrbits: false, // Hide orbits for cleaner look with many dots
          isChaoticMode: false,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class OrbitingDotsPainter extends CustomPainter {
  final List<OrbitingDot> dots;
  final Color starColor;
  final bool showOrbits;
  final bool isChaoticMode; // New parameter

  OrbitingDotsPainter({
    required this.dots,
    required this.starColor,
    this.showOrbits = false,
    this.isChaoticMode = false, // Default to orderly mode
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, 0);

    // Sort dots by z-position for proper depth rendering
    final sortedDots = List<OrbitingDot>.from(dots)
      ..sort((a, b) {
        final aZ = math.sin(a.angle) * a.orbitRadius;
        final bZ = math.sin(b.angle) * b.orbitRadius;
        return bZ.compareTo(aZ);
      });

    // Draw the dots with motion-based effects
    for (var dot in sortedDots) {
      final position = isChaoticMode
          ? dot.getPosition() // Use wobble effect in chaotic mode
          : Offset(
              // Simple circular motion in orderly mode
              math.cos(dot.angle) * dot.orbitRadius,
              dot.baseHeight + math.sin(dot.angle) * dot.orbitRadius * 0.1);

      final paint = Paint()
        ..color = dot.color
        ..style = PaintingStyle.fill;

      final z = math.sin(dot.angle);
      final opacity = math.max(0.3, math.min(1.0, (z + 1) / 2));
      paint.color = paint.color.withOpacity(opacity);

      if (z > 0) {
        final glowPaint = Paint()
          ..color = dot.color.withOpacity(0.2)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(
          position,
          dot.dotSize * 1.5,
          glowPaint,
        );
      }

      canvas.drawCircle(
        position,
        dot.dotSize,
        paint,
      );
    }

    _drawStar(canvas, Offset(0, 0), 12, starColor);
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final angleStep = math.pi / 5;

    for (var i = 0; i < 10; i++) {
      final r = i.isEven ? radius : radius * 0.4;
      final angle = -math.pi / 2 + i * angleStep;
      final x = center.dx + math.cos(angle) * r;
      final y = center.dy + math.sin(angle) * r;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(OrbitingDotsPainter oldDelegate) => true;
}

class TreeDemo extends StatelessWidget {
  const TreeDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: FestiveTree(
        maxRadius: 200,
        numberOfOrbits: 14,
        dotColors: [
          Colors.red,
          Colors.blue,
          Colors.green,
          Colors.yellow,
          Colors.purple,
          Colors.orange,
        ],
      ),
    );
  }
}
