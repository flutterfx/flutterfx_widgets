import 'dart:ui';

import 'package:flutter/material.dart';

class CircleData {
  final String id;
  final Offset normalizedPosition;
  final double radius;
  final Color color;

  CircleData({
    required this.id,
    required this.normalizedPosition,
    required this.radius,
    required this.color,
  }) : assert(
            normalizedPosition.dx >= 0 &&
                normalizedPosition.dx <= 1 &&
                normalizedPosition.dy >= 0 &&
                normalizedPosition.dy <= 1,
            "Normalized position must be between 0 and 1");

  CircleData lerp(CircleData other, double t) {
    return CircleData(
      id: this.id,
      normalizedPosition:
          Offset.lerp(this.normalizedPosition, other.normalizedPosition, t)!,
      radius: lerpDouble(this.radius, other.radius, t)!,
      color: Color.lerp(this.color, other.color, t)!,
    );
  }
}
