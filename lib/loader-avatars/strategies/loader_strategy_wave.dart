import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fx_2_folder/loader-avatars/loader_avatars.dart';

class WaveAnimationStrategy extends AvatarAnimationStrategy {
  final Duration animationDuration;
  final Duration staggerDelay;
  final bool reverseWave;
  final double maxDisplacement;

  WaveAnimationStrategy({
    this.animationDuration = const Duration(milliseconds: 1200),
    this.staggerDelay = const Duration(milliseconds: 120),
    this.reverseWave = false,
    this.maxDisplacement = 12.0,
  });

  @override
  Duration getAnimationDuration(int index) => animationDuration;

  @override
  Duration getAnimationDelay(int index, int totalAvatars) {
    return staggerDelay * (reverseWave ? totalAvatars - 1 - index : index);
  }

  @override
  bool get shouldReverseAnimation => false;

  @override
  Widget buildAnimatedAvatar({
    required Widget child,
    required Animation<double> animation,
    required int index,
  }) {
    final displacement = sin(animation.value) * maxDisplacement;
    return Transform.translate(
      offset: Offset(0, displacement),
      child: child,
    );
  }
}
