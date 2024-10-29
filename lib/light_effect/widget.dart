import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class LightEffectWidget extends StatelessWidget {
  final double width;
  final double height;
  final Color backgroundColor;
  final Color lightColor;

  const LightEffectWidget({
    Key? key,
    this.width = 300,
    this.height = 200,
    this.backgroundColor = Colors.black,
    this.lightColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: backgroundColor,
      child: Stack(
        children: [
          // Top light effect
          CustomPaint(
            size: Size(width, height / 2),
            painter: TopLightEffectPainter(
              lightColor: lightColor,
              backgroundColor: backgroundColor,
            ),
          ),
          // Bottom reflection with blur
          Positioned(
            top: height / 2,
            child: Transform(
              transform: Matrix4.identity()
                ..scale(1.0, -1.0), // Flip vertically
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size(width, height / 2),
                    painter: TopLightEffectPainter(
                      lightColor: lightColor.withOpacity(0.3),
                      backgroundColor: backgroundColor,
                    ),
                  ),
                  ClipRect(
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(
                        sigmaX: 3.0,
                        sigmaY: 3.0,
                      ),
                      child: Container(
                        width: width,
                        height: height / 2,
                        color: backgroundColor.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TopLightEffectPainter extends CustomPainter {
  final Color lightColor;
  final Color backgroundColor;

  TopLightEffectPainter({
    required this.lightColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    // Create the angular gradient
    final Gradient gradient = SweepGradient(
      center: Alignment.topCenter,
      startAngle: 3.14159, // PI
      endAngle: 6.28318, // 2*PI
      colors: [
        backgroundColor,
        lightColor.withOpacity(0.8),
        lightColor.withOpacity(0.9),
        lightColor.withOpacity(0.8),
        backgroundColor,
      ],
      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
      transform: GradientRotation(-1.5708), // -PI/2
    );

    // Apply the gradient with a custom shader
    paint.shader = gradient.createShader(
      Rect.fromLTWH(
        -size.width * 0.5,
        -size.height * 0.5,
        size.width * 2,
        size.height * 2,
      ),
    );

    // Draw the main shape
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );

    // Add fade out effect at the bottom
    final Paint fadePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          backgroundColor.withOpacity(0.0),
          backgroundColor.withOpacity(0.2),
        ],
      ).createShader(
          Rect.fromLTWH(0, size.height * 0.7, size.width, size.height * 0.3));

    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.7, size.width, size.height * 0.3),
      fadePaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
