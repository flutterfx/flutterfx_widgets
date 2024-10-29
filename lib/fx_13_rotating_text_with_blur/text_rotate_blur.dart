import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fx_2_folder/fx_13_rotating_text_with_blur/strategies/all_strategies.dart';
import 'package:fx_2_folder/fx_14_text_reveal/strategies/FadeBlurStrategy.dart';
import 'package:fx_2_folder/fx_14_text_reveal/text_reveal_widget.dart';

enum RotatingTextState {
  hidden,
  entering,
  rotating,
  exiting,
}

class EnhancedRotatingText extends StatefulWidget {
  final String text;
  final double radius;
  final TextStyle textStyle;
  final Duration entryDuration;
  final Duration rotationDuration;
  final Duration exitDuration;
  final bool trigger;
  final TextAnimationStrategy entryStrategy;
  final RotationAnimationStrategy rotationStrategy;
  final TextAnimationStrategy exitStrategy;

  const EnhancedRotatingText({
    Key? key,
    required this.text,
    required this.radius,
    required this.textStyle,
    this.entryDuration = const Duration(milliseconds: 800),
    this.rotationDuration = const Duration(seconds: 15),
    this.exitDuration = const Duration(milliseconds: 800),
    required this.trigger,
    this.entryStrategy = const FadeBlurStrategy(),
    this.rotationStrategy = const DefaultRotationStrategy(),
    this.exitStrategy = const FadeBlurStrategy(),
  }) : super(key: key);

  @override
  EnhancedRotatingTextState createState() => EnhancedRotatingTextState();
}

class EnhancedRotatingTextState extends State<EnhancedRotatingText>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _entryExitController;
  late Animation<double> _entryAnimation;
  late Animation<double> _exitAnimation;
  RotatingTextState _state = RotatingTextState.hidden;

  @override
  void initState() {
    super.initState();
    _initializeControllers();

    if (widget.trigger) {
      _startAnimation();
    }
  }

  void _initializeControllers() {
    _rotationController = AnimationController(
      vsync: this,
      duration: widget.rotationDuration,
    );

    _entryExitController = AnimationController(
      vsync: this,
      duration: widget.entryDuration,
    );

    _entryAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryExitController,
        curve: Curves.easeInOut,
      ),
    );

    _exitAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entryExitController,
        curve: Curves.easeInOut,
      ),
    );

    _entryExitController.addStatusListener(_handleEntryExitStatus);
  }

  void _handleEntryExitStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (_state == RotatingTextState.entering) {
        setState(() {
          _state = RotatingTextState.rotating;
          _rotationController.repeat();
        });
      } else if (_state == RotatingTextState.exiting) {
        setState(() {
          _state = RotatingTextState.hidden;
        });
      }
    }
  }

  void _startAnimation() {
    setState(() {
      _state = RotatingTextState.entering;
    });
    _rotationController.stop();
    _entryExitController.duration = widget.entryDuration;
    _entryExitController.forward(from: 0.0);
  }

  void _stopAnimation() {
    setState(() {
      _state = RotatingTextState.exiting;
    });
    _rotationController.stop();
    _entryExitController.duration = widget.exitDuration;
    _entryExitController.forward(from: 0.0);
  }

  @override
  void didUpdateWidget(EnhancedRotatingText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.trigger != oldWidget.trigger) {
      if (widget.trigger) {
        _startAnimation();
      } else {
        _stopAnimation();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_rotationController, _entryExitController]),
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.radius * 2, widget.radius * 2),
          painter: _EnhancedCircularTextPainter(
            text: widget.text,
            radius: widget.radius,
            textStyle: widget.textStyle,
            rotationProgress: _rotationController.value,
            animationProgress: _state == RotatingTextState.entering
                ? _entryAnimation.value
                : _state == RotatingTextState.exiting
                    ? _exitAnimation.value
                    : 1.0,
            state: _state,
            entryStrategy: widget.entryStrategy,
            rotationStrategy: widget.rotationStrategy,
            exitStrategy: widget.exitStrategy,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _entryExitController.dispose();
    super.dispose();
  }
}

class _EnhancedCircularTextPainter extends CustomPainter {
  final String text;
  final double radius;
  final TextStyle textStyle;
  final double rotationProgress;
  final double animationProgress;
  final RotatingTextState state;
  final TextAnimationStrategy entryStrategy;
  final RotationAnimationStrategy rotationStrategy;
  final TextAnimationStrategy exitStrategy;

  _EnhancedCircularTextPainter({
    required this.text,
    required this.radius,
    required this.textStyle,
    required this.rotationProgress,
    required this.animationProgress,
    required this.state,
    required this.entryStrategy,
    required this.rotationStrategy,
    required this.exitStrategy,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (state == RotatingTextState.hidden || animationProgress == 0) return;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double totalAngle = 2 * pi;
    final double startAngle = -pi / 2 + (rotationProgress * totalAngle);

    // Pre-calculate text measurements
    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    double totalTextWidth = textPainter.width;
    double dotWidth = textStyle.fontSize! / 2;
    double totalSegmentWidth = totalTextWidth + dotWidth;

    // Calculate how many times the text can fit
    int repetitions = (totalAngle * radius / totalSegmentWidth).floor();
    repetitions = max(1, repetitions);

    double segmentAngle = totalAngle / repetitions;
    double textAngle = (textSpan.text!.length > 0)
        ? segmentAngle * (totalTextWidth / (totalTextWidth + dotWidth))
        : 0;

    for (int rep = 0; rep < repetitions; rep++) {
      double currentStartAngle = startAngle + (segmentAngle * rep);

      // Draw dot
      if (animationProgress > 0) {
        _drawDot(canvas, centerX, centerY, currentStartAngle);
      }

      // Draw text
      _drawTextSegment(
        canvas,
        centerX,
        centerY,
        currentStartAngle + dotWidth / radius,
        textAngle,
      );
    }
  }

  void _drawTextSegment(
    Canvas canvas,
    double centerX,
    double centerY,
    double startAngle,
    double totalAngle,
  ) {
    final double anglePerChar = totalAngle / text.length;

    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      final double charAngle = startAngle + (anglePerChar * (i + 0.5));

      // Calculate character position
      final double x = centerX + radius * cos(charAngle);
      final double y = centerY + radius * sin(charAngle);

      // Create character painter
      final charSpan = TextSpan(
        text: char,
        style: textStyle.copyWith(
          color: textStyle.color!.withOpacity(animationProgress),
        ),
      );
      final charPainter = TextPainter(
        text: charSpan,
        textDirection: TextDirection.ltr,
      );
      charPainter.layout();

      // Draw character
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(charAngle + pi / 2);
      charPainter.paint(
        canvas,
        Offset(-charPainter.width / 2, -charPainter.height / 2),
      );
      canvas.restore();
    }
  }

  void _drawDot(Canvas canvas, double centerX, double centerY, double angle) {
    final dotPaint = Paint()
      ..color = textStyle.color!.withOpacity(animationProgress)
      ..style = PaintingStyle.fill;

    final dotRadius = textStyle.fontSize! / 4;
    final dotX = centerX + radius * cos(angle);
    final dotY = centerY + radius * sin(angle);

    canvas.drawCircle(Offset(dotX, dotY), dotRadius, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _EnhancedCircularTextPainter oldDelegate) {
    return oldDelegate.rotationProgress != rotationProgress ||
        oldDelegate.animationProgress != animationProgress ||
        oldDelegate.state != state ||
        oldDelegate.text != text ||
        oldDelegate.radius != radius ||
        oldDelegate.textStyle != textStyle;
  }
}

// Helper classes
class _CharacterMetrics {
  final double width;
  final double height;

  _CharacterMetrics({required this.width, required this.height});
}

class _CharacterTransform {
  final double radius;
  final double angle;

  _CharacterTransform({required this.radius, required this.angle});
}
