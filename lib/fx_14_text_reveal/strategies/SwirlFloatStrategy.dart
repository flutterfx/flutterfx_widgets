//Swirl float that floats up like a balloon.
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fx_2_folder/fx_14_text_reveal/text_reveal_widget.dart';

//Swirl float that floats up like a balloon.
class SwirlFloatStrategy extends BaseAnimationStrategy {
  final double yOffset; // Fixed Y offset for floating
  final double maxXDeviation; // Maximum random X deviation
  final double maxBlur; // Maximum blur amount
  final bool enableBlur; // Toggle blur effect
  final double curveIntensity; // Controls the intensity of the S curve

  const SwirlFloatStrategy({
    this.yOffset = 50.0,
    this.maxXDeviation = 20.0,
    this.maxBlur = 8.0,
    this.enableBlur = true,
    this.curveIntensity = 0.5, // 0.5 means medium curve intensity
    super.synchronizeAnimation = false,
  });

  @override
  Widget buildAnimatedCharacter({
    required String character,
    required Animation<double> animation,
    TextStyle? style,
  }) {
    // Generate random values once per character
    final random = Random();
    final xDeviation = (random.nextDouble() * 2 - 1) * maxXDeviation;

    final yDeviation =
        random.nextDouble() * yOffset.abs() * (yOffset >= 0 ? 1 : -1);

    return ValueListenableBuilder<double>(
      valueListenable: animation,
      builder: (context, value, _) {
        // Calculate the position along the S curve
        final position = _calculateSCurvePosition(
            value, xDeviation, yDeviation, curveIntensity);

        // Calculate scale based on animation value
        final scale = value;

        Widget child = Text(character, style: style);

        if (enableBlur) {
          if (enableBlur) {
            final blurThreshold = 0.1;
            final blurProgress = value < blurThreshold
                ? maxBlur
                : maxBlur *
                    (1 - ((value - blurThreshold) / (1 - blurThreshold)));

            child = ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: blurProgress,
                sigmaY: blurProgress,
              ),
              child: child,
            );
          }
        }

        // Apply all transformations
        return Transform.translate(
          offset: position,
          child: Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: value,
              child: child,
            ),
          ),
        );
      },
    );
  }

  Offset _calculateSCurvePosition(
      double t, double targetX, double targetY, double intensity) {
    // For the S curve, we use a combination of sine waves
    // This creates a smooth S-shaped path from start to end

    // Reverse the progress for exit animation if t > 1
    final progress = t <= 1 ? 1 - t : t - 1;

    // Calculate Y position with easing
    final y = targetY * progress;

    // Calculate X position using sine wave for S-curve effect
    // The sine wave is amplified in the middle and reduces at the ends
    final xWave = sin(progress * pi * 2) * intensity;
    final xProgress = progress * (1 - progress) * 4; // Peaks at 0.5
    final x = targetX * progress + (xWave * xProgress * targetX);

    return Offset(x, y);
  }

  @override
  Animation<double> createAnimation({
    required AnimationController controller,
    required double startTime,
    required double endTime,
    required Curve curve,
  }) {
    // Use a custom curve that combines with our S-curve calculation
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          startTime,
          endTime,
          curve: Curves.easeInOutCubic, // Smooth acceleration and deceleration
        ),
      ),
    );
  }
}
