import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:fx_2_folder/fx_14_text_reveal/text_reveal_widget.dart';

class FancySpringStrategy extends BaseAnimationStrategy {
  final double maxOffset;
  final double maxRotation;
  final double minScale;
  final bool enableRandomColors;
  final SpringDescription springDescription;
  final bool enableBlur;
  final double maxBlur;

  const FancySpringStrategy({
    this.maxOffset = 50.0,
    this.maxRotation = 45.0,
    this.minScale = 0.3,
    this.enableRandomColors = false,
    this.enableBlur = true,
    this.maxBlur = 14.0,
    SpringDescription? spring,
  })  : springDescription = spring ??
            const SpringDescription(
              mass: 0.8,
              stiffness: 300,
              damping: 10,
            ),
        super(synchronizeAnimation: false);

  // Generate random color
  Color _getRandomColor() {
    final random = math.Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
  }

  @override
  Widget buildAnimatedCharacter({
    required String character,
    required Animation<double> animation,
    TextStyle? style,
  }) {
    // Generate random values once per character
    final random = math.Random();
    final initialY = (random.nextDouble() * 2 - 1) * maxOffset;
    final initialRotation = (random.nextDouble() * 2 - 1) * maxRotation;
    final initialColor = _getRandomColor();
    final targetColor = _getRandomColor();

    return ValueListenableBuilder<double>(
      valueListenable: animation,
      builder: (context, value, _) {
        // Create spring curve for smooth animation
        final springCurve = SpringSimulation(
          springDescription,
          0, // starting point
          1, // ending point
          0, // initial velocity
        );

        // Apply spring physics to the animation value
        final springValue = springCurve.x(value);

        // Interpolate between initial and final values
        final currentY = initialY * (1 - springValue);
        final currentRotation = initialRotation * (1 - springValue);
        final currentScale = minScale + (1 - minScale) * springValue;

        // Color interpolation
        final currentColor = Color.lerp(
          initialColor,
          targetColor,
          springValue,
        );

        Widget child = Text(
          character,
          style: style?.copyWith(
            color: enableRandomColors ? currentColor : style?.color,
          ),
        );

        // Apply blur effect if enabled
        if (enableBlur) {
          final blurAmount = (1 - springValue) * maxBlur;
          child = ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: blurAmount,
              sigmaY: blurAmount,
            ),
            child: child,
          );
        }

        // Apply all transformations
        return Transform(
          transform: Matrix4.identity()
            ..translate(0.0, currentY)
            ..rotateZ(currentRotation * math.pi / 180)
            ..scale(currentScale),
          alignment: Alignment.center,
          child: Opacity(
            opacity: springValue.clamp(0.0, 1.0), // clamp between 0.0 and 1.0
            child: child,
          ),
        );
      },
    );
  }

  @override
  Animation<double> createAnimation({
    required AnimationController controller,
    required double startTime,
    required double endTime,
    required Curve curve,
  }) {
    // Use a custom curve that combines spring physics with easing
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          startTime,
          endTime,
          curve: Curves.easeOutBack, // Adds a slight overshoot effect
        ),
      ),
    );
  }
}
