import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class HyperText extends StatefulWidget {
  const HyperText({
    super.key,
    required this.text,
    this.duration = const Duration(milliseconds: 800),
    this.style,
    this.animationTrigger = false,
    this.animateOnLoad = true,
  });

  final bool animateOnLoad;
  final bool animationTrigger;
  final Duration duration;
  final TextStyle? style;
  final String text;

  @override
  _HyperTextState createState() => _HyperTextState();
}

class _HyperTextState extends State<HyperText> {
  int animationCount = 0;
  late List<String> displayText;
  bool isFirstRender = true;
  double iterations = 0;

  final Random _random = Random();
  Timer? _timer;

  @override
  void didUpdateWidget(HyperText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animationTrigger != oldWidget.animationTrigger &&
        widget.animationTrigger) {
      _startAnimation();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    displayText = widget.text.split('');
    if (widget.animateOnLoad) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    iterations = 0;
    _timer?.cancel();
    animationCount++;
    final currentAnimationCount = animationCount;

    _timer = Timer.periodic(
      widget.duration ~/
          (widget.text.isNotEmpty ? widget.text.length * 10 : 10),
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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(displayText.length, (index) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 50),
            child: Text(
              displayText[index],
              key: ValueKey<String>('$animationCount-$index'),
              style: widget.style ?? Theme.of(context).textTheme.titleLarge,
            ),
          );
        }),
      ),
    );
  }
}
