import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fx_2_folder/loader-avatars/loader_avatars.dart';

class RippleAnimationStrategy extends AvatarAnimationStrategy {
  final Duration animationDuration;
  final Duration staggerDelay;
  final double maxDisplacement;

  RippleAnimationStrategy({
    this.animationDuration = const Duration(milliseconds: 1200),
    this.staggerDelay = const Duration(milliseconds: 120),
    this.maxDisplacement = 12.0,
  });

  @override
  Duration getAnimationDuration(int index) => animationDuration;

  @override
  Duration getAnimationDelay(int index, int totalAvatars) {
    final center = totalAvatars ~/ 2;
    final distanceFromCenter = (index - center).abs();
    return staggerDelay * distanceFromCenter;
  }

  @override
  bool get shouldReverseAnimation => false;

  @override
  Widget buildAnimatedAvatar({
    required Widget child,
    required Animation<double> animation,
    required int index,
  }) {
    final angle = animation.value;
    final displacement = sin(angle) * maxDisplacement;
    final horizontalOffset = cos(angle) * (maxDisplacement / 2);

    return Transform.translate(
      offset: Offset(horizontalOffset, displacement),
      child: child,
    );
  }
}
