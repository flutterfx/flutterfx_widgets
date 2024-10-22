// Flying Characters Strategy
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fx_2_folder/fx_14_text_reveal/text_reveal_widget.dart';

class FlyingCharactersStrategy extends BaseAnimationStrategy {
  final double maxOffset;
  final bool randomDirection;
  final double angle;
  final bool enableBlur; // New property for blur effect
  final double maxBlur; // Maximum blur amount

  const FlyingCharactersStrategy({
    this.maxOffset = 100.0,
    this.randomDirection = true,
    this.angle = pi / 2,
    this.enableBlur = false, // Disabled by default
    this.maxBlur = 8.0, // Default blur amount
  }) : super();

  @override
  Widget buildAnimatedCharacter({
    required String character,
    required Animation<double> animation,
    TextStyle? style,
  }) {
    return ValueListenableBuilder<double>(
      valueListenable: animation,
      builder: (context, value, _) {
        final actualAngle =
            randomDirection ? (Random().nextDouble() * 2 * pi) : angle;
        final offset = maxOffset * (1 - value);

        Widget child = Text(character, style: style);

        // Apply blur if enabled
        if (enableBlur) {
          child = ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: (1 - value) * maxBlur,
              sigmaY: (1 - value) * maxBlur,
            ),
            child: child,
          );
        }

        // Apply translation and opacity
        return Transform.translate(
          offset: Offset(
            cos(actualAngle) * offset,
            sin(actualAngle) * offset,
          ),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
    );
  }
}
