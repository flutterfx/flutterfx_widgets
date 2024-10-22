import 'dart:ui';

import 'package:flutter/material.dart';

class TextRevealEffect extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;
  final Curve curve;
  final bool trigger;

  const TextRevealEffect({
    Key? key,
    required this.text,
    this.style,
    this.duration = const Duration(milliseconds: 1000),
    this.curve = Curves.easeOutCubic,
    required this.trigger,
  }) : super(key: key);

  @override
  _TextRevealEffectState createState() => _TextRevealEffectState();
}

class _TextRevealEffectState extends State<TextRevealEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Animation<double>> _animations = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _setupAnimations();
  }

  @override
  void didUpdateWidget(TextRevealEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger != oldWidget.trigger) {
      _controller.forward(from: 0);
    }
  }

  void _setupAnimations() {
    final int charCount = widget.text.length;
    const double animationDuration = 1.0;
    const double totalAnimationTime = 1.0 + animationDuration;
    final double staggerOffset =
        (totalAnimationTime - animationDuration) / (charCount - 1);

    _animations.clear();
    for (int i = 0; i < charCount; i++) {
      final double start =
          (i * staggerOffset / totalAnimationTime).clamp(0.0, 1.0);
      final double end =
          ((i * staggerOffset + animationDuration) / totalAnimationTime)
              .clamp(0.0, 1.0);

      _animations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(start, end, curve: widget.curve),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Wrap(
          children: List.generate(
            widget.text.length,
            (index) => AnimatedBuilder(
              animation: _animations[index],
              builder: (context, child) {
                return Opacity(
                  opacity: _animations[index].value,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: (1 - _animations[index].value) * 8,
                      sigmaY: (1 - _animations[index].value) * 8,
                    ),
                    child: Text(
                      widget.text[index],
                      style: widget.style,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
