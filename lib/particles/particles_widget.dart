import 'dart:math' as math;
import 'package:flutter/material.dart';

class Particles extends StatefulWidget {
  final int quantity;
  final double ease;
  final Color color;
  final double staticity;
  final double size;
  final double vx;
  final double vy;

  const Particles({
    Key? key,
    this.quantity = 100,
    this.ease = 50,
    required this.color,
    this.staticity = 50,
    this.size = 0.4,
    this.vx = 0,
    this.vy = 0,
  }) : super(key: key);

  @override
  State<Particles> createState() => _ParticlesState();
}

class _ParticlesState extends State<Particles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Particle> particles = [];
  Offset mousePosition = Offset.zero;
  Size canvasSize = Size.zero;
  final math.Random random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _controller.addListener(_updateParticles);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(Particles oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.color != widget.color) {
      _initParticles();
    }
  }

  void _initParticles() {
    particles.clear();
    for (int i = 0; i < widget.quantity; i++) {
      particles.add(_createParticle());
    }
  }

  Particle _createParticle() {
    return Particle(
      x: random.nextDouble() * canvasSize.width,
      y: random.nextDouble() * canvasSize.height,
      size: random.nextDouble() * 2 + widget.size,
      alpha: 0.0,
      targetAlpha: random.nextDouble() * 0.6 + 0.1,
      dx: (random.nextDouble() - 0.5) * 0.1,
      dy: (random.nextDouble() - 0.5) * 0.1,
      magnetism: 0.1 + random.nextDouble() * 4,
    );
  }

  void _updateParticles() {
    for (int i = 0; i < particles.length; i++) {
      final particle = particles[i];

      // Update position
      particle.x += particle.dx + widget.vx;
      particle.y += particle.dy + widget.vy;

      // Update translation based on mouse position
      final double targetTranslateX =
          mousePosition.dx / (widget.staticity / particle.magnetism);
      final double targetTranslateY =
          mousePosition.dy / (widget.staticity / particle.magnetism);

      particle.translateX +=
          (targetTranslateX - particle.translateX) / widget.ease;
      particle.translateY +=
          (targetTranslateY - particle.translateY) / widget.ease;

      // Handle alpha
      final double edge = _calculateClosestEdge(particle);
      final double remapEdge = _remapValue(edge, 0, 20, 0, 1).clamp(0.0, 1.0);

      if (remapEdge > 1) {
        particle.alpha += 0.02;
        if (particle.alpha > particle.targetAlpha) {
          particle.alpha = particle.targetAlpha;
        }
      } else {
        particle.alpha = particle.targetAlpha * remapEdge;
      }

      // Reset particle if out of bounds
      if (_isOutOfBounds(particle)) {
        particles[i] = _createParticle();
      }
    }
    setState(() {});
  }

  double _calculateClosestEdge(Particle particle) {
    final List<double> edges = [
      particle.x + particle.translateX - particle.size,
      canvasSize.width - particle.x - particle.translateX - particle.size,
      particle.y + particle.translateY - particle.size,
      canvasSize.height - particle.y - particle.translateY - particle.size,
    ];
    return edges.reduce(math.min);
  }

  double _remapValue(
      double value, double start1, double end1, double start2, double end2) {
    return ((value - start1) * (end2 - start2)) / (end1 - start1) + start2;
  }

  bool _isOutOfBounds(Particle particle) {
    return particle.x < -particle.size ||
        particle.x > canvasSize.width + particle.size ||
        particle.y < -particle.size ||
        particle.y > canvasSize.height + particle.size;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        canvasSize = Size(constraints.maxWidth, constraints.maxHeight);
        if (particles.isEmpty) {
          _initParticles();
        }

        return MouseRegion(
          onHover: (event) {
            final RenderBox box = context.findRenderObject() as RenderBox;
            final Offset localPosition = box.globalToLocal(event.position);
            mousePosition = Offset(
              localPosition.dx - canvasSize.width / 2,
              localPosition.dy - canvasSize.height / 2,
            );
          },
          child: CustomPaint(
            size: Size.infinite,
            painter: ParticlesPainter(
              particles: particles,
              color: widget.color,
            ),
          ),
        );
      },
    );
  }
}

class ParticlesPainter extends CustomPainter {
  final List<Particle> particles;
  final Color color;

  ParticlesPainter({
    required this.particles,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()
        ..color = color.withOpacity(particle.alpha)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(particle.translateX, particle.translateY);
      canvas.drawCircle(
        Offset(particle.x, particle.y),
        particle.size,
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ParticlesPainter oldDelegate) {
    return true;
  }
}

class Particle {
  double x;
  double y;
  double translateX;
  double translateY;
  double size;
  double alpha;
  double targetAlpha;
  double dx;
  double dy;
  double magnetism;

  Particle({
    required this.x,
    required this.y,
    this.translateX = 0,
    this.translateY = 0,
    required this.size,
    required this.alpha,
    required this.targetAlpha,
    required this.dx,
    required this.dy,
    required this.magnetism,
  });
}
