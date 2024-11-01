import 'dart:math' as math;
import 'package:flutter/animation.dart';

/// A custom curve that creates an elastic effect with configurable parameters
class ElasticOutCurve extends Curve {
  /// [period] determines the frequency of oscillation
  /// [damping] controls how quickly the oscillations decrease (0 to 1)
  /// [overshootFactor] controls how far past the endpoint the animation goes
  final double period;
  final double damping;
  final double overshootFactor;

  const ElasticOutCurve({
    this.period = 0.4,
    this.damping = 0.2,
    this.overshootFactor = 1.5,
  });

  @override
  double transformInternal(double t) {
    if (t == 0 || t == 1) return t;

    final s = period / 2 * math.pi;
    final decay = math.pow(math.e, -damping * t);

    return 1 +
        overshootFactor * decay * math.sin((t * 2 * math.pi - s) / period);
  }
}

/// A curve that creates a bouncy spring effect
class SpringOutCurve extends Curve {
  /// [tension] controls the initial acceleration (default: 3)
  /// [bounces] determines number of bounces (default: 3)
  /// [maxOvershoot] maximum overshoot as fraction of total distance (default: 0.2)
  final double tension;
  final int bounces;
  final double maxOvershoot;

  const SpringOutCurve({
    this.tension = 3.0,
    this.bounces = 3,
    this.maxOvershoot = 0.2,
  });

  @override
  double transformInternal(double t) {
    if (t == 0 || t == 1) return t;

    // Calculate decay based on current time
    final decay = math.pow(t, tension);

    // Create diminishing sine wave
    final wave = math.sin(2 * math.pi * bounces * t);

    // Combine with decay for spring effect
    return 1 + (wave * decay * maxOvershoot);
  }
}

class SingleBounceCurve extends Curve {
  /// The amount of overshoot (1.2 means it will go 20% beyond the end point)
  final double overshoot;

  /// The position in the timeline where the peak occurs (0.0 to 1.0)
  final double peakPosition;

  const SingleBounceCurve({
    this.overshoot = 1.25, // Will overshoot by 25%
    this.peakPosition = 0.7, // Peak occurs at 70% of the animation
  });

  @override
  double transformInternal(double t) {
    if (t == 0 || t == 1) return t;

    // Before peak: Smooth acceleration to overshoot
    if (t < peakPosition) {
      return _smoothStep(t / peakPosition) * overshoot;
    }

    // After peak: Smooth deceleration back to 1.0
    final remainingTime = (t - peakPosition) / (1 - peakPosition);
    return overshoot + (1.0 - overshoot) * _smoothStep(remainingTime);
  }

  // Helper function for smooth acceleration/deceleration
  double _smoothStep(double t) {
    return t * t * (3 - 2 * t);
  }
}
