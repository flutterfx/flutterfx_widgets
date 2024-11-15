import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedWaveRipple extends StatefulWidget {
  final double size;
  final Duration duration;
  final double opacity;

  const AnimatedWaveRipple({
    Key? key,
    this.size = 300,
    this.duration = const Duration(seconds: 2),
    this.opacity = 0.5,
  }) : super(key: key);

  @override
  State<AnimatedWaveRipple> createState() => _AnimatedWaveRippleState();
}

class _AnimatedWaveRippleState extends State<AnimatedWaveRipple>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Color generation method based on the CSS implementation
  Color getColorForPosition(int index, double animationValue) {
    // CSS uses hue animation from 350 to 40
    double startHue = 350.0;
    double endHue = 40.0;

    // Calculate position-based offset for each ellipse
    // This creates a gradient effect across the ellipses
    final basePosition = index / 9.0; // 0 to 1 based on position

    // Add animation value and handle wraparound
    double offsetValue = (basePosition - animationValue) % 1.0;
    if (offsetValue < 0) offsetValue += 1.0;

    // Calculate current hue based on animation value and position
    double currentHue = lerpDouble(startHue, endHue, offsetValue);

    // Convert HSL to Color with saturation: 85%, lightness: 58%
    final hslColor = HSLColor.fromAHSL(
      widget.opacity,
      currentHue,
      0.85,
      0.58,
    );

    return hslColor.toColor();
  }

  // Linear interpolation helper
  double lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }

  // Colors with opacity
  List<Color> getTranslucentColors() {
    // Base colors without opacity
    final baseColors = [
      const Color(0xFFFFF6E5), // Layer 0 - Lightest Yellow
      const Color(0xFFFFEB3B), // Layer 1 - Yellow
      const Color(0xFF9CCC65), // Layer 2 - Light Green
      const Color(0xFF80CBC4), // Layer 3 - Teal
      const Color(0xFF4FC3F7), // Layer 4 - Light Blue
      const Color(0xFF7986CB), // Layer 5 - Blue Purple
      const Color(0xFF9575CD), // Layer 6 - Purple
      const Color(0xFFBA68C8), // Layer 7 - Light Purple
      const Color(0xFFEC407A), // Layer 8 - Pink
      const Color(0xFFFFCDD2), // Layer 9 - Light Pink
    ];

    // Convert opacity (0.0 to 1.0) to alpha value (0 to 255)
    final alpha = (widget.opacity * 255).round();

    // Apply opacity to each color
    return baseColors.map((color) => color.withAlpha(alpha)).toList();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Calculate size multiplier for spherical appearance with entry/exit animations
  double getSizeMultiplier(double position) {
    // Add entry/exit transitions at the top and bottom
    if (position < 0.1) {
      // Entry animation at the top (0.0 to 0.1)
      return lerpDouble(0.0, getBaseSize(0.1), position / 0.1);
    } else if (position > 0.9) {
      // Exit animation at the bottom (0.9 to 1.0)
      return lerpDouble(getBaseSize(0.9), 0.0, (position - 0.9) / 0.1);
    }
    return getBaseSize(position);
  }

  // Base size calculation without entry/exit animations
  double getBaseSize(double position) {
    // Convert position to angle in radians (-π/2 to π/2)
    final angle = (position) * math.pi - (math.pi / 2);

    // Use cosine for spherical distribution
    final baseSize = math.cos(angle);

    // Scale between minimum and maximum size
    const minSize = 0.4;
    const maxSize = 1.0;
    return minSize + (baseSize * (maxSize - minSize));
  }

  // Linear interpolation helper
  // double lerpDouble(double a, double b, double t) {
  //   return a + (b - a) * t;
  // }

  // Calculate height multiplier with entry/exit animations
  double getHeightMultiplier(double position) {
    if (position < 0.1) {
      // Entry animation
      return lerpDouble(0.05, getBaseHeight(0.1), position / 0.1);
    } else if (position > 0.9) {
      // Exit animation
      return lerpDouble(getBaseHeight(0.9), 0.05, (position - 0.9) / 0.1);
    }
    return getBaseHeight(position);
  }

  // Base height calculation without entry/exit animations
  double getBaseHeight(double position) {
    // Convert position to angle (-π/2 to π/2)
    final angle = position * math.pi - (math.pi / 2);

    // Use cosine for spherical curve
    final baseHeight = math.cos(angle);

    // Scale the height to maintain spherical appearance
    const minHeight = 0.15;
    const maxHeight = 0.25;
    return minHeight + (baseHeight * (maxHeight - minHeight));
  }

  // Calculate vertical position with animation
  double getVerticalPosition(double basePosition, double animationValue) {
    // Adjust the position based on the animation value
    double position = (basePosition - animationValue) % 1.0;
    if (position < 0) position += 1.0;

    // Calculate the vertical spacing
    final spacing = widget.size / 11;
    return spacing + (position * widget.size * 9 / 11);
  }

  // Calculate opacity based on position
  double getOpacity(double position) {
    if (position < 0.1) {
      // Fade in at the top
      return position / 0.1;
    } else if (position > 0.9) {
      // Fade out at the bottom
      return 1.0 - ((position - 0.9) / 0.1);
    }
    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: List.generate(10, (index) {
              final color = getColorForPosition(index, _controller.value);
              // Calculate the base position (0-1)
              final basePosition = index / 9.0;

              // Get the animated position
              final animatedPosition = (basePosition - _controller.value) % 1.0;

              // Calculate size multiplier based on current animated position
              final sizeMultiplier = getSizeMultiplier(animatedPosition);

              // Calculate width
              final maxWidth = widget.size * 0.95;
              final width = maxWidth * sizeMultiplier;

              // Calculate height with dynamic multiplier
              final height = width * getHeightMultiplier(animatedPosition);

              // Calculate vertical position with animation
              final verticalPosition =
                  getVerticalPosition(basePosition, _controller.value);

              // Calculate opacity for fade in/out
              final opacity = getOpacity(animatedPosition);

              return Positioned(
                top: verticalPosition - (height / 2),
                child: Opacity(
                  opacity: opacity,
                  child: CustomPaint(
                    painter: EllipsePainter(
                      color: color,
                    ),
                    size: Size(width, height),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

class EllipsePainter extends CustomPainter {
  final Color color;

  EllipsePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width,
      height: size.height,
    );

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawOval(rect, paint);
  }

  @override
  bool shouldRepaint(covariant EllipsePainter oldDelegate) {
    return color != oldDelegate.color;
  }
}

// Example usage
class RippleDemo extends StatelessWidget {
  const RippleDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedWaveRipple(
          size: 100,
          duration: Duration(seconds: 3),
          opacity: 0.75,
        ),
      ),
    );
  }
}
