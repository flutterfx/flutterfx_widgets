import 'dart:math';

import 'package:flutter/material.dart';

class CirclesHomeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CircleHomeState();
}

class _CircleHomeState extends State<CirclesHomeWidget> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PannableCircleGrid(),
    );
  }
}

class PannableCircleGrid extends StatefulWidget {
  const PannableCircleGrid({Key? key}) : super(key: key);

  @override
  _PannableCircleGridState createState() => _PannableCircleGridState();
}

class _PannableCircleGridState extends State<PannableCircleGrid> {
  Offset _offset = Offset.zero;
  int? _selectedIndex;
  final double _circleSize = 80;
  final double _selectedCircleMultiplier = 1.5;
  final double _spacing = 1;
  final int _columns = 1000; // Arbitrary large number for columns

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _offset += details.delta;
        });
      },
      child: ClipRect(
        child: CustomPaint(
          painter: CircleGridPainter(
            offset: _offset,
            circleSize: _circleSize,
            selectedCircleMultiplier: _selectedCircleMultiplier,
            spacing: _spacing,
            selectedIndex: _selectedIndex,
            columns: _columns,
          ),
          child: GestureDetector(
            onTapUp: (details) {
              _handleTap(details.localPosition);
            },
          ),
        ),
      ),
    );
  }

  void _handleTap(Offset tapPosition) {
    int col =
        ((tapPosition.dx - _offset.dx) / (_circleSize + _spacing)).floor();
    int row =
        ((tapPosition.dy - _offset.dy) / (_circleSize + _spacing)).floor();
    int index = row * _columns + col;
    setState(() {
      _selectedIndex = (_selectedIndex == index) ? null : index;
    });
  }
}

class CircleGridPainter extends CustomPainter {
  final Offset offset;
  final double circleSize;
  final double selectedCircleMultiplier;
  final double spacing;
  final int? selectedIndex;
  final int columns;

  CircleGridPainter({
    required this.offset,
    required this.circleSize,
    required this.selectedCircleMultiplier,
    required this.spacing,
    required this.columns,
    this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill;

    final selectedPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final startCol = (-offset.dx / (circleSize + spacing)).floor() - 1;
    final endCol = ((size.width - offset.dx) / (circleSize + spacing)).ceil();
    final startRow = (-offset.dy / (circleSize + spacing)).floor() - 1;
    final endRow = ((size.height - offset.dy) / (circleSize + spacing)).ceil();

    // Calculate displacements for all affected circles
    Map<Point<int>, Offset> displacements = {};
    if (selectedIndex != null) {
      int selectedCol = selectedIndex! % columns;
      int selectedRow = selectedIndex! ~/ columns;

      for (int row = startRow - 1; row <= endRow + 1; row++) {
        for (int col = startCol - 1; col <= endCol + 1; col++) {
          int dx = col - selectedCol;
          int dy = row - selectedRow;

          int index = row * columns + col;
          bool isSelected = selectedIndex == index;

          // Check if the circle is in the first coat
          if (dx.abs() <= 1 && dy.abs() <= 1 && (dx != 0 || dy != 0)) {
            double currentCenterDistance =
                sqrt(dx * dx + dy * dy) * (circleSize + spacing);
            double selectedCircleRadius =
                isSelected ? circleSize * selectedCircleMultiplier : circleSize;
            double neighborCircleRadius = circleSize * 0.5;

            double currentEdgeDistance = currentCenterDistance -
                selectedCircleRadius -
                neighborCircleRadius;
            double minRequiredEdgeDistance = spacing;

            // Only displace if current edge distance is less than required
            if (currentEdgeDistance < minRequiredEdgeDistance) {
              double angle = atan2(dy.toDouble(), dx.toDouble());
              double targetCenterDistance = selectedCircleRadius +
                  neighborCircleRadius +
                  minRequiredEdgeDistance;
              double displacement =
                  targetCenterDistance - currentCenterDistance;

              displacements[Point(col, row)] = Offset(
                cos(angle) * displacement,
                sin(angle) * displacement,
              );
            }
          }
        }
      }
    }

    // Draw circles with calculated displacements
    for (int row = startRow; row <= endRow; row++) {
      for (int col = startCol; col <= endCol; col++) {
        int index = row * columns + col;
        bool isSelected = selectedIndex == index;

        Offset circleOffset = Offset(
          col * (circleSize + spacing) + offset.dx,
          row * (circleSize + spacing) + offset.dy,
        );

        // Apply displacement if exists
        if (displacements.containsKey(Point(col, row))) {
          circleOffset += displacements[Point(col, row)]!;
        }

        double currentCircleSize =
            isSelected ? circleSize * selectedCircleMultiplier : circleSize;

        canvas.drawCircle(
          circleOffset,
          currentCircleSize / 2,
          isSelected ? selectedPaint : paint,
        );
        textPainter.text = TextSpan(
          text: '$index',
          style: TextStyle(
              color: isSelected ? Colors.black : Colors.white, fontSize: 12),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          circleOffset - Offset(textPainter.width / 2, textPainter.height / 2),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CircleGridPainter oldDelegate) =>
      offset != oldDelegate.offset ||
      selectedIndex != oldDelegate.selectedIndex;
}
