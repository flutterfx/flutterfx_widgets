import 'package:fx_2_folder/smoke/circle_data.dart';

class AnimationSequence {
  final List<List<CircleData>> sequences;
  final Duration stepDuration;
  final Function(int)? onSequenceChange;

  AnimationSequence({
    required this.sequences,
    this.stepDuration = const Duration(seconds: 1),
    this.onSequenceChange,
  });

  int get length => sequences.length;
}
