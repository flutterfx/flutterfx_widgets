/// A Flutter widget that reveals hidden content through a scratch gesture.
///
/// This package provides [ScratchToReveal], a widget that renders a customizable
/// gradient overlay that users can scratch away to reveal the child widget beneath.
/// When enough of the surface is scratched, a completion animation plays.
///
/// ## Usage
///
/// ```dart
/// import 'package:flutterfx_scratch_to_reveal/flutterfx_scratch_to_reveal.dart';
///
/// ScratchToReveal(
///   width: 250,
///   height: 250,
///   child: Center(child: Text('🎉', style: TextStyle(fontSize: 100))),
/// )
/// ```
///
/// ## Customization
///
/// ```dart
/// ScratchToReveal(
///   width: 300,
///   height: 200,
///   minScratchPercentage: 60,
///   gradientColors: [Colors.purple, Colors.pink, Colors.orange],
///   enableHapticFeedback: true,
///   onComplete: () => print('Revealed!'),
///   child: YourWidget(),
/// )
/// ```
library;

export 'src/scratch_to_reveal.dart';
