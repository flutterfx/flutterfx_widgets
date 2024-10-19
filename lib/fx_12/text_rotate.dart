import 'dart:math' as math;
import 'package:flutter/material.dart';

class CircularCharacterRotatingText extends StatefulWidget {
  final String text;
  final double radius;
  final TextStyle textStyle;
  final Duration rotationDuration;

  const CircularCharacterRotatingText({
    Key? key,
    required this.text,
    required this.radius,
    required this.textStyle,
    required this.rotationDuration,
  }) : super(key: key);

  @override
  _CircularCharacterRotatingTextState createState() =>
      _CircularCharacterRotatingTextState();
}

class _CircularCharacterRotatingTextState
    extends State<CircularCharacterRotatingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.rotationDuration,
    )..repeat();
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
        return CustomPaint(
          size: Size(widget.radius * 2, widget.radius * 2),
          painter: _CircularTextPainter(
            text: widget.text,
            radius: widget.radius,
            textStyle: widget.textStyle,
            progress: _controller.value,
          ),
        );
      },
    );
  }
}

class _CircularTextPainter extends CustomPainter {
  final String text;
  final double radius;
  final TextStyle textStyle;
  final double progress;

  _CircularTextPainter({
    required this.text,
    required this.radius,
    required this.textStyle,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double totalAngle = 2 * math.pi;
    double startAngle = -math.pi / 2 + (progress * totalAngle);

    // Calculate the total width of the text and dot
    double textWidth = _calculateTextWidth(text);
    double dotWidth = textStyle.fontSize!;
    double totalWidth = textWidth + dotWidth;

    // Calculate how many times the text can fit
    int repetitions = (totalAngle * radius / totalWidth).floor();
    repetitions = math.max(1, repetitions); // Ensure at least one repetition

    double segmentAngle = totalAngle / repetitions;
    double textAngle = (textWidth / totalWidth) * segmentAngle;
    double dotAngle = segmentAngle - textAngle;

    for (int rep = 0; rep < repetitions; rep++) {
      // Draw the dot before the text
      _drawDot(canvas, centerX, centerY, startAngle, radius);

      // Adjust the start angle for the text to come after the dot
      // double textStartAngle = startAngle + dotAngle;
      double textStartAngle = startAngle + dotAngle / 2; //+ 1.5 * dotAngle;

      // Pre-calculate character widths and total width
      List<double> charWidths = [];
      double totalCharWidth = 0;
      for (int i = 0; i < text.length; i++) {
        final textSpan = TextSpan(text: text[i], style: textStyle);
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        charWidths.add(textPainter.width);
        totalCharWidth += textPainter.width;
      }

      // Draw the text
      double currentAngle = textStartAngle;
      for (int i = 0; i < text.length; i++) {
        final textSpan = TextSpan(text: text[i], style: textStyle);
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();

        // Calculate the proportion of the total angle this character should occupy
        double charProportion = charWidths[i] / totalCharWidth;
        double charAngle = textAngle * charProportion;

        // Center the character within its allocated angle
        double charCenterAngle = currentAngle + (charAngle / 2);

        final x = centerX + radius * math.cos(charCenterAngle);
        final y = centerY + radius * math.sin(charCenterAngle);

        canvas.save();
        canvas.translate(x, y);
        canvas.rotate(charCenterAngle + math.pi / 2);

        textPainter.paint(
            canvas, Offset(-charWidths[i] / 2, -textPainter.height / 2));

        canvas.restore();

        // Update the angle for the next character
        currentAngle += charAngle;
      }

      // Update the start angle for the next repetition
      startAngle += segmentAngle;
    }
  }

  double _calculateTextWidth(String text) {
    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    return textPainter.width;
  }

  void _drawDot(Canvas canvas, double centerX, double centerY, double angle,
      double radius) {
    final dotRadius = textStyle.fontSize! / 4;
    final dotPaint = Paint()
      ..color = textStyle.color!
      ..style = PaintingStyle.fill;

    final dotX = centerX + radius * math.cos(angle);
    final dotY = centerY + radius * math.sin(angle);

    canvas.drawCircle(Offset(dotX, dotY), dotRadius, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
