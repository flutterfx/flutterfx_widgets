import 'package:flutter/material.dart';
import 'dart:math' as math;

class TextShiningDemo extends StatelessWidget {
  const TextShiningDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4338CA), // Deep indigo
              Color(0xFF6366F1), // Bright indigo
              Color(0xFF818CF8), // Light indigo
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            const GridBackground(),
            BackgroundShimmerEffect(), // New animated background
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 30, // Increased elevation
                    shadowColor: Colors.black26, // Darker shadow
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(32), // Increased radius
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 56.0,
                        vertical: 48.0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        gradient: LinearGradient(
                          // Added gradient
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.95),
                            Colors.white.withOpacity(0.90),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6366F1).withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          AnimatedIconContainer(), // New animated container
                          const SizedBox(height: 32),
                          ShimmerText(
                            text: "Welcome to Flutter",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: const Color(0xFF1E293B),
                                  fontWeight: FontWeight.w800, // Bolder text
                                  letterSpacing: 0.5, // Added letter spacing
                                ),
                            shimmerColors: const [
                              // Custom shimmer colors
                              Color(0xFF64748B),
                              Color(0xFF818CF8),
                              Color(0xFF64748B),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ShimmerText(
                            text: "Create something magical ✨",
                            shimmerWidth: 200, // Increased width
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: const Color(0xFF64748B),
                                  height: 1.5,
                                  letterSpacing: 0.3,
                                  fontSize: 18,
                                ),
                            shimmerColors: const [
                              // Custom shimmer colors
                              Color(0xFF64748B),
                              Color(0xFF818CF8),
                              Color(0xFF64748B),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedIconContainer extends StatefulWidget {
  @override
  State<AnimatedIconContainer> createState() => _AnimatedIconContainerState();
}

class _AnimatedIconContainerState extends State<AnimatedIconContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _rotateAnimation = Tween<double>(begin: -0.05, end: 0.05)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotateAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF6366F1).withOpacity(0.2),
                    const Color(0xFF818CF8).withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome,
                size: 48,
                color: Color(0xFF6366F1),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ShimmerText extends StatefulWidget {
  final String text;
  final double? shimmerWidth;
  final TextStyle? style;
  final List<Color> shimmerColors;

  const ShimmerText({
    Key? key,
    required this.text,
    this.shimmerWidth = 100.0,
    this.style,
    this.shimmerColors = const [
      Color(0xFF1E293B),
      Color(0xFF818CF8),
      Color(0xFF1E293B),
    ],
  }) : super(key: key);

  @override
  State<ShimmerText> createState() => _ShimmerTextState();
}

class _ShimmerTextState extends State<ShimmerText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500), // Faster animation
      vsync: this,
    );
    _startAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() async {
    while (mounted) {
      await _controller.forward();
      await Future.delayed(const Duration(milliseconds: 200)); // Shorter pause
      _controller.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: widget.shimmerColors,
              stops: const [0.0, 0.5, 1.0],
              transform: _SlidingGradientTransform(
                percent: _controller.value,
                width: widget.shimmerWidth ?? 100.0,
              ),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcIn,
          child: Text(
            widget.text,
            style: widget.style,
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}

class BackgroundShimmerEffect extends StatefulWidget {
  @override
  State<BackgroundShimmerEffect> createState() =>
      _BackgroundShimmerEffectState();
}

class _BackgroundShimmerEffectState extends State<BackgroundShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ShimmerBackgroundPainter(
            animation: _controller.value,
          ),
          child: Container(),
        );
      },
    );
  }
}

class ShimmerBackgroundPainter extends CustomPainter {
  final double animation;

  ShimmerBackgroundPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF6366F1).withOpacity(0.1),
          const Color(0xFF818CF8).withOpacity(0.2),
          const Color(0xFF6366F1).withOpacity(0.1),
        ],
        stops: const [0.0, 0.5, 1.0],
        transform: GradientRotation(animation * 2 * math.pi),
      ).createShader(Offset.zero & size);

    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(ShimmerBackgroundPainter oldDelegate) =>
      oldDelegate.animation != animation;
}

// Original GridPainter and other supporting classes remain the same...

class GridBackground extends StatelessWidget {
  const GridBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GridPainter(),
      child: Container(),
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({
    required this.percent,
    required this.width,
  });

  final double percent;
  final double width;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(
      bounds.width * (percent * 2.0 - 1.0),
      0.0,
      0.0,
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6366F1).withOpacity(0.07)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const gridSize = 32.0; // Slightly smaller grid
    final horizontalLines = (size.height / gridSize).ceil();
    final verticalLines = (size.width / gridSize).ceil();

    for (var i = 0; i <= horizontalLines; i++) {
      final y = i * gridSize;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    for (var i = 0; i <= verticalLines; i++) {
      final x = i * gridSize;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    final random = math.Random(42);
    final dotPaint = Paint()
      ..color = const Color(0xFF6366F1).withOpacity(0.15)
      ..style = PaintingStyle.fill;

    for (var i = 0; i <= verticalLines; i++) {
      for (var j = 0; j <= horizontalLines; j++) {
        if (random.nextDouble() < 0.08) {
          // Slightly fewer dots
          canvas.drawCircle(
            Offset(i * gridSize, j * gridSize),
            2.5, // Slightly larger dots
            dotPaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
