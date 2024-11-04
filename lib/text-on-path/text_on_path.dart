import 'dart:ui';

import 'package:flutter/material.dart';

class TextOnPathWidget extends StatelessWidget {
  final String text;
  final double fontSize;

  const TextOnPathWidget({
    Key? key,
    required this.text,
    this.fontSize = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TextOnPathPainter(
        text: text,
        path: _createSamplePath(), // We'll make this dynamic later
        fontSize: fontSize,
        textStyle: TextStyle(
          fontSize: fontSize,
          color: Colors.black,
        ),
      ),
      child: Container(), // Size will be determined by parent
    );
  }

  Path _createSamplePath() {
    final path = Path();
    path.moveTo(50, 100);
    path.cubicTo(100, 50, 200, 150, 250, 100);
    return path;
  }
}

class TextOnPathPainter extends CustomPainter {
  final String text;
  final Path path;
  final double fontSize;
  final TextStyle textStyle;

  TextOnPathPainter({
    required this.text,
    required this.path,
    this.fontSize = 20,
    required this.textStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // First, get path metrics to measure distances along the path
    final PathMetric pathMetric = path.computeMetrics().first;
    final double pathLength = pathMetric.length;

    // Calculate spacing between characters
    final textSpan = TextSpan(
        text: "A", style: textStyle); // Sample character for measurement
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final charWidth = textPainter.width;

    // Space needed for entire text
    final totalTextLength = charWidth * text.length;

    // Starting offset to center text on path
    final startOffset = (pathLength - totalTextLength) / 2;

    // Draw each character
    for (int i = 0; i < text.length; i++) {
      final double charOffset = startOffset + (i * charWidth);
      if (charOffset < 0 || charOffset > pathLength) continue;

      // Get position and tangent angle at this point
      final Tangent? tangent = pathMetric.getTangentForOffset(charOffset);
      if (tangent == null) continue;

      // Save canvas state
      canvas.save();

      // Move to position and rotate canvas
      canvas.translate(tangent.position.dx, tangent.position.dy);
      canvas.rotate(tangent.angle);

      // Create text painter for this character
      final charTextPainter = TextPainter(
        text: TextSpan(
          text: text[i],
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      );

      // Layout and paint the character
      charTextPainter.layout();
      charTextPainter.paint(canvas, Offset(-charTextPainter.width / 2, 0));

      // Restore canvas state
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

//---- bezier
class BezierTextOnPath extends StatefulWidget {
  final String text;
  final double fontSize;

  const BezierTextOnPath({
    Key? key,
    required this.text,
    this.fontSize = 20,
  }) : super(key: key);

  @override
  State<BezierTextOnPath> createState() => _BezierTextOnPathState();
}

class _BezierTextOnPathState extends State<BezierTextOnPath> {
  // Control points for the Bezier curve
  late List<Offset> _controlPoints;
  int? _draggedPointIndex;

  @override
  void initState() {
    super.initState();
    // Initialize control points
    _controlPoints = [
      Offset(100, 200), // Start point
      Offset(200, 100), // Control point 1
      Offset(300, 300), // Control point 2
      Offset(400, 200), // End point
    ];
  }

  // Create path from control points
  Path _createPath() {
    final path = Path();
    path.moveTo(_controlPoints[0].dx, _controlPoints[0].dy);
    path.cubicTo(
      _controlPoints[1].dx,
      _controlPoints[1].dy,
      _controlPoints[2].dx,
      _controlPoints[2].dy,
      _controlPoints[3].dx,
      _controlPoints[3].dy,
    );
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      child: CustomPaint(
        painter: BezierTextPainter(
          text: widget.text,
          fontSize: widget.fontSize,
          controlPoints: _controlPoints,
          path: _createPath(),
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }

  void _handlePanStart(DragStartDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.globalToLocal(details.globalPosition);

    // Find if we're near any control point
    for (int i = 0; i < _controlPoints.length; i++) {
      if ((position - _controlPoints[i]).distance < 20) {
        setState(() {
          _draggedPointIndex = i;
        });
        break;
      }
    }
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (_draggedPointIndex != null) {
      setState(() {
        _controlPoints[_draggedPointIndex!] += details.delta;
      });
    }
  }

  void _handlePanEnd(DragEndDetails details) {
    setState(() {
      _draggedPointIndex = null;
    });
  }
}

class BezierTextPainter extends CustomPainter {
  final String text;
  final double fontSize;
  final List<Offset> controlPoints;
  final Path path;
  final Paint _paint;

  BezierTextPainter({
    required this.text,
    required this.fontSize,
    required this.controlPoints,
    required this.path,
  }) : _paint = Paint()
          ..color = Colors.white70
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the curve
    canvas.drawPath(path, _paint);

    // Draw control points and lines
    _drawControlPoints(canvas);
    _drawControlLines(canvas);

    // Draw text on path
    _drawTextOnPath(canvas);
  }

  void _drawControlPoints(Canvas canvas) {
    final pointPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    for (final point in controlPoints) {
      canvas.drawCircle(point, 8, pointPaint);
    }
  }

  void _drawControlLines(Canvas canvas) {
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw lines between control points
    canvas.drawLine(controlPoints[0], controlPoints[1], linePaint);
    canvas.drawLine(controlPoints[2], controlPoints[3], linePaint);
  }

  void _drawTextOnPath(Canvas canvas) {
    final PathMetric pathMetric = path.computeMetrics().first;
    final double pathLength = pathMetric.length;

    // Calculate text metrics
    final textSpan = TextSpan(
      text: "A",
      style: TextStyle(fontSize: fontSize, color: Colors.white70),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final charWidth = textPainter.width;

    final totalTextLength = charWidth * text.length;
    final startOffset = (pathLength - totalTextLength) / 2;

    // Draw each character along the path
    for (int i = 0; i < text.length; i++) {
      final double charOffset = startOffset + (i * charWidth);
      if (charOffset < 0 || charOffset > pathLength) continue;

      final Tangent? tangent = pathMetric.getTangentForOffset(charOffset);
      if (tangent == null) continue;

      canvas.save();

      canvas.translate(tangent.position.dx, tangent.position.dy);
      canvas.rotate(tangent.angle);

      final charTextPainter = TextPainter(
        text: TextSpan(
          text: text[i],
          style: TextStyle(fontSize: fontSize, color: Colors.white70),
        ),
        textDirection: TextDirection.ltr,
      );

      charTextPainter.layout();
      charTextPainter.paint(
          canvas, Offset(-charTextPainter.width / 2, -fontSize));

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
