import 'package:flutter/material.dart';
import 'dart:async';

class TypingAnimation extends StatefulWidget {
  final String text;
  final Duration duration;
  final TextStyle? style;
  final bool animate;

  const TypingAnimation({
    Key? key,
    required this.text,
    this.duration = const Duration(milliseconds: 100),
    this.style,
    this.animate = false,
  }) : super(key: key);

  @override
  _TypingAnimationState createState() => _TypingAnimationState();
}

class _TypingAnimationState extends State<TypingAnimation> {
  String _displayedText = '';
  int _charIndex = 0;
  Timer? _timer;

  @override
  void didUpdateWidget(TypingAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !oldWidget.animate) {
      _startAnimation();
    } else if (!widget.animate && oldWidget.animate) {
      _stopAnimation();
    }
  }

  void _startAnimation() {
    _charIndex = 0;
    _displayedText = '';
    _timer = Timer.periodic(widget.duration, (timer) {
      if (_charIndex < widget.text.length) {
        setState(() {
          _displayedText = widget.text.substring(0, _charIndex + 1);
          _charIndex++;
        });
      } else {
        _stopAnimation();
      }
    });
  }

  void _stopAnimation() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _stopAnimation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.animate ? _displayedText : widget.text,
      style: widget.style ??
          const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
