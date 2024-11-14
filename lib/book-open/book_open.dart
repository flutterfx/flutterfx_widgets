import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedBook extends StatefulWidget {
  final Widget coverChild;
  final Widget pageChild;
  final double? width;
  final double? height;
  final Duration animationDuration;
  final double maxOpenAngle;
  final double aspectRatio;
  final int numberOfPages;

  const AnimatedBook({
    Key? key,
    required this.coverChild,
    required this.pageChild,
    this.width,
    this.height,
    this.animationDuration = const Duration(milliseconds: 400),
    this.maxOpenAngle = 180,
    this.aspectRatio = 0.7,
    this.numberOfPages = 25,
  }) : super(key: key);

  @override
  State<AnimatedBook> createState() => _AnimatedBookState();
}

class _AnimatedBookState extends State<AnimatedBook>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isOpen = false;
  late List<Color> _colorList;

  Size _getBookDimensions(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final safeWidth = screenSize.width - padding.left - padding.right;
    final safeHeight = screenSize.height - padding.top - padding.bottom;

    final maxAllowedWidth = safeWidth / 1.6;
    final maxAllowedHeight = safeHeight * 0.8;

    if (widget.width != null && widget.height != null) {
      if (widget.width! <= maxAllowedWidth &&
          widget.height! <= maxAllowedHeight) {
        return Size(widget.width!, widget.height!);
      }
    }

    double width = maxAllowedWidth;
    double height = width / widget.aspectRatio;

    if (height > maxAllowedHeight) {
      height = maxAllowedHeight;
      width = height * widget.aspectRatio;
    }

    return Size(width, height);
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );

    _colorList = initColors(widget.numberOfPages);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleBook() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  double _getPageAngle(int index, double animationValue) {
    final pageSpacing = widget.maxOpenAngle / widget.numberOfPages;
    final targetAngle = widget.maxOpenAngle - (pageSpacing * index);
    return targetAngle * animationValue;
  }

  // Helper method to ensure opacity is within valid range
  double _clampOpacity(double value) {
    return value.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final bookDimensions = _getBookDimensions(context);

    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: bookDimensions.width * 0.3,
              vertical: 20,
            ),
            child: GestureDetector(
              onTap: _toggleBook,
              child: SizedBox(
                width: bookDimensions.width,
                height: bookDimensions.height,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Stack(
                      children: [
                        // Base page
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(_clampOpacity(0.2)),
                                  spreadRadius: 1,
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: widget.pageChild,
                          ),
                        ),

                        // Pages
                        ...List.generate(widget.numberOfPages, (index) {
                          final pageAngle =
                              _getPageAngle(index, _animation.value);
                          final normalizedIndex = index / widget.numberOfPages;

                          return Transform(
                            alignment: Alignment.centerLeft,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(pageAngle * math.pi / 180),
                            child: Container(
                              width: bookDimensions.width,
                              height: bookDimensions.height,
                              decoration: BoxDecoration(
                                color: _colorList[index],
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(
                                        _clampOpacity(
                                            0.1 * (1 - normalizedIndex))),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).reversed.toList(),

                        // Front cover
                        Transform(
                          alignment: Alignment.centerLeft,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(_getPageAngle(0, _animation.value) *
                                math.pi /
                                180),
                          child: Container(
                            width: bookDimensions.width,
                            height: bookDimensions.height,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(_clampOpacity(
                                      0.3 * (1 - _animation.value))),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: Offset(2 * (1 - _animation.value), 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: widget.coverChild,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Color> initColors(int n) {
    List<Color> colors = [];
    for (int i = 0; i < n; i++) {
      colors.add(getRandomColor());
    }
    return colors;
  }

  Color getRandomColor() {
    math.Random random = math.Random();
    return Color.fromRGBO(
      random.nextInt(256), // Red
      random.nextInt(256), // Green
      random.nextInt(256), // Blue
      1.0, // Opacity (1.0 is fully opaque)
    );
  }
}
