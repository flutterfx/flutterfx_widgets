/// A Flutter widget that renders two orbiting icon rings with a
/// frosted-glass blur circle at the center.
///
/// This package provides [OrbitingIcons] as the main widget, along with
/// [OrbitingCircle], [SingleOrbitingCircle], and [OrbitConfig] for
/// fine-grained composition and control.
///
/// ## Basic Usage
///
/// ```dart
/// import 'package:flutterfx_orbit_blur/flutterfx_orbit_blur.dart';
///
/// OrbitingIcons(
///   reverse: true,
///   duration: 10.0,
///   showPaths: true,
/// )
/// ```
///
/// ## Custom Icons
///
/// ```dart
/// OrbitingIcons(
///   leftIcons: [Icons.flutter_dash, Icons.star, Icons.bolt],
///   rightIcons: [Icons.rocket_launch, Icons.wifi, Icons.favorite],
///   duration: 8.0,
/// )
/// ```
///
/// ## Reactive Config
///
/// ```dart
/// final config = OrbitConfig(reverse: false, duration: 6.0);
///
/// AnimatedBuilder(
///   animation: config,
///   builder: (context, _) => OrbitingIcons(
///     reverse: config.reverse,
///     duration: config.duration,
///     showPaths: config.showPaths,
///   ),
/// )
/// ```
library;

export 'src/orbit_blur.dart';
