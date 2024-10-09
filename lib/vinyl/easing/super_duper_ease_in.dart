import 'dart:math';
import 'package:flutter/animation.dart';

class SuperDuperEaseInAndThenQuickOut extends Curve {
  final double exponent;

  const SuperDuperEaseInAndThenQuickOut({this.exponent = 5});

  @override
  double transform(double t) {
    return pow(t, exponent).toDouble();
  }
}
