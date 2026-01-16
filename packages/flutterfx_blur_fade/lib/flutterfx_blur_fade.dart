/// A Flutter widget that animates children with a combined blur and fade effect.
///
/// This package provides [BlurFade], a widget that creates smooth entrance
/// animations by combining opacity fade with blur-to-sharp transitions.
///
/// ## Usage
///
/// ```dart
/// import 'package:flutterfx_blur_fade/flutterfx_blur_fade.dart';
///
/// BlurFade(
///   child: Text('Hello World'),
/// )
/// ```
///
/// ## Customization
///
/// ```dart
/// BlurFade(
///   duration: Duration(milliseconds: 600),
///   delay: Duration(milliseconds: 200),
///   blur: 12.0,
///   curve: Curves.easeInOut,
///   child: YourWidget(),
/// )
/// ```
library flutterfx_blur_fade;

export 'src/blur_fade.dart';
