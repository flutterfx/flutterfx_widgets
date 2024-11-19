import 'package:flutter/material.dart';
import 'dart:math' as math;

class UnifiedStarAnimation extends StatefulWidget {
  final Color color;
  final double size;
  final Duration totalDuration;
  final VoidCallback? onAnimationComplete;

  const UnifiedStarAnimation({
    super.key,
    this.color = Colors.pink,
    this.size = 50.0,
    this.totalDuration = const Duration(milliseconds: 4800),
    this.onAnimationComplete,
  });

  @override
  State<UnifiedStarAnimation> createState() => _UnifiedStarAnimationState();
}

class _UnifiedStarAnimationState extends State<UnifiedStarAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Phase 1 animations (circle to star)
  late Animation<double> _starScale;
  late Animation<double> _circleRadius;
  late Animation<double> _circleOpacity;
  late Animation<double> _initialRotation;
  late Animation<double> _initialPosition;

  // Phase 2 animations (falling star)
  late Animation<double> _laterRotation;
  late Animation<double> _fallPosition;
  late Animation<double> _blurEffect;
  late Animation<double> _glowIntensity;
  late Animation<double> _stretchFactor;
  late Animation<double> _explosionProgress;
  late Animation<double> _particleSpread;

  // Particle system
  late List<Particle> _particles;
  final int particleCount = 12;

  double? _screenHeight;
  bool _isFirstPhase = true;

  @override
  void initState() {
    super.initState();
    _initializeParticles();
    _controller = AnimationController(
      duration: widget.totalDuration,
      vsync: this,
    );

    _controller.addListener(() {
      if (_controller.value >= 0.4) {
        if (_isFirstPhase) {
          setState(() {
            _isFirstPhase = false;
          });
        }
      } else {
        if (!_isFirstPhase) {
          setState(() {
            _isFirstPhase = true;
          });
        }
      }

      if (_controller.value >= 0.85) {
        widget.onAnimationComplete?.call();
      }
    });
  }

  void _initializeParticles() {
    _particles = List.generate(particleCount, (index) {
      final angle = (index * 2 * math.pi) / particleCount;
      return Particle(angle: angle);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenHeight = MediaQuery.of(context).size.height;
    _setupAnimations();
    _controller.forward();
  }

  void _setupAnimations() {
    if (_screenHeight == null) return;

    // Phase 1 Animations (0% - 40% of total duration)
    _starScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    ));

    _circleRadius = Tween<double>(
      begin: 0.0,
      end: widget.size * 0.20,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.25, curve: Curves.easeOut),
    ));

    _circleOpacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.25, 0.4, curve: Curves.easeOut),
    ));

    _initialRotation = Tween<double>(
      begin: 0.0,
      end: math.pi / 2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.4, curve: Curves.linear),
    ));

    _initialPosition = Tween<double>(
      begin: 0.0,
      end: -60.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    ));

    // Phase 2 Animations (40% - 100% of total duration)
    final fallStartY = -60.0 + MediaQuery.of(context).size.height * 0.5;
    final fallEndY = _screenHeight! - MediaQuery.of(context).padding.bottom;

    _laterRotation = Tween<double>(
      begin: math.pi / 2, // starts from where _initialRotation ended
      end: math.pi, // rotates another 90 degrees
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
    ));

    _fallPosition = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: fallStartY, end: fallEndY - 100)
            .chain(CurveTween(curve: Curves.easeInQuart)),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: fallEndY - 100, end: fallEndY - 50)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0),
    ));

    _blurEffect = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 25.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 25.0, end: 35.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0),
    ));

    _glowIntensity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.5, end: 1.0),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.5),
        weight: 30,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0),
    ));

    _stretchFactor = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 5.0),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 5.0, end: 1.0),
        weight: 30,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0),
    ));

    _explosionProgress = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.8, 1.0, curve: Curves.easeOutCubic),
    );

    _particleSpread = Tween<double>(
      begin: 0.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.8, 1.0, curve: Curves.easeOutCubic),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_screenHeight == null) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final screenWidth = MediaQuery.of(context).size.width;
        final xPosition = screenWidth / 2 - widget.size / 2;
        final yPosition = _isFirstPhase
            ? MediaQuery.of(context).size.height * 0.5 + _initialPosition.value
            : _fallPosition.value;

        return Positioned(
          left: xPosition,
          top: yPosition,
          child: SizedBox(
            width: widget.size *
                (1 + (_isFirstPhase ? 0 : _explosionProgress.value * 3)),
            height: widget.size *
                (1 + (_isFirstPhase ? 0 : _explosionProgress.value * 3)),
            child: _controller.value < 0.4
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.rotate(
                        angle: _initialRotation.value,
                        child: Transform.scale(
                          scale: _starScale.value,
                          child: CustomPaint(
                            size: Size(widget.size, widget.size),
                            painter: StarPainter(color: widget.color),
                          ),
                        ),
                      ),
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
                  )
                : CustomPaint(
                    painter: EnhancedStarPainter(
                      primaryColor: widget.color,
                      blur: _blurEffect.value,
                      rotation: _laterRotation.value,
                      stretchFactor: _stretchFactor.value,
                      explosionProgress: _explosionProgress.value,
                      particles: _particles,
                      particleSpread: _particleSpread.value,
                      glowIntensity: _glowIntensity.value,
                    ),
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

class Particle {
  final double angle;
  final double speed;
  final double size;

  Particle({
    required this.angle,
    this.speed = 1.0,
    this.size = 1.0,
  });
}

class EnhancedStarPainter extends CustomPainter {
  final Color primaryColor;
  final double blur;
  final double stretchFactor;
  final double explosionProgress;
  final List<Particle> particles;
  final double particleSpread;
  final double glowIntensity;
  final double rotation;

  EnhancedStarPainter({
    required this.primaryColor,
    required this.blur,
    required this.stretchFactor,
    required this.explosionProgress,
    required this.particles,
    required this.particleSpread,
    required this.glowIntensity,
    required this.rotation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final starPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur);

    // Enhanced base glow
    final glowPaint = Paint()
      ..color =
          primaryColor.withOpacity(glowIntensity * 0.7) // Increased opacity
      ..maskFilter =
          MaskFilter.blur(BlurStyle.normal, blur * 3); // Increased blur

    if (explosionProgress > 0) {
      // Draw bottom screen glow
      final screenGlowRect = Rect.fromLTWH(
          -size.width,
          size.height * 0.5,
          size.width * 3, // Wider to ensure full coverage
          size.height);

      final screenGlowGradient = RadialGradient(
        center: Alignment.topCenter,
        radius: 1.0,
        colors: [
          primaryColor.withOpacity(0.4 * explosionProgress),
          primaryColor.withOpacity(0.1 * explosionProgress),
          primaryColor.withOpacity(0),
        ],
        stops: const [0.0, 0.5, 1.0],
      );

      canvas.drawRect(screenGlowRect,
          Paint()..shader = screenGlowGradient.createShader(screenGlowRect));

      // Enhanced explosion effect
      final radius =
          size.width / 2 * (1 + explosionProgress * 2.5); // Increased radius

      // Outer glow
      canvas.drawCircle(
          center,
          radius,
          Paint()
            ..color = primaryColor.withOpacity(0.5 * (1 - explosionProgress))
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur * 3));

      // Enhanced particle trails
      for (var particle in particles) {
        final spread = radius * particleSpread;
        final dx = math.cos(particle.angle) * spread;
        final dy = math.sin(particle.angle) * spread;

        final path = Path()
          ..moveTo(center.dx, center.dy)
          ..lineTo(center.dx + dx, center.dy + dy);

        canvas.drawPath(
            path,
            Paint()
              ..color = primaryColor.withOpacity(0.9 * (1 - explosionProgress))
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3 // Increased width
              ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur * 1.5));
      }

      // Enhanced center glow
      canvas.drawCircle(
          center,
          radius * 0.4, // Increased center glow size
          glowPaint
            ..color = primaryColor.withOpacity(1.0 * (1 - explosionProgress)));
    } else {
      // Enhanced star glow
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.scale(1.0, stretchFactor);
      canvas.translate(-center.dx, -center.dy);

      final starPath = _createStarPath(center, size.width / 2 * 0.8);

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(rotation);
      canvas.translate(-center.dx, -center.dy);
      // Multiple layers of glow for increased brightness
      for (var i = 3; i > 0; i--) {
        canvas.drawPath(
            starPath,
            Paint()
              ..color = primaryColor.withOpacity(glowIntensity * 0.3)
              ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur * i));
      }
      canvas.drawPath(starPath, glowPaint);
      canvas.drawPath(starPath, starPaint);
      canvas.restore();

      canvas.restore();
    }
  }

  Path _createStarPath(Offset center, double radius) {
    final path = Path();
    for (int i = 0; i < 4; i++) {
      final angle = (i * math.pi / 2);
      final x = center.dx + math.cos(angle) * radius;
      final y = center.dy + math.sin(angle) * radius;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final controlX =
            center.dx + math.cos(angle - math.pi / 4) * (radius * 0.5);
        final controlY =
            center.dy + math.sin(angle - math.pi / 4) * (radius * 0.5);
        path.quadraticBezierTo(controlX, controlY, x, y);
      }
    }

    final lastControlX = center.dx + math.cos(-math.pi / 4) * (radius * 0.5);
    final lastControlY = center.dy + math.sin(-math.pi / 4) * (radius * 0.5);
    path.quadraticBezierTo(
        lastControlX, lastControlY, center.dx + radius, center.dy);

    return path;
  }

  @override
  bool shouldRepaint(EnhancedStarPainter oldDelegate) => true;
}

// Usage Example:
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: const [
          UnifiedStarAnimation(
            size: 50,
            color: Colors.pink,
            totalDuration: Duration(milliseconds: 4800),
          ),
        ],
      ),
    );
  }
}
