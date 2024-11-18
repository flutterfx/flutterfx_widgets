import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';

class AuroraPainter extends CustomPainter {
  final double progress;
  final bool isDark;
  final bool showRadialGradient;

  AuroraPainter({
    required this.progress,
    required this.isDark,
    required this.showRadialGradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    
    // Background color
    canvas.drawRect(
      rect,
      Paint()..color = isDark ? const Color(0xFF1A1A1A) : Colors.white,
    );

    // Create subtle vertical light streaks
    final streakPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(size.width * 0.8, 0),
        Offset(size.width * 0.8, size.height),
        [
          Colors.blue.withOpacity(0.1),
          Colors.purple.withOpacity(0.1),
          Colors.indigo.withOpacity(0.1),
        ],
        [0.2, 0.5, 0.8],
      )
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    // Draw multiple light streaks with different positions
    for (var i = 0; i < 5; i++) {
      final xPos = size.width * (0.5 + i * 0.1);
      canvas.drawRect(
        Rect.fromLTWH(xPos, 0, 40, size.height),
        streakPaint,
      );
    }

    // Radial gradient in the corner
    if (showRadialGradient) {
      final radialPaint = Paint()
        ..shader = ui.Gradient.radial(
          Offset(size.width, 0), // Top right corner
          size.width * 0.8,
          [
            Colors.blue.withOpacity(0.3),
            Colors.blue.withOpacity(0.1),
            Colors.transparent,
          ],
          [0.0, 0.5, 1.0],
        )
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

      canvas.drawRect(rect, radialPaint);
    }

    // Add subtle animated movement
    final movingGradient = Paint()
      ..shader = ui.Gradient.linear(
        Offset(size.width * progress, 0),
        Offset(size.width * progress + 100, size.height),
        [
          Colors.blue.withOpacity(0.05),
          Colors.purple.withOpacity(0.05),
        ],
        [0.0, 1.0],
      )
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);

    canvas.drawRect(rect, movingGradient);
  }

  @override
  bool shouldRepaint(AuroraPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class AuroraBackground extends StatefulWidget {
  final Widget child;
  final bool showRadialGradient;

  const AuroraBackground({
    Key? key,
    required this.child,
    this.showRadialGradient = true,
  }) : super(key: key);

  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: -0.2,
      end: 1.2,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
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
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                painter: AuroraPainter(
                  progress: _animation.value,
                  isDark: Theme.of(context).brightness == Brightness.dark,
                  showRadialGradient: widget.showRadialGradient,
                ),
                size: Size.infinite,
              );
            },
          ),
          Center(child: widget.child),
        ],
      ),
    );
  }
}

// Example usage with text content
class ExamplePage extends StatelessWidget {
  const ExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuroraBackground(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Background lights are\ncool you know.',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'And this, is chemical burn.',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Debug now',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}