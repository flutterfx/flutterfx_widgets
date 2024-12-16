import 'package:flutter/material.dart';
import 'dart:math' as math;

class LayeredAnimationDemo extends StatefulWidget {
  const LayeredAnimationDemo({Key? key}) : super(key: key);

  @override
  State<LayeredAnimationDemo> createState() => _LayeredAnimationDemoState();
}

class _LayeredAnimationDemoState extends State<LayeredAnimationDemo>
    with TickerProviderStateMixin {
  late final AnimationController _backgroundController;
  late final AnimationController _middleController;
  late final AnimationController _frontController;

  late final Animation<double> _backgroundRotation;
  late final Animation<double> _middleScale;
  late final Animation<double> _frontTranslation;

  @override
  void initState() {
    super.initState();

    // Background rotation animation
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _backgroundRotation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(_backgroundController);

    // Middle layer scale animation
    _middleController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _middleScale = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _middleController,
      curve: Curves.easeInOut,
    ));

    // Front layer translation animation
    _frontController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _frontTranslation = Tween<double>(
      begin: -50.0,
      end: 50.0,
    ).animate(CurvedAnimation(
      parent: _frontController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _middleController.dispose();
    _frontController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        height: 300,
        child: Stack(
          children: [
            // Background layer - rotating circles
            AnimatedBuilder(
              animation: _backgroundRotation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _backgroundRotation.value,
                  child: CustomPaint(
                    size: const Size(300, 300),
                    painter: CirclePatternPainter(),
                  ),
                );
              },
            ),

            // Middle layer - pulsing squares
            AnimatedBuilder(
              animation: _middleScale,
              builder: (context, child) {
                return Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001) // Add perspective
                    ..translate(0.0, 0.0, 50.0) // Move forward in z-axis
                    ..scale(_middleScale.value),
                  alignment: Alignment.center,
                  child: CustomPaint(
                    size: const Size(300, 300),
                    painter: SquarePatternPainter(),
                  ),
                );
              },
            ),

            // Front layer - floating diamonds
            AnimatedBuilder(
              animation: _frontTranslation,
              builder: (context, child) {
                return Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..translate(
                      _frontTranslation.value,
                      _frontTranslation.value,
                      100.0, // Even further forward in z-axis
                    ),
                  alignment: Alignment.center,
                  child: CustomPaint(
                    size: const Size(300, 300),
                    painter: DiamondPatternPainter(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Background layer painter
class CirclePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    for (var i = 0; i < 6; i++) {
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        20.0 + (i * 20.0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CirclePatternPainter oldDelegate) => false;
}

// Middle layer painter
class SquarePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.purple.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    for (var i = 0; i < 4; i++) {
      final rect = Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: 40.0 + (i * 40.0),
        height: 40.0 + (i * 40.0),
      );
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(SquarePatternPainter oldDelegate) => false;
}

// Front layer painter
class DiamondPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    for (var i = 0; i < 3; i++) {
      final path = Path();
      final size = 30.0 + (i * 30.0);

      path.moveTo(150, 150 - size); // top
      path.lineTo(150 + size, 150); // right
      path.lineTo(150, 150 + size); // bottom
      path.lineTo(150 - size, 150); // left
      path.close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(DiamondPatternPainter oldDelegate) => false;
}
