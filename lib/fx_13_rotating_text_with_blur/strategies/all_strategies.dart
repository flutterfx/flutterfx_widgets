import 'dart:math';

import 'package:flutter/material.dart';

abstract class RotationAnimationStrategy {
  const RotationAnimationStrategy();

  void paintCharacter({
    required Canvas canvas,
    required String character,
    required TextStyle textStyle,
    required Offset center,
    required double radius,
    required double angle,
    required double progress,
    required Size charSize,
  });

  // Optional method for painting additional elements (like dots)
  void paintDecorations({
    required Canvas canvas,
    required Offset center,
    required double radius,
    required double angle,
    required TextStyle textStyle,
  }) {}
}

// Default rotation strategy that maintains original behavior
class DefaultRotationStrategy extends RotationAnimationStrategy {
  const DefaultRotationStrategy();

  @override
  void paintCharacter({
    required Canvas canvas,
    required String character,
    required TextStyle textStyle,
    required Offset center,
    required double radius,
    required double angle,
    required double progress,
    required Size charSize,
  }) {
    final textSpan = TextSpan(text: character, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final x = center.dx + radius * cos(angle);
    final y = center.dy + radius * sin(angle);

    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(angle + pi / 2);
    textPainter.paint(
        canvas, Offset(-charSize.width / 2, -charSize.height / 2));
    canvas.restore();
  }

  @override
  void paintDecorations({
    required Canvas canvas,
    required Offset center,
    required double radius,
    required double angle,
    required TextStyle textStyle,
  }) {
    final dotRadius = textStyle.fontSize! / 4;
    final dotPaint = Paint()
      ..color = textStyle.color!
      ..style = PaintingStyle.fill;

    final dotX = center.dx + radius * cos(angle);
    final dotY = center.dy + radius * sin(angle);

    canvas.drawCircle(Offset(dotX, dotY), dotRadius, dotPaint);
  }
}

// Wave rotation strategy
class WaveRotationStrategy extends RotationAnimationStrategy {
  final double waveAmplitude;
  final double waveFrequency;

  const WaveRotationStrategy({
    this.waveAmplitude = 10.0,
    this.waveFrequency = 2.0,
  });

  @override
  void paintCharacter({
    required Canvas canvas,
    required String character,
    required TextStyle textStyle,
    required Offset center,
    required double radius,
    required double angle,
    required double progress,
    required Size charSize,
  }) {
    // Add wave effect to radius
    double waveOffset =
        sin(angle * waveFrequency + progress * 2 * pi) * waveAmplitude;
    double finalRadius = radius + waveOffset;

    final x = center.dx + finalRadius * cos(angle);
    final y = center.dy + finalRadius * sin(angle);

    final textSpan = TextSpan(text: character, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(angle + pi / 2);
    textPainter.paint(
        canvas, Offset(-charSize.width / 2, -charSize.height / 2));
    canvas.restore();
  }
}

// Bounce rotation strategy
class BounceRotationStrategy extends RotationAnimationStrategy {
  final double bounceHeight;
  final double bounceFrequency;

  const BounceRotationStrategy({
    this.bounceHeight = 20.0,
    this.bounceFrequency = 3.0,
  });

  @override
  void paintCharacter({
    required Canvas canvas,
    required String character,
    required TextStyle textStyle,
    required Offset center,
    required double radius,
    required double angle,
    required double progress,
    required Size charSize,
  }) {
    // Calculate bounce effect
    double bounce = max(0, sin(angle * bounceFrequency + progress * 2 * pi));
    double bounceOffset =
        bounce * bounce * bounceHeight; // Squared for more bounce-like effect
    double finalRadius = radius - bounceOffset;

    final x = center.dx + finalRadius * cos(angle);
    final y = center.dy + finalRadius * sin(angle);

    final textSpan = TextSpan(text: character, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(angle + pi / 2);
    textPainter.paint(
        canvas, Offset(-charSize.width / 2, -charSize.height / 2));
    canvas.restore();
  }
}

// Vibration rotation strategy - characters vibrate while rotating
class VibrationRotationStrategy extends RotationAnimationStrategy {
  final double vibrationIntensity;
  final double vibrationSpeed;

  const VibrationRotationStrategy({
    this.vibrationIntensity = 3.0,
    this.vibrationSpeed = 15.0,
  });

  @override
  void paintCharacter({
    required Canvas canvas,
    required String character,
    required TextStyle textStyle,
    required Offset center,
    required double radius,
    required double angle,
    required double progress,
    required Size charSize,
  }) {
    // Add random-like vibration using multiple sine waves
    double noise = sin(angle * 5 + progress * vibrationSpeed) *
        cos(angle * 3 + progress * vibrationSpeed * 1.5);

    double offsetX = noise * vibrationIntensity * cos(angle);
    double offsetY = noise * vibrationIntensity * sin(angle);

    final x = center.dx + radius * cos(angle) + offsetX;
    final y = center.dy + radius * sin(angle) + offsetY;

    final textSpan = TextSpan(text: character, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(angle + pi / 2 + noise * 0.1); // Slight rotation vibration
    textPainter.paint(
        canvas, Offset(-charSize.width / 2, -charSize.height / 2));
    canvas.restore();
  }
}

// Spiral rotation strategy - characters follow a spiral path while rotating
class SpiralRotationStrategy extends RotationAnimationStrategy {
  final double spiralTightness;
  final double spiralSpeed;

  const SpiralRotationStrategy({
    this.spiralTightness = 20.0,
    this.spiralSpeed = 2.0,
  });

  @override
  void paintCharacter({
    required Canvas canvas,
    required String character,
    required TextStyle textStyle,
    required Offset center,
    required double radius,
    required double angle,
    required double progress,
    required Size charSize,
  }) {
    // Calculate spiral effect
    double spiralRadius =
        radius + sin(angle * spiralSpeed + progress * 2 * pi) * spiralTightness;

    final x = center.dx + spiralRadius * cos(angle);
    final y = center.dy + spiralRadius * sin(angle);

    final textSpan = TextSpan(text: character, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(angle + pi / 2);
    textPainter.paint(
        canvas, Offset(-charSize.width / 2, -charSize.height / 2));
    canvas.restore();
  }
}

// Elastic rotation strategy - characters stretch and squish while rotating
class ElasticRotationStrategy extends RotationAnimationStrategy {
  final double elasticity;
  final double frequency;

  const ElasticRotationStrategy({
    this.elasticity = 0.3,
    this.frequency = 2.0,
  });

  @override
  void paintCharacter({
    required Canvas canvas,
    required String character,
    required TextStyle textStyle,
    required Offset center,
    required double radius,
    required double angle,
    required double progress,
    required Size charSize,
  }) {
    final x = center.dx + radius * cos(angle);
    final y = center.dy + radius * sin(angle);

    // Calculate elastic transformation
    double stretch =
        1 + elasticity * sin(angle * frequency + progress * 2 * pi);
    double squeeze = 1 / stretch; // Maintain area by compensating stretch

    final textSpan = TextSpan(text: character, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(angle + pi / 2);
    canvas.scale(stretch, squeeze);
    textPainter.paint(
        canvas, Offset(-charSize.width / 2, -charSize.height / 2));
    canvas.restore();
  }
}
