import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fx_2_folder/loader-avatars/loader_avatars.dart';

// Strategy 1:
class CoinFlipStrategy extends AvatarAnimationStrategy {
  final Duration animationDuration;
  final Duration staggerDelay;
  final double maxHeight;
  final double perspectiveValue;
  final double rotationAngle;

  CoinFlipStrategy({
    this.animationDuration = const Duration(milliseconds: 1800),
    this.staggerDelay = const Duration(milliseconds: 120),
    this.maxHeight = 25.0,
    this.perspectiveValue = 0.002,
    this.rotationAngle = pi, // Full rotation
  });

  @override
  Duration getAnimationDuration(int index) => animationDuration;

  @override
  Duration getAnimationDelay(int index, int totalAvatars) =>
      staggerDelay * index;

  @override
  bool get shouldReverseAnimation => true;

  @override
  Widget buildAnimatedAvatar({
    required Widget child,
    required Animation<double> animation,
    required int index,
  }) {
    final value = animation.value;

    // Calculate height parabola for smooth up-down motion
    final heightProgress = sin(value * pi);
    final height = heightProgress * maxHeight;

    // Calculate rotation with easing
    final rotationProgress = value;
    final currentRotation = rotationProgress * rotationAngle;

    // Add subtle scale effect during flip
    final scale = 1.0 + (sin(value * pi) * 0.1);

    // Add slight horizontal movement during flip
    final horizontalShift = sin(value * pi * 2) * 5.0;

    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, perspectiveValue) // Add perspective
        ..translate(
            horizontalShift, -height, 0.0) // Move up and slightly sideways
        ..rotateX(currentRotation) // Flip like a coin
        ..scale(scale), // Subtle scale animation
      alignment: Alignment.center,
      child: child,
    );
  }
}

class CoinRotateStrategy extends AvatarAnimationStrategy {
  final Duration animationDuration;
  final Duration staggerDelay;
  final double maxHeight;
  final double perspectiveValue;
  final double rotationAngle;

  CoinRotateStrategy({
    this.animationDuration = const Duration(milliseconds: 1800),
    this.staggerDelay = const Duration(milliseconds: 120),
    this.maxHeight = 25.0,
    this.perspectiveValue = 0.002,
    this.rotationAngle = pi, // Full rotation
  });

  @override
  Duration getAnimationDuration(int index) => animationDuration;

  @override
  Duration getAnimationDelay(int index, int totalAvatars) =>
      staggerDelay * index;

  @override
  bool get shouldReverseAnimation => true;

  @override
  Widget buildAnimatedAvatar({
    required Widget child,
    required Animation<double> animation,
    required int index,
  }) {
    final value = animation.value;

    // Calculate height parabola for smooth up-down motion
    final heightProgress = sin(value * pi);
    final height = heightProgress * maxHeight;

    // Calculate rotation with easing
    final rotationProgress = value;
    final currentRotation = rotationProgress * rotationAngle;

    // Add subtle scale effect during flip
    final scale = 1.0 + (sin(value * pi) * 0.1);

    // Add slight horizontal movement during flip
    final horizontalShift = sin(value * pi * 2) * 5.0;

    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, perspectiveValue) // Add perspective
        // ..translate(
        //     horizontalShift, -height, 0.0) // Move up and slightly sideways
        ..rotateZ(currentRotation) // Flip like a coin
        ..scale(scale), // Subtle scale animation
      alignment: Alignment.center,
      child: child,
    );
  }
}

class CoinRotateXStrategy extends AvatarAnimationStrategy {
  final Duration animationDuration;
  final Duration staggerDelay;
  final double maxHeight;
  final double perspectiveValue;
  final double rotationAngle;

  CoinRotateXStrategy({
    this.animationDuration = const Duration(milliseconds: 1800),
    this.staggerDelay = const Duration(milliseconds: 120),
    this.maxHeight = 25.0,
    this.perspectiveValue = 0.002,
    this.rotationAngle = pi, // Full rotation
  });

  @override
  Duration getAnimationDuration(int index) => animationDuration;

  @override
  Duration getAnimationDelay(int index, int totalAvatars) =>
      staggerDelay * index;

  @override
  bool get shouldReverseAnimation => true;

  @override
  Widget buildAnimatedAvatar({
    required Widget child,
    required Animation<double> animation,
    required int index,
  }) {
    final value = animation.value;

    // Calculate height parabola for smooth up-down motion
    final heightProgress = sin(value * pi);
    final height = heightProgress * maxHeight;

    // Calculate rotation with easing
    final rotationProgress = value;
    final currentRotation = rotationProgress * rotationAngle;

    // Add subtle scale effect during flip
    final scale = 1.0 + (sin(value * pi) * 0.1);

    // Add slight horizontal movement during flip
    final horizontalShift = sin(value * pi * 2) * 5.0;

    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, perspectiveValue) // Add perspective
        // ..translate(
        //     horizontalShift, -height, 0.0) // Move up and slightly sideways
        ..rotateX(currentRotation) // Flip like a coin
        ..scale(scale), // Subtle scale animation
      alignment: Alignment.center,
      child: child,
    );
  }
}

class CoinRotateYStrategy extends AvatarAnimationStrategy {
  final Duration animationDuration;
  final Duration staggerDelay;
  final double maxHeight;
  final double perspectiveValue;
  final double rotationAngle;

  CoinRotateYStrategy({
    this.animationDuration = const Duration(milliseconds: 1800),
    this.staggerDelay = const Duration(milliseconds: 120),
    this.maxHeight = 25.0,
    this.perspectiveValue = 0.002,
    this.rotationAngle = pi, // Full rotation
  });

  @override
  Duration getAnimationDuration(int index) => animationDuration;

  @override
  Duration getAnimationDelay(int index, int totalAvatars) =>
      staggerDelay * index;

  @override
  bool get shouldReverseAnimation => true;

  @override
  Widget buildAnimatedAvatar({
    required Widget child,
    required Animation<double> animation,
    required int index,
  }) {
    final value = animation.value;

    // Calculate height parabola for smooth up-down motion
    final heightProgress = sin(value * pi);
    final height = heightProgress * maxHeight;

    // Calculate rotation with easing
    final rotationProgress = value;
    final currentRotation = rotationProgress * rotationAngle;

    // Add subtle scale effect during flip
    final scale = 1.0 + (sin(value * pi) * 0.1);

    // Add slight horizontal movement during flip
    final horizontalShift = sin(value * pi * 2) * 5.0;

    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, perspectiveValue) // Add perspective
        // ..translate(
        //     horizontalShift, -height, 0.0) // Move up and slightly sideways
        ..rotateY(currentRotation) // Flip like a coin
        ..scale(scale), // Subtle scale animation
      alignment: Alignment.center,
      child: child,
    );
  }
}

// Strategy 2: Gentle Orbit Animation
class OrbitAnimationStrategy extends AvatarAnimationStrategy {
  final Duration animationDuration;
  final Duration staggerDelay;
  final double orbitRadius;
  final double maxRotation;

  OrbitAnimationStrategy({
    this.animationDuration = const Duration(milliseconds: 3000),
    this.staggerDelay = const Duration(milliseconds: 200),
    this.orbitRadius = 15.0,
    this.maxRotation = pi / 6,
  });

  @override
  Duration getAnimationDuration(int index) => animationDuration;

  @override
  Duration getAnimationDelay(int index, int totalAvatars) =>
      staggerDelay * index;

  @override
  bool get shouldReverseAnimation => false;

  @override
  Widget buildAnimatedAvatar({
    required Widget child,
    required Animation<double> animation,
    required int index,
  }) {
    final value = animation.value;
    final angle = value * 2 * pi;
    final x = cos(angle) * orbitRadius;
    final z = sin(angle) * orbitRadius;
    final rotateY = sin(angle) * maxRotation;

    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..translate(x, 0, z)
        ..rotateY(rotateY),
      alignment: Alignment.center,
      child: child,
    );
  }
}

// Strategy 3: Breathing Space Animation
class BreathingSpaceStrategy extends AvatarAnimationStrategy {
  final Duration animationDuration;
  final Duration staggerDelay;
  final double maxScale;
  final double maxDistance;

  BreathingSpaceStrategy({
    this.animationDuration = const Duration(milliseconds: 4000),
    this.staggerDelay = const Duration(milliseconds: 300),
    this.maxScale = 1.2,
    this.maxDistance = 20.0,
  });

  @override
  Duration getAnimationDuration(int index) => animationDuration;

  @override
  Duration getAnimationDelay(int index, int totalAvatars) =>
      staggerDelay * index;

  @override
  bool get shouldReverseAnimation => true;

  @override
  Widget buildAnimatedAvatar({
    required Widget child,
    required Animation<double> animation,
    required int index,
  }) {
    final value = animation.value;
    final scale = 1.0 + (sin(value * pi) * (maxScale - 1.0));
    final distance = sin(value * pi) * maxDistance;

    return Transform(
      transform: Matrix4.identity()
        ..translate(0.0, 0.0, distance)
        ..scale(scale),
      alignment: Alignment.center,
      child: child,
    );
  }
}

// Strategy 4: Zen Ripple Animation
class ZenRippleStrategy extends AvatarAnimationStrategy {
  final Duration animationDuration;
  final Duration staggerDelay;
  final double maxRotation;
  final double maxTranslation;

  ZenRippleStrategy({
    this.animationDuration = const Duration(milliseconds: 2500),
    this.staggerDelay = const Duration(milliseconds: 250),
    this.maxRotation = pi / 4,
    this.maxTranslation = 25.0,
  });

  @override
  Duration getAnimationDuration(int index) => animationDuration;

  @override
  Duration getAnimationDelay(int index, int totalAvatars) =>
      staggerDelay * index;

  @override
  bool get shouldReverseAnimation => true;

  @override
  Widget buildAnimatedAvatar({
    required Widget child,
    required Animation<double> animation,
    required int index,
  }) {
    final value = animation.value;
    final rotateZ = sin(value * pi) * maxRotation;
    final translateY = sin(value * pi) * maxTranslation;
    final perspective = 0.002 * sin(value * pi);

    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, perspective)
        ..rotateZ(rotateZ)
        ..translate(0.0, translateY, 0.0),
      alignment: Alignment.center,
      child: child,
    );
  }
}

// Strategy 5: Floating Meditation Animation
class FloatingMeditationStrategy extends AvatarAnimationStrategy {
  final Duration animationDuration;
  final Duration staggerDelay;
  final double floatHeight;
  final double rotationAngle;

  FloatingMeditationStrategy({
    this.animationDuration = const Duration(milliseconds: 3500),
    this.staggerDelay = const Duration(milliseconds: 180),
    this.floatHeight = 18.0,
    this.rotationAngle = pi / 8,
  });

  @override
  Duration getAnimationDuration(int index) => animationDuration;

  @override
  Duration getAnimationDelay(int index, int totalAvatars) =>
      staggerDelay * index;

  @override
  bool get shouldReverseAnimation => true;

  @override
  Widget buildAnimatedAvatar({
    required Widget child,
    required Animation<double> animation,
    required int index,
  }) {
    final value = animation.value;
    final height = sin(value * 2 * pi) * floatHeight;
    final rotate = sin(value * 2 * pi) * rotationAngle;
    final scale = 1.0 + (sin(value * 2 * pi) * 0.1);

    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..translate(0.0, -height, 0.0)
        ..rotateZ(rotate)
        ..scale(scale),
      alignment: Alignment.center,
      child: child,
    );
  }
}
