import 'package:flutter/material.dart';
import 'dart:math' as math;

class FallingStarWidget extends StatefulWidget {
  final double startY;
  final Color primaryColor;
  final double size;
  final double maxStretch;

  const FallingStarWidget({
    Key? key,
    required this.startY,
    required this.primaryColor,
    this.size = 30,
    this.maxStretch = 5.0,
  }) : super(key: key);

  @override
  State<FallingStarWidget> createState() => _FallingStarWidgetState();
}

class _FallingStarWidgetState extends State<FallingStarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _positionAnimation;
  late Animation<double> _blurAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _stretchAnimation;
  late Animation<double> _explosionProgress;
  late Animation<double> _particleSpread;
  late List<Particle> _particles;
  double? _screenWidth;
  double? _screenHeight;

  final int particleCount = 12;

  @override
  void initState() {
    super.initState();
    _initializeParticles();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mediaQuery = MediaQuery.of(context);
    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;
    _setupAnimations();
    _controller.forward();
  }

  void _initializeParticles() {
    _particles = List.generate(particleCount, (index) {
      final angle = (index * 2 * math.pi) / particleCount;
      return Particle(angle: angle);
    });
  }

  void _setupAnimations() {
    if (_screenHeight == null) return;

    final endY = _screenHeight! - MediaQuery.of(context).padding.bottom;

    // Increased duration for better effect visibility
    _controller.duration = const Duration(milliseconds: 3500);

    _positionAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: widget.startY, end: endY - 100)
            .chain(CurveTween(curve: Curves.easeInQuart)),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: endY - 100, end: endY - 50)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
    ]).animate(_controller);

    // Increased blur values for more glow
    _blurAnimation = TweenSequence<double>([
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
    ]).animate(_controller);

    // Increased glow intensity
    _glowAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.5, end: 1.0),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.5),
        weight: 30,
      ),
    ]).animate(_controller);

    // Rest of the animations remain the same
    _stretchAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: widget.maxStretch),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: widget.maxStretch, end: 1.0),
        weight: 30,
      ),
    ]).animate(_controller);

    _explosionProgress = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.7, 1.0, curve: Curves.easeOutCubic),
    );

    _particleSpread = Tween<double>(
      begin: 0.0,
      end: 1.2, // Increased spread
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.7, 1.0, curve: Curves.easeOutCubic),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_screenWidth == null || _screenHeight == null)
      return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: _screenWidth! / 2 - widget.size / 2,
          top: _positionAnimation.value,
          child: Container(
            width: widget.size * (1 + _explosionProgress.value * 3),
            height: widget.size * (1 + _explosionProgress.value * 3),
            child: CustomPaint(
              painter: EnhancedStarPainter(
                primaryColor: widget.primaryColor,
                blur: _blurAnimation.value,
                stretchFactor: _stretchAnimation.value,
                explosionProgress: _explosionProgress.value,
                particles: _particles,
                particleSpread: _particleSpread.value,
                glowIntensity: _glowAnimation.value,
              ),
            ),
          ),
        );
      },
    );
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

  EnhancedStarPainter({
    required this.primaryColor,
    required this.blur,
    required this.stretchFactor,
    required this.explosionProgress,
    required this.particles,
    required this.particleSpread,
    required this.glowIntensity,
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

      final starPath = _createStarPath(center, size.width * 0.3);

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

// Usage
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FallingStarWidget(
            startY: 100,
            primaryColor: Colors.blue,
            size: 30,
          ),
        ],
      ),
    );
  }
}
