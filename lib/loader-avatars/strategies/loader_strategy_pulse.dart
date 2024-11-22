import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fx_2_folder/loader-avatars/loader_avatars.dart';

class PulseAnimationStrategy extends AvatarAnimationStrategy {
  final Duration animationDuration;
  final double baseScale;
  final double scaleAmount;
  final double waveWidth;
  final double phaseShiftFactor;

  PulseAnimationStrategy({
    this.animationDuration = const Duration(milliseconds: 800),
    this.baseScale = 1.0,
    this.scaleAmount = 0.3,
    this.waveWidth = 1.0,
    this.phaseShiftFactor = 0.35,
  });

  @override
  Duration getAnimationDuration(int index) => animationDuration;

  @override
  Duration getAnimationDelay(int index, int totalAvatars) => Duration.zero;

  @override
  bool get shouldReverseAnimation => true;

  @override
  Widget buildAnimatedAvatar({
    required Widget child,
    required Animation<double> animation,
    required int index,
  }) {
    final scale = _calculatePulseScale(animation.value, index);
    return Transform.scale(
      scale: scale,
      child: child,
    );
  }

  double _calculatePulseScale(double animationValue, int index) {
    final phaseShift = index * phaseShiftFactor;
    double shiftedValue = animationValue - phaseShift;
    while (shiftedValue < 0) shiftedValue += pi * 2;

    double normalizedSine = (sin(shiftedValue) + 1) / 2;
    normalizedSine = pow(normalizedSine, 1 / waveWidth) as double;

    return baseScale + normalizedSine * scaleAmount;
  }
}
