import 'package:flutter/material.dart';
import 'dart:math' as math;

class RetroGridBackground extends StatefulWidget {
  final double angle;
  final Widget? child;

  const RetroGridBackground({
    Key? key,
    this.angle = 65,
    this.child,
  }) : super(key: key);

  @override
  State<RetroGridBackground> createState() => _RetroGridBackgroundState();
}

class _RetroGridBackgroundState extends State<RetroGridBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _gridAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();

    _gridAnimation = Tween<double>(
      begin: 0.0, // Start position
      end: 1.0, // End position
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);

        return Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              // Perspective Grid
              Positioned(
                bottom: 0, // Position grid below the bottom
                left: 0,
                right: 0,
                top: 0,

                child: AnimatedBuilder(
                  animation: _gridAnimation,
                  builder: (context, child) => Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.004) // Adjusted perspective
                      ..rotateX(-30 *
                          math.pi /
                          180) // Adjusted angle for better bottom alignment
                      ..scale(2.0, 2.0, 2.0),
                    alignment: Alignment.bottomCenter,
                    child: CustomPaint(
                      size: Size(size.width, size.height),
                      painter: GridPainter(
                        offset: _gridAnimation.value,
                        isDark: isDark,
                      ),
                    ),
                  ),
                ),
              ),

              // Gradient Overlay
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [
                        Colors.transparent,
                        isDark
                            ? Colors.black.withOpacity(0.95)
                            : Colors.white.withOpacity(0.95),
                      ],
                      stops: const [0.6, 0.8], // Adjusted stops for better fade
                    ),
                  ),
                ),
              ),

              // Content
              if (widget.child != null)
                Center(
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFFFFD319),
                        Color(0xFFFF2975),
                        Color(0xFF8C1EFF),
                      ],
                    ).createShader(bounds),
                    child: widget.child!,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class GridPainter extends CustomPainter {
  final double offset;
  final bool isDark;
  final double gridSize = 40.0; // Increased grid size for better visibility

  GridPainter({
    required this.offset,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color =
          isDark ? Colors.white.withOpacity(0.3) : Colors.black.withOpacity(0.4)
      ..strokeWidth = 1.5;

    // Calculate grid lines with animation offset
    final verticalLines = (size.width / gridSize).ceil() + 1;
    final horizontalLines = (size.height / gridSize).ceil() + 1;

    // Draw vertical lines
    for (var i = 0; i < verticalLines; i++) {
      final x = i * gridSize;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines with animation
    for (var i = 0; i < horizontalLines; i++) {
      final y =
          (i * gridSize) - (offset * gridSize * 2); // Modified animation offset
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) =>
      offset != oldDelegate.offset || isDark != oldDelegate.isDark;
}

// Usage Example
class RetroGridDemo extends StatelessWidget {
  const RetroGridDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const RetroGridBackground(
      child: Text(
        'Grid in Motion',
        style: TextStyle(
          fontSize: 42,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Will be masked by gradient
        ),
      ),
    );
  }
}
