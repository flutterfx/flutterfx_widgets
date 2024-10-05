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
  final double _circleSize = 60;
  final double _spacing = 20;
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
  final double spacing;
  final int? selectedIndex;
  final int columns;

  CircleGridPainter({
    required this.offset,
    required this.circleSize,
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

    for (int row = startRow; row <= endRow; row++) {
      for (int col = startCol; col <= endCol; col++) {
        final circleOffset = Offset(
          col * (circleSize + spacing) + offset.dx,
          row * (circleSize + spacing) + offset.dy,
        );

        int index = row * columns + col;
        bool isSelected = selectedIndex == index;

        canvas.drawCircle(
          circleOffset,
          isSelected ? circleSize * 0.6 : circleSize * 0.5,
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
