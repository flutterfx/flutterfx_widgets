import 'dart:math';

import 'package:flutter/material.dart';

class CosmicBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Layer 1: Gradient Background
        BackgroundGradient(),

        // Layer 2: Particle Effect
        ParticleEffect(),

        // Layer 3: Orbital Paths
        OrbitalPaths(),

        // Layer 4: Moving Star
        MovingStars(),
      ],
    );
  }
}

class BackgroundGradient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center:
              Alignment(0.0, 1.5), // Centered horizontally, below the bottom
          radius: 1.2,
          colors: [
            Color(0xFF441260), // Deep purple
            Color(0xFF1A1040), // Mid purple
            Color(0xFF110B2B), // Dark purple
          ],
          stops: [0.0, 0.6, 1.0],
        ),
      ),
    );
  }
}

class ParticleEffect extends StatefulWidget {
  @override
  _ParticleEffectState createState() => _ParticleEffectState();
}

class _ParticleEffectState extends State<ParticleEffect>
    with TickerProviderStateMixin {
  late List<Particle> particles;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    particles = List.generate(30, (index) => Particle.random());
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(particles, _controller.value),
          size: Size.infinite,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class Particle {
  double x;
  double y;
  double brightness;
  double angle; // For rotation
  double phaseOffset; // For individual timing
  double size;

  Particle.random()
      : x = Random().nextDouble(),
        // Fixed positions in bottom third of screen
        y = 0.7 + (Random().nextDouble() * 0.3),
        brightness = Random().nextDouble() * 0.7 + 0.3,
        angle = Random().nextDouble() * 2 * pi,
        phaseOffset = Random().nextDouble() * 2 * pi,
        size = Random().nextDouble() * 2.0 + 0.5;
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animation;

  ParticlePainter(this.particles, this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (var particle in particles) {
      // Calculate current rotation angle
      double currentAngle =
          particle.angle + (animation * 2 * pi) + particle.phaseOffset;

      // Use angle to create shimmer effect
      double shimmerIntensity =
          (cos(currentAngle) + 1) / 2; // Normalized to 0-1

      // Calculate position with tiny circular movement
      double radius = 2.0;
      double x = particle.x + (cos(currentAngle) * radius / size.width);
      double y = particle.y + (sin(currentAngle) * radius / size.height);

      // Shimmer brightness varies with rotation
      double currentBrightness =
          particle.brightness * (0.3 + (shimmerIntensity * 0.7));

      // Draw main glow
      paint
        ..color = Colors.white.withOpacity(currentBrightness * 0.6)
        ..maskFilter = MaskFilter.blur(
            BlurStyle.normal, particle.size * (0.5 + shimmerIntensity));

      canvas.drawCircle(
        Offset(x * size.width, y * size.height),
        particle.size * (1.0 + shimmerIntensity * 0.5),
        paint,
      );

      // Draw bright core when catching light
      if (shimmerIntensity > 0.7) {
        paint
          ..color = Colors.white.withOpacity(shimmerIntensity * 0.9)
          ..maskFilter = null;

        canvas.drawCircle(
          Offset(x * size.width, y * size.height),
          particle.size * 0.3,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}

class OrbitalPaths extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: OrbitalPathsPainter(),
      size: Size.infinite,
    );
  }
}

class OrbitalPathsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // Adjust center point to be closer to bottom
    final center = Offset(size.width / 2, size.height + (size.height * 0.05));
    final numberOfPaths = 6;

    // Start with a much smaller initial radius
    for (int i = 0; i < numberOfPaths; i++) {
      // Exponential growth for radius to match the image pattern
      double radius = size.width * (0.3 + (i * i * 0.08));
      paint.color = Colors.purple[100]!.withOpacity(0.15 - (i * 0.02));

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        pi, // Starting angle (180 degrees)
        pi, // Sweep angle (180 degrees)
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(OrbitalPathsPainter oldDelegate) => false;
}

class MovingStars extends StatefulWidget {
  @override
  _MovingStarsState createState() => _MovingStarsState();
}

class _MovingStarsState extends State<MovingStars>
    with TickerProviderStateMixin {
  late List<StarController> starControllers;

  @override
  void initState() {
    super.initState();
    // Create multiple star controllers with different paths and speeds
    starControllers = List.generate(3, (index) {
      return StarController(
        controller: AnimationController(
          vsync: this,
          duration: Duration(
              seconds: 3 +
                  Random().nextInt(4)), // Random duration between 3-7 seconds
        ),
        pathIndex: index, // Each star follows a different orbital path
        brightness: 0.3 + Random().nextDouble() * 0.7, // Random brightness
      )..controller.repeat();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: starControllers.map((controller) {
        return AnimatedBuilder(
          animation: controller.controller,
          builder: (context, child) {
            return CustomPaint(
              painter: StarTrailPainter(
                animation: controller.controller.value,
                pathIndex: controller.pathIndex,
                brightness: controller.brightness,
              ),
              size: Size.infinite,
            );
          },
        );
      }).toList(),
    );
  }

  @override
  void dispose() {
    for (var controller in starControllers) {
      controller.controller.dispose();
    }
    super.dispose();
  }
}

class StarController {
  final AnimationController controller;
  final int pathIndex;
  final double brightness;

  StarController({
    required this.controller,
    required this.pathIndex,
    required this.brightness,
  });
}

class StarTrailPainter extends CustomPainter {
  final double animation;
  final int pathIndex;
  final double brightness;

  StarTrailPainter({
    required this.animation,
    required this.pathIndex,
    required this.brightness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(brightness)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1);

    // Calculate the path radius based on the star's assigned path
    final center = Offset(size.width / 2, size.height + (size.height * 0.05));
    // Match the orbital paths radius calculation
    final radius = size.width * (0.3 + (pathIndex * pathIndex * 0.08));

    // Calculate current position
    final angle = pi + (pi * animation);
    final x = center.dx + radius * cos(angle);
    final y = center.dy + radius * sin(angle);

    // Draw the main star
    canvas.drawCircle(Offset(x, y), 1.5, paint);

    // Draw the trail
    for (int i = 1; i <= 5; i++) {
      final trailAngle = angle - (i * 0.1);
      final trailX = center.dx + radius * cos(trailAngle);
      final trailY = center.dy + radius * sin(trailAngle);

      paint.color = Colors.white.withOpacity(brightness * (1 - i * 0.2));
      canvas.drawCircle(Offset(trailX, trailY), 1.0 - (i * 0.15), paint);
    }
  }

  @override
  bool shouldRepaint(StarTrailPainter oldDelegate) => true;
}

class BgOrbittalStarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CosmicBackground(),
    );
  }
}
