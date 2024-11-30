import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ThreadedWidget extends StatelessWidget {
  final Widget child;
  final Color threadColor;
  final double topSpacing;
  final double bottomSpacing;
  final double curvature;
  final double wrapCurvature;
  final bool debugMode; // New parameter for debug mode

  const ThreadedWidget({
    super.key,
    required this.child,
    this.threadColor = Colors.white,
    this.topSpacing = 0.2,
    this.bottomSpacing = 0.15,
    this.curvature = 0.3,
    this.wrapCurvature = 0.05,
    this.debugMode = false, // Default to false
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        LayoutBuilder(
          builder: (context, constraints) {
            return CustomPaint(
              painter: ThreadPainter(
                threadColor: threadColor,
                topSpacing: topSpacing,
                bottomSpacing: bottomSpacing,
                curvature: curvature,
                wrapCurvature: wrapCurvature,
                debugMode: debugMode,
              ),
              size: Size(constraints.maxWidth, constraints.maxHeight),
            );
          },
        ),
      ],
    );
  }
}

class ThreadPainter extends CustomPainter {
  final Color threadColor;
  final double topSpacing;
  final double bottomSpacing;
  final double curvature;
  final double wrapCurvature;
  final bool debugMode;

  ThreadPainter({
    required this.threadColor,
    required this.topSpacing,
    required this.bottomSpacing,
    required this.curvature,
    required this.wrapCurvature,
    required this.debugMode,
  });

  // Debug paint objects
  late final Paint _debugPointPaint = Paint()
    ..color = Colors.red
    ..strokeWidth = 6
    ..strokeCap = StrokeCap.round;

  late final Paint _debugControlPointPaint = Paint()
    ..color = Colors.purple
    ..strokeWidth = 4
    ..strokeCap = StrokeCap.round;

  late final Paint _debugWrapControlPointPaint = Paint()
    ..color = Colors.green
    ..strokeWidth = 4
    ..strokeCap = StrokeCap.round;

  late final Paint _debugLinePaint = Paint()
    ..color = Colors.purple.withOpacity(0.3)
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke;

  void _drawDebugPoint(Canvas canvas, Offset point, String label, Paint paint) {
    canvas.drawPoints(ui.PointMode.points, [point], paint);

    final textSpan = TextSpan(
      text: label,
      style: TextStyle(
        color: paint.color,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(canvas, point + const Offset(5, -15));
  }

  void _drawDebugLine(Canvas canvas, Offset start, Offset end) {
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..lineTo(end.dx, end.dy);

    // Draw dashed line using dotted effect
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.purple.withOpacity(0.3)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        // Simpler approach using just dots
        ..shader = ui.Gradient.linear(
            start,
            end,
            [Colors.purple.withOpacity(0.3), Colors.transparent],
            [0, 0.5],
            TileMode.repeated,
            Float64List.fromList(Matrix4.identity().storage)),
    );
  }

  void _drawTopWrap(Canvas canvas, Paint paint, Offset point, Size size) {
    final path = Path();
    path.moveTo(point.dx, point.dy);

    // Adjust control point position
    final controlPoint = Offset(
      point.dx + size.width * wrapCurvature,
      point.dy -
          size.height * wrapCurvature * 1.0, // Keeps the same vertical curve
    );

    // Reduce the horizontal distance of the end point
    final endPoint = Offset(
      point.dx + size.width * wrapCurvature * 1.2, // Reduced from 2 to 1.2
      point.dy, // Keeps at the top edge
    );

    path.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );

    canvas.drawPath(path, paint);

    if (debugMode) {
      _drawDebugPoint(canvas, controlPoint, 'TW', _debugWrapControlPointPaint);
      _drawDebugLine(canvas, point, controlPoint);
      _drawDebugLine(canvas, controlPoint, endPoint);
    }
  }

  void _drawBottomWrap(Canvas canvas, Paint paint, Offset point, Size size) {
    final path = Path();
    path.moveTo(point.dx, point.dy);

    // Adjust control point position
    final controlPoint = Offset(
      point.dx - size.width * wrapCurvature,
      point.dy +
          size.height *
              wrapCurvature *
              1.5, // Matches top wrap's vertical proportion
    );

    // Modify end point to match top wrap's shorter distance
    final endPoint = Offset(
      point.dx -
          size.width * wrapCurvature * 1.2, // Matches top wrap's 1.2 multiplier
      point.dy, // Keeps it at the bottom edge
    );

    path.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );

    canvas.drawPath(path, paint);

    if (debugMode) {
      _drawDebugPoint(canvas, controlPoint, 'BW', _debugWrapControlPointPaint);
      _drawDebugLine(canvas, point, controlPoint);
      _drawDebugLine(canvas, controlPoint, endPoint);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = threadColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const threadCount = 4;

    // Generate points
    final List<Offset> topPoints = List.generate(
      threadCount,
      (i) => Offset(
        size.width * (0.2 + i * topSpacing),
        0,
      ),
    );

    final List<Offset> bottomPoints = List.generate(
      threadCount,
      (i) => Offset(
        size.width * (0.1 + i * bottomSpacing),
        size.height,
      ),
    );

    // Draw the connections
    for (var i = 0; i < threadCount; i++) {
      final startPoint = bottomPoints[i];
      final endPoint = topPoints[i];

      // Draw bottom wrap
      _drawBottomWrap(canvas, paint, startPoint, size);

      // Control points for the main curve
      final controlPoint1 = Offset(
        startPoint.dx + (endPoint.dx - startPoint.dx) * 0.5,
        startPoint.dy - size.height * curvature,
      );

      final controlPoint2 = Offset(
        endPoint.dx - (endPoint.dx - startPoint.dx) * 0.5,
        endPoint.dy + size.height * curvature,
      );

      // Draw main curved line
      final path = Path();
      path.moveTo(startPoint.dx, startPoint.dy);
      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        endPoint.dx,
        endPoint.dy,
      );
      canvas.drawPath(path, paint);

      // Draw top wrap
      _drawTopWrap(canvas, paint, endPoint, size);

      // Debug visualization
      if (debugMode) {
        // Draw points
        _drawDebugPoint(
            canvas, startPoint, 'P${i + 1}_bottom', _debugPointPaint);
        _drawDebugPoint(canvas, endPoint, 'P${i + 1}_top', _debugPointPaint);

        // Draw control points
        _drawDebugPoint(
            canvas, controlPoint1, 'C1_${i + 1}', _debugControlPointPaint);
        _drawDebugPoint(
            canvas, controlPoint2, 'C2_${i + 1}', _debugControlPointPaint);

        // Draw control lines
        _drawDebugLine(canvas, startPoint, controlPoint1);
        _drawDebugLine(canvas, controlPoint1, controlPoint2);
        _drawDebugLine(canvas, controlPoint2, endPoint);
      }
    }

    // Draw legend if in debug mode
    if (debugMode) {
      _drawLegend(canvas, size);
    }
  }

  void _drawLegend(Canvas canvas, Size size) {
    const startX = 10.0;
    const startY = 10.0;
    const spacing = 60.0;

    final legendItems = [
      ('Top/Bottom', _debugPointPaint),
      ('Controls', _debugControlPointPaint),
      ('Wrap', _debugWrapControlPointPaint),
    ];

    for (var i = 0; i < legendItems.length; i++) {
      final x = startX + (spacing * i);
      canvas.drawCircle(
        Offset(x, startY),
        3,
        legendItems[i].$2,
      );

      final textSpan = TextSpan(
        text: legendItems[i].$1,
        style: TextStyle(
          color: legendItems[i].$2.color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(canvas, Offset(x + 8, startY - 5));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Example usage with debug mode:
class DecorationThreadDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        height: 100,
        child: ThreadedWidget(
          threadColor: Colors.white,
          topSpacing: 0.2,
          bottomSpacing: 0.15,
          curvature: 0.3,
          wrapCurvature: 0.05,
          debugMode: false, // Enable debug visualization
          child: Container(
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                'Completed',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
