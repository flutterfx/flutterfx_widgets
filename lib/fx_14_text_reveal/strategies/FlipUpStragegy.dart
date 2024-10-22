import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fx_2_folder/fx_14_text_reveal/text_reveal_widget.dart';

class FlipUpStrategy extends BaseAnimationStrategy {
  final double rotationAngle; // Maximum rotation angle in radians
  final double
      perspectiveValue; // Controls the intensity of the perspective effect

  const FlipUpStrategy({
    this.rotationAngle = -pi / 2, // Start flat (-90 degrees)
    this.perspectiveValue = 0.003,
    super.synchronizeAnimation = false,
  });

  @override
  Widget buildAnimatedCharacter({
    required String character,
    required Animation<double> animation,
    TextStyle? style,
  }) {
    return ValueListenableBuilder<double>(
      valueListenable: animation,
      builder: (context, value, _) {
        // Simple rotation calculation
        final double currentRotation = rotationAngle * (1 - value);

        // Simple transform with just perspective and rotation
        final transform = Matrix4.identity()
          ..setEntry(3, 2, perspectiveValue)
          ..rotateX(currentRotation);

        return Transform(
          transform: transform,
          alignment: Alignment.bottomCenter,
          child: Text(character, style: style),
          // Opacity(
          //   opacity: value.clamp(0.0, 1.0),
          //   child:
          // ),
        );
      },
    );
  }
}
