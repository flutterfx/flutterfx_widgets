import 'dart:math';

import 'package:flutter/material.dart';

class CirclesHomeWidget extends StatelessWidget {
  const CirclesHomeWidget({Key? key}) : super(key: key);

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

class _PannableCircleGridState extends State<PannableCircleGrid>
    with TickerProviderStateMixin {
  static const double _circleSize = 80;
  static const double _selectedCircleMultiplier = 2;
  static const double _spacing = 10;
  static const int _columns = 1000;

  Offset _offset = Offset.zero;
  Map<int, AnimationController> _animationControllers = {};
  int? _selectedIndex;

  @override
  void dispose() {
    for (var controller in _animationControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // void _handleAnimationStatus(AnimationStatus status) {
  //   if (status == AnimationStatus.completed ||
  //       status == AnimationStatus.dismissed) {
  //     setState(() {
  //       if (_animationController.status == AnimationStatus.dismissed) {
  //         _deselectedIndex = null;
  //       }
  //     }); // Trigger a rebuild to ensure final state is painted
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _handlePan,
      child: ClipRect(
        child: AnimatedBuilder(
          animation: Listenable.merge(_animationControllers.values.toList()),
          builder: (context, child) {
            return CustomPaint(
              painter: CircleGridPainter(
                offset: _offset,
                circleSize: _circleSize,
                selectedCircleMultiplier: _selectedCircleMultiplier,
                spacing: _spacing,
                selectedIndex: _selectedIndex,
                columns: _columns,
                animationControllers: _animationControllers,
              ),
              child: GestureDetector(
                onTapUp: _handleTap,
              ),
            );
          },
        ),
      ),
    );
  }

  void _handlePan(DragUpdateDetails details) {
    setState(() {
      _offset += details.delta;
    });
  }

  void _handleTap(TapUpDetails details) {
    final tapPosition = details.localPosition;
    int col =
        ((tapPosition.dx - _offset.dx) / (_circleSize + _spacing)).floor();
    int row =
        ((tapPosition.dy - _offset.dy) / (_circleSize + _spacing)).floor();
    int tappedIndex = row * _columns + col;

    setState(() {
      if (_selectedIndex == tappedIndex) {
        // Case 1: Tapping the same circle
        _animationControllers[tappedIndex]?.reverse().then((_) {
          if (mounted) {
            setState(() {
              _animationControllers.remove(tappedIndex);
              _selectedIndex = null;
            });
          }
        });
      } else {
        // Case 2: Tapping a different circle
        if (_selectedIndex != null) {
          int? __selectedIndex = _selectedIndex;
          // Collapse the previously selected circle
          _animationControllers[_selectedIndex]?.reverse().then((_) {
            if (mounted) {
              setState(() {
                _animationControllers.remove(__selectedIndex);
              });
            }
          });
        }

        // Expand the newly tapped circle
        _animationControllers[tappedIndex] = AnimationController(
          duration: const Duration(milliseconds: 300),
          vsync: this,
        )..forward();

        _selectedIndex = tappedIndex;
      }
    });

    // if (_animationControllers.containsKey(tappedIndex)) {
    //   // Collapse the tapped circle
    //   _animationControllers[tappedIndex]!.reverse().then((_) {
    //     setState(() {
    //       _animationControllers.remove(tappedIndex);
    //       if (_selectedIndex == tappedIndex) {
    //         _selectedIndex = null;
    //       }
    //     });
    //   });
    // } else {
    //   // Expand the tapped circle
    //   _animationControllers[tappedIndex] = AnimationController(
    //     duration: const Duration(milliseconds: 300),
    //     vsync: this,
    //   )..forward();

    //   // Collapse the previously selected circle, if any
    //   if (_selectedIndex != null && _selectedIndex != tappedIndex) {
    //     _animationControllers[_selectedIndex!]?.reverse().then((_) {
    //       setState(() {
    //         _animationControllers.remove(_selectedIndex);
    //       });
    //     });
    //   }

    //   setState(() {
    //     _selectedIndex = tappedIndex;
    //   });
    // }
  }
}

class CircleGridPainter extends CustomPainter {
  final Offset offset;
  final double circleSize;
  final double selectedCircleMultiplier;
  final double spacing;
  final int? selectedIndex;
  final int columns;
  final Map<int, AnimationController> animationControllers;

  static const double maxDisplacementDistance =
      6.0; // Maximum distance for displacement effect
  static const double fullDisplacementDistance =
      0.5; // Distance for full displacement
  static const double falloffExponent =
      1.0; // Controls the steepness of falloff

  CircleGridPainter({
    required this.offset,
    required this.circleSize,
    required this.selectedCircleMultiplier,
    required this.spacing,
    required this.columns,
    this.selectedIndex,
    required this.animationControllers,
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

    final visibleArea = _calculateVisibleArea(size);
    final displacements = _calculateDisplacements(visibleArea);

    _drawCircles(
        canvas, visibleArea, displacements, paint, selectedPaint, textPainter);
  }

  _VisibleArea _calculateVisibleArea(Size size) {
    return _VisibleArea(
      startCol: (-offset.dx / (circleSize + spacing)).floor() - 1,
      endCol: ((size.width - offset.dx) / (circleSize + spacing)).ceil(),
      startRow: (-offset.dy / (circleSize + spacing)).floor() - 1,
      endRow: ((size.height - offset.dy) / (circleSize + spacing)).ceil(),
    );
  }

  Map<Point<int>, Offset> _calculateDisplacements(_VisibleArea visibleArea) {
    Map<Point<int>, Offset> displacements = {};
    for (var entry in animationControllers.entries) {
      int selectedIndex = entry.key;
      double animationValue = entry.value.value;

      int selectedCol = selectedIndex % columns;
      int selectedRow = selectedIndex ~/ columns;
      double expansionAmount =
          circleSize * (selectedCircleMultiplier - 1) / 2 * animationValue;
      double defaultSpacing = circleSize + spacing;

      for (int row = visibleArea.startRow - 2;
          row <= visibleArea.endRow + 2;
          row++) {
        for (int col = visibleArea.startCol - 2;
            col <= visibleArea.endCol + 2;
            col++) {
          if (row != selectedRow || col != selectedCol) {
            _calculateDisplacement(col, row, selectedCol, selectedRow,
                expansionAmount, defaultSpacing, displacements);
          }
        }
      }
    }
    return displacements;
  }

  void _calculateDisplacement(
      int col,
      int row,
      int selectedCol,
      int selectedRow,
      double expansionAmount,
      double defaultSpacing,
      Map<Point<int>, Offset> displacements) {
    int dx = col - selectedCol;
    int dy = row - selectedRow;
    double distance = sqrt(dx * dx + dy * dy);
    double angle = atan2(dy.toDouble(), dx.toDouble());

    // Determine if the circle is diagonal or orthogonal
    bool isDiagonal = dx != 0 && dy != 0;

    // Calculate the base displacement
    double displacement =
        _getDisplacementFixed(distance, expansionAmount, defaultSpacing);

    // diagonal adjustment
    if (isDiagonal) {
      double diagonalCorrectionFactor =
          0.1; // or use 1 / sqrt(2) ≈ 0.707 for exact diagonal adjustment
      displacement *= diagonalCorrectionFactor;
    }

    if (displacement > 0) {
      Point<int> point = Point(col, row);
      Offset newDisplacement = Offset(
        cos(angle) * displacement,
        sin(angle) * displacement,
      );

      if (displacements.containsKey(point)) {
        displacements[point] = displacements[point]! + newDisplacement;
      } else {
        displacements[point] = newDisplacement;
      }
    }
  }

  double _getDisplacementFixed(
      double distance, double expansionAmount, double defaultSpacing) {
    if (distance <= maxDisplacementDistance) {
      double falloffFactor = _calculateFalloffFactor(distance);
      return expansionAmount * falloffFactor;
    }
    return 0;
  }

  double _calculateFalloffFactor(double distance) {
    if (distance <= fullDisplacementDistance) {
      return 1.0;
    } else if (distance >= maxDisplacementDistance) {
      return 0.0;
    } else {
      double t = (distance - fullDisplacementDistance) /
          (maxDisplacementDistance - fullDisplacementDistance);
      return pow(1 - t, falloffExponent).toDouble();
    }
  }

  void _drawCircles(
      Canvas canvas,
      _VisibleArea visibleArea,
      Map<Point<int>, Offset> displacements,
      Paint paint,
      Paint selectedPaint,
      TextPainter textPainter) {
    for (int row = visibleArea.startRow; row <= visibleArea.endRow; row++) {
      for (int col = visibleArea.startCol; col <= visibleArea.endCol; col++) {
        int index = row * columns + col;
        bool isSelected = index == selectedIndex;

        Offset circleOffset = Offset(
          col * (circleSize + spacing) + offset.dx,
          row * (circleSize + spacing) + offset.dy,
        );

        // if (!isSelected && displacements.containsKey(Point(col, row))) {
        //   circleOffset += displacements[Point(col, row)]! * animationValue;
        // }
        if (displacements.containsKey(Point(col, row))) {
          circleOffset += displacements[Point(col, row)]!;
        }

        double currentCircleSize = circleSize;
        Paint currentPaint = paint;

        if (animationControllers.containsKey(index)) {
          double animationValue = animationControllers[index]?.value ?? 0.0;
          currentCircleSize +=
              (circleSize * (selectedCircleMultiplier - 1) * animationValue);
          currentPaint = Paint()
            ..color =
                Color.lerp(paint.color, selectedPaint.color, animationValue)!
            ..style = PaintingStyle.fill;
        }

        // double currentCircleSize = isSelected
        //     ? circleSize +
        //         (circleSize *
        //             (selectedCircleMultiplier - 1) *
        //             animationControllers[index]!.value)
        //     : circleSize;

        canvas.drawCircle(
          circleOffset,
          currentCircleSize / 2,
          currentPaint,
        );

        _drawText(
            canvas, textPainter, circleOffset, index.toString(), isSelected);
      }
    }
  }

  void _drawText(Canvas canvas, TextPainter textPainter, Offset position,
      String text, bool isSelected) {
    textPainter.text = TextSpan(
      text: text,
      style: TextStyle(
          color: isSelected ? Colors.black : Colors.white, fontSize: 12),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      position - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CircleGridPainter oldDelegate) => true;
  // =>
  //     offset != oldDelegate.offset ||
  //     animationControllers != oldDelegate.animationControllers;
}

class _VisibleArea {
  final int startCol;
  final int endCol;
  final int startRow;
  final int endRow;

  _VisibleArea({
    required this.startCol,
    required this.endCol,
    required this.startRow,
    required this.endRow,
  });
}
