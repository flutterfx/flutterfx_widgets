import 'dart:ui';
import 'package:flutter/material.dart';

// Animation manager to handle all character animations
class TextRevealAnimationManager {
  final AnimationController controller;
  final int characterCount;
  final Curve curve;

  late final List<Animation<double>> _characterAnimations;

  TextRevealAnimationManager({
    required this.controller,
    required this.characterCount,
    required this.curve,
  }) {
    _initializeAnimations();
  }

  void _initializeAnimations() {
    const double animationDuration = 0.8;
    const double totalAnimationTime = 1.0 + animationDuration;
    final double staggerOffset =
        (totalAnimationTime - animationDuration) / (characterCount - 1);

    _characterAnimations = List.generate(characterCount, (index) {
      final double start =
          (index * staggerOffset / totalAnimationTime).clamp(0.0, 1.0);
      final double end =
          ((index * staggerOffset + animationDuration) / totalAnimationTime)
              .clamp(0.0, 1.0);

      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval(start, end, curve: curve),
        ),
      );
    });
  }

  Animation<double> getAnimationForIndex(int index) =>
      _characterAnimations[index];

  void dispose() {
    _characterAnimations.clear();
  }
}

// Character widget to optimize rebuilds
class RevealedCharacter extends StatelessWidget {
  final String character;
  final TextStyle? style;
  final Animation<double> animation;

  const RevealedCharacter({
    required this.character,
    required this.animation,
    this.style,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: animation,
      builder: (context, value, _) => Opacity(
        opacity: value,
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(
            sigmaX: (1 - value) * 8,
            sigmaY: (1 - value) * 8,
          ),
          child: Text(character, style: style),
        ),
      ),
    );
  }
}

class TextRevealEffect extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;
  final Curve curve;
  final bool trigger;

  const TextRevealEffect({
    required this.text,
    this.style,
    this.duration = const Duration(milliseconds: 1000),
    this.curve = Curves.easeInOut,
    required this.trigger,
    Key? key,
  }) : super(key: key);

  @override
  State<TextRevealEffect> createState() => _TextRevealEffectState();
}

class _TextRevealEffectState extends State<TextRevealEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final TextRevealAnimationManager _animationManager;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animationManager = TextRevealAnimationManager(
      controller: _controller,
      characterCount: widget.text.length,
      curve: widget.curve,
    );
  }

  @override
  void didUpdateWidget(TextRevealEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger != oldWidget.trigger) {
      _controller.forward(from: 0);
    }

    if (widget.text.length != oldWidget.text.length) {
      _animationManager.dispose();
      _animationManager = TextRevealAnimationManager(
        controller: _controller,
        characterCount: widget.text.length,
        curve: widget.curve,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: List.generate(
        widget.text.length,
        (index) => RevealedCharacter(
          character: widget.text[index],
          style: widget.style,
          animation: _animationManager.getAnimationForIndex(index),
        ),
      ),
    );
  }
}
