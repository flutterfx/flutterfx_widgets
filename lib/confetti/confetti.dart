import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vector;

enum ParticleShape { rectangle, circle, strip, diamond, star, triangle, heart }

class ParticleShapeFactory {
  static Path getPath(ParticleShape shape, double size) {
    switch (shape) {
      case ParticleShape.rectangle:
        return Path()
          ..addRect(Rect.fromCenter(
            center: Offset.zero,
            width: size,
            height: size * 1.5,
          ));

      case ParticleShape.circle:
        return Path()
          ..addOval(Rect.fromCircle(
            center: Offset.zero,
            radius: size * 0.5,
          ));

      case ParticleShape.strip:
        return Path()
          ..moveTo(-size * 0.3, -size)
          ..lineTo(size * 0.3, -size)
          ..lineTo(size * 0.2, size)
          ..lineTo(-size * 0.2, size)
          ..close();

      case ParticleShape.diamond:
        return Path()
          ..moveTo(0, -size)
          ..lineTo(size * 0.7, 0)
          ..lineTo(0, size)
          ..lineTo(-size * 0.7, 0)
          ..close();

      case ParticleShape.star:
        final path = Path();
        final points = 5;
        final innerRadius = size * 0.4;
        final outerRadius = size;

        for (var i = 0; i < points * 2; i++) {
          final radius = i.isEven ? outerRadius : innerRadius;
          final angle = i * pi / points;
          final dx = cos(angle) * radius;
          final dy = sin(angle) * radius;

          if (i == 0) {
            path.moveTo(dx, dy);
          } else {
            path.lineTo(dx, dy);
          }
        }
        return path..close();

      case ParticleShape.triangle:
        return Path()
          ..moveTo(0, -size)
          ..lineTo(size * 0.866, size * 0.5)
          ..lineTo(-size * 0.866, size * 0.5)
          ..close();

      case ParticleShape.heart:
        final path = Path();
        path.moveTo(0, size * 0.3);

        // Left curve
        path.cubicTo(
          -size * 0.5,
          -size * 0.4,
          -size,
          0,
          0,
          size,
        );

        // Right curve
        path.cubicTo(
          size,
          0,
          size * 0.5,
          -size * 0.4,
          0,
          size * 0.3,
        );

        return path;
    }
  }
}

// Enhanced particle states to handle different animation phases
enum ParticleState {
  launch, // Initial burst from origin (0-200ms)
  burst, // Rapid divergence phase (200-500ms)
  float, // Natural floating phase (500ms-2s)
  fall // Final descent phase (2s+)
}

// Enhanced particle class with more realistic physics properties
class EnhancedConfettiParticle {
  Offset position;
  Offset velocity;
  final Color color;
  double rotation = 0;
  double rotationSpeed;
  double rotationAcceleration;
  final double size;
  final ParticleShape shape;

  // Enhanced physics properties
  final double mass; // Affects gravity and air resistance
  final double turbulence; // Random movement factor
  final double flutterSpeed; // Speed of oscillation
  final double flutterAmount; // Amount of side-to-side movement
  double lifespan; // How long particle lives
  ParticleState state; // Current animation state

  // Bezier control points for natural curved motion
  late Offset controlPoint1;
  late Offset controlPoint2;

  // Time tracking for state transitions
  double stateTime = 0;

  EnhancedConfettiParticle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.shape,
    required this.size,
  })  : mass = 0.8 + Random().nextDouble() * 0.4,
        turbulence = Random().nextDouble() * 0.6,
        flutterSpeed = 2 + Random().nextDouble() * 3,
        flutterAmount = Random().nextDouble() * 2.5,
        rotationSpeed = Random().nextDouble() * 0.15 - 0.075,
        rotationAcceleration = Random().nextDouble() * 0.01 - 0.005,
        lifespan = 1.0,
        state = ParticleState.launch {
    _initializeBezierPoints();
  }

  void _initializeBezierPoints() {
    // Initialize control points for bezier curve motion
    final random = Random();
    controlPoint1 = Offset(position.dx + (random.nextDouble() - 0.5) * 100,
        position.dy - random.nextDouble() * 50);
    controlPoint2 = Offset(position.dx + (random.nextDouble() - 0.5) * 200,
        position.dy - random.nextDouble() * 100);
  }
}

// Enhanced options class with more customization
class EnhancedConfettiOptions {
  final int particleCount;
  final double initialSpread; // Initial spread angle
  final double burstSpread; // Spread after burst
  final double baseVelocity; // Base velocity for particles
  final double burstVelocity; // Velocity during burst phase
  final double gravity;
  final double airResistance;
  final double turbulenceFactor;
  final List<Color> colors;
  final List<ParticleShape> shapes;
  final double launchDuration; // Duration of launch phase
  final double burstDuration; // Duration of burst phase
  final double floatDuration; // Duration of float phase

  const EnhancedConfettiOptions({
    this.particleCount = 100,
    this.initialSpread = 15,
    this.burstSpread = 120,
    this.baseVelocity = -8.0,
    this.burstVelocity = -15.0,
    this.gravity = 0.25,
    this.airResistance = 0.02,
    this.turbulenceFactor = 0.5,
    this.colors = const [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
    ],
    this.shapes = const [
      ParticleShape.rectangle,
      ParticleShape.circle,
      ParticleShape.strip,
      ParticleShape.diamond,
      ParticleShape.star,
    ],
    this.launchDuration = 0.2, // 200ms
    this.burstDuration = 0.3, // 300ms
    this.floatDuration = 1.5, // 1.5s
  });
}

// Enhanced painter class with improved physics and rendering
class EnhancedConfettiPainter extends CustomPainter {
  final List<EnhancedConfettiParticle> particles;
  final double progress;
  final EnhancedConfettiOptions options;
  final Random random = Random();

  // Perlin noise for smooth random motion
  final List<double> perlinSeed =
      List.generate(1000, (index) => Random().nextDouble() * 2 - 1);

  EnhancedConfettiPainter({
    required this.particles,
    required this.progress,
    required this.options,
  });

  double _perlinNoise(double x) {
    final i = x.floor() % perlinSeed.length;
    final j = (i + 1) % perlinSeed.length;
    final t = x - x.floor();
    // Smooth interpolation
    final smoothT = t * t * (3 - 2 * t);
    return perlinSeed[i] + (perlinSeed[j] - perlinSeed[i]) * smoothT;
  }

  void _applyLaunchPhysics(EnhancedConfettiParticle particle) {
    // Initial tight grouping with upward momentum
    final normalizedTime = particle.stateTime / options.launchDuration;

    // Gradually increase spread during launch
    final spreadFactor = normalizedTime * options.initialSpread;

    // Calculate initial trajectory
    particle.velocity = Offset(
        particle.velocity.dx * (1 - options.airResistance),
        options.baseVelocity * (1 - normalizedTime * 0.5));

    // Add slight random movement
    particle.velocity += Offset(_perlinNoise(particle.stateTime * 5) * 0.5,
        _perlinNoise(particle.stateTime * 5 + 100) * 0.5);
  }

  void _applyBurstPhysics(EnhancedConfettiParticle particle) {
    // Rapid divergence with high energy
    final normalizedTime = particle.stateTime / options.burstDuration;

    // Exponential spread increase
    final burstPower = pow(normalizedTime, 2);
    final spreadAngle = options.burstSpread * burstPower;

    // Calculate burst velocity
    final angle = random.nextDouble() * pi * 2;
    final speed = options.burstVelocity * (1 - normalizedTime);

    particle.velocity = Offset(cos(angle) * speed * (1 + random.nextDouble()),
        sin(angle) * speed + options.baseVelocity);

    // Add turbulence
    final turbulence = options.turbulenceFactor * (1 - normalizedTime);
    particle.velocity += Offset(
        _perlinNoise(particle.stateTime * 3) * turbulence,
        _perlinNoise(particle.stateTime * 3 + 50) * turbulence);
  }

  void _applyFloatPhysics(EnhancedConfettiParticle particle) {
    // Natural floating with turbulence
    final normalizedTime = particle.stateTime / options.floatDuration;

    // Gradually increase gravity influence
    final gravityEffect = options.gravity * normalizedTime;

    // Apply air resistance
    particle.velocity = Offset(
        particle.velocity.dx * (1 - options.airResistance),
        particle.velocity.dy * (1 - options.airResistance) + gravityEffect);

    // Add smooth turbulence using perlin noise
    final turbulenceStrength = options.turbulenceFactor * (1 - normalizedTime);
    particle.velocity += Offset(
        _perlinNoise(particle.stateTime * 2) * turbulenceStrength,
        _perlinNoise(particle.stateTime * 2 + 100) * turbulenceStrength * 0.5);
  }

  void _applyFallPhysics(EnhancedConfettiParticle particle) {
    // Gravity-dominated descent
    // Apply stronger gravity
    particle.velocity = Offset(
        particle.velocity.dx * (1 - options.airResistance * 0.5),
        particle.velocity.dy + options.gravity * particle.mass);

    // Add subtle horizontal drift
    final drift = _perlinNoise(particle.stateTime) * 0.3;
    particle.velocity += Offset(drift, 0);
  }

  void _applyRotation(EnhancedConfettiParticle particle) {
    // Update rotation based on state
    double rotationMultiplier = 1.0;

    switch (particle.state) {
      case ParticleState.launch:
        rotationMultiplier = 0.5;
        break;
      case ParticleState.burst:
        rotationMultiplier = 2.0;
        break;
      case ParticleState.float:
        rotationMultiplier = 1.0;
        break;
      case ParticleState.fall:
        rotationMultiplier = 0.7;
        break;
    }

    // Apply rotation speed and acceleration
    particle.rotationSpeed += particle.rotationAcceleration;
    particle.rotation += particle.rotationSpeed * rotationMultiplier;

    // Add oscillation based on particle movement
    final velocityMagnitude = particle.velocity.distance;
    particle.rotation += sin(particle.stateTime * 5) * velocityMagnitude * 0.01;
  }

  void _applyFlutter(EnhancedConfettiParticle particle) {
    // Calculate flutter effect based on particle state
    double flutterStrength;

    switch (particle.state) {
      case ParticleState.launch:
        flutterStrength = 0.2;
        break;
      case ParticleState.burst:
        flutterStrength = 1.0;
        break;
      case ParticleState.float:
        flutterStrength = 0.8;
        break;
      case ParticleState.fall:
        flutterStrength = 0.4;
        break;
    }

    // Apply horizontal flutter using perlin noise
    final flutter = _perlinNoise(particle.stateTime * particle.flutterSpeed) *
        particle.flutterAmount *
        flutterStrength;

    particle.velocity += Offset(flutter, 0);
  }

  void _updatePosition(EnhancedConfettiParticle particle, Size size) {
    // Update position based on velocity
    particle.position += particle.velocity;

    // Add bezier curve influence
    final normalizedTime = particle.stateTime.clamp(0.0, 1.0);
    if (particle.state != ParticleState.fall) {
      final bezierPoint = _calculateBezierPoint(
          normalizedTime,
          particle.position,
          particle.controlPoint1,
          particle.controlPoint2,
          particle.position + Offset(0, size.height * 0.5));
      particle.position = particle.position * 0.9 + bezierPoint * 0.1;
    }
  }

  Offset _calculateBezierPoint(
      double t, Offset p0, Offset p1, Offset p2, Offset p3) {
    final u = 1 - t;
    final tt = t * t;
    final uu = u * u;
    final uuu = uu * u;
    final ttt = tt * t;

    return Offset(
        uuu * p0.dx + 3 * uu * t * p1.dx + 3 * u * tt * p2.dx + ttt * p3.dx,
        uuu * p0.dy + 3 * uu * t * p1.dy + 3 * u * tt * p2.dy + ttt * p3.dy);
  }

  double _calculateOpacity(EnhancedConfettiParticle particle) {
    double baseOpacity;

    switch (particle.state) {
      case ParticleState.launch:
        baseOpacity = particle.stateTime / options.launchDuration;
        break;
      case ParticleState.burst:
        baseOpacity = 1.0;
        break;
      case ParticleState.float:
        baseOpacity = 1.0;
        break;
      case ParticleState.fall:
        // Fade out during fall
        baseOpacity = 1.0 - (particle.stateTime / 2.0).clamp(0.0, 1.0);
        break;
    }

    // Add flickering effect
    final flicker = 0.9 + _perlinNoise(particle.stateTime * 10) * 0.1;
    return (baseOpacity * flicker).clamp(0.0, 1.0);
  }

  void _drawParticleShape(
      Canvas canvas, Paint paint, EnhancedConfettiParticle particle) {
    // Get shape path from factory
    final path = ParticleShapeFactory.getPath(particle.shape, particle.size);

    // Apply state-based transformations
    switch (particle.state) {
      case ParticleState.launch:
        // Stretch effect during launch
        canvas.scale(1.0, 1.0 + particle.velocity.distance * 0.02);
        break;
      case ParticleState.burst:
        // Scale effect during burst
        final scaleFactor = 1.0 + sin(particle.stateTime * 10) * 0.1;
        canvas.scale(scaleFactor, scaleFactor);
        break;
      case ParticleState.float:
        // Gentle pulsing during float
        final pulseFactor = 1.0 + sin(particle.stateTime * 3) * 0.05;
        canvas.scale(pulseFactor, pulseFactor);
        break;
      case ParticleState.fall:
        // No special transformation during fall
        break;
    }

    // Draw the shape
    canvas.drawPath(path, paint);

    // Add highlight effect
    if (particle.state == ParticleState.burst) {
      paint.color = paint.color.withOpacity(0.3);
      canvas.drawPath(
          path,
          paint
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var particle in particles) {
      _updateParticleState(particle, size);
      _updateParticlePhysics(particle, size);
      _renderParticle(canvas, paint, particle, size);
    }
  }

  void _updateParticleState(EnhancedConfettiParticle particle, Size size) {
    // State transition logic based on time and position
    particle.stateTime += 0.016; // Assuming 60fps

    // Update particle state based on timing
    if (particle.state == ParticleState.launch &&
        particle.stateTime >= options.launchDuration) {
      particle.state = ParticleState.burst;
      particle.stateTime = 0;
    } else if (particle.state == ParticleState.burst &&
        particle.stateTime >= options.burstDuration) {
      particle.state = ParticleState.float;
      particle.stateTime = 0;
    } else if (particle.state == ParticleState.float &&
        particle.stateTime >= options.floatDuration) {
      particle.state = ParticleState.fall;
      particle.stateTime = 0;
    }
  }

  void _updateParticlePhysics(EnhancedConfettiParticle particle, Size size) {
    // Physics calculations based on current state
    switch (particle.state) {
      case ParticleState.launch:
        _applyLaunchPhysics(particle);
        break;
      case ParticleState.burst:
        _applyBurstPhysics(particle);
        break;
      case ParticleState.float:
        _applyFloatPhysics(particle);
        break;
      case ParticleState.fall:
        _applyFallPhysics(particle);
        break;
    }

    // Apply common physics updates
    _applyRotation(particle);
    _applyFlutter(particle);
    _updatePosition(particle, size);
  }

  void _renderParticle(Canvas canvas, Paint paint,
      EnhancedConfettiParticle particle, Size size) {
    // Enhanced rendering with shadows and effects
    final opacity = _calculateOpacity(particle);
    paint.color = particle.color.withOpacity(opacity);

    canvas.save();
    canvas.translate(
      size.width * 0.5 + particle.position.dx,
      size.height * 0.5 + particle.position.dy,
    );
    canvas.rotate(particle.rotation);

    // Apply subtle shadow effect
    if (opacity > 0.3) {
      paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.5);
    }

    _drawParticleShape(canvas, paint, particle);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
