import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class HyperText extends StatefulWidget {
  final String text;
  final Duration duration;
  final TextStyle? textStyle;
  final bool animationTrigger;
  final bool animateOnLoad;

  const HyperText({
    Key? key,
    required this.text,
    this.duration = const Duration(milliseconds: 800),
    this.textStyle,
    this.animationTrigger = false,
    this.animateOnLoad = true,
  }) : super(key: key);

  @override
  _HyperTextState createState() => _HyperTextState();
}

class _HyperTextState extends State<HyperText> {
  late List<String> displayText;
  Timer? _timer;
  double iterations = 0;
  bool isFirstRender = true;
  final Random _random = Random();
  int animationCount = 0;

  @override
  void initState() {
    super.initState();
    displayText = widget.text.split('');
    if (widget.animateOnLoad) {
      _startAnimation();
    }
  }

  @override
  void didUpdateWidget(HyperText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animationTrigger != oldWidget.animationTrigger &&
        widget.animationTrigger) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    iterations = 0;
    _timer?.cancel();
    animationCount++;
    final currentAnimationCount = animationCount;

    _timer = Timer.periodic(
      widget.duration ~/ (widget.text.length * 10),
      (timer) {
        if (!widget.animateOnLoad && isFirstRender) {
          timer.cancel();
          isFirstRender = false;
          return;
        }
        if (iterations < widget.text.length &&
            currentAnimationCount == animationCount) {
          setState(() {
            displayText = List.generate(
              widget.text.length,
              (i) => widget.text[i] == ' '
                  ? ' '
                  : i <= iterations
                      ? widget.text[i]
                      : String.fromCharCode(_random.nextInt(26) + 65),
            );
          });
          iterations += 0.1;
        } else {
          timer.cancel();
          if (currentAnimationCount == animationCount) {
            setState(() {
              displayText = widget.text.split('');
            });
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(displayText.length, (index) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 50),
            child: Text(
              displayText[index].toUpperCase(),
              key: ValueKey<String>('$animationCount-$index'),
              style: widget.textStyle ?? Theme.of(context).textTheme.titleLarge,
            ),
          );
        }),
      ),
    );
  }
}
