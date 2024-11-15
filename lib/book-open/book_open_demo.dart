import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fx_2_folder/book-open/book_open.dart';
import 'package:fx_2_folder/book-open/design/book_cover.dart';
import 'package:fx_2_folder/book-open/grid.dart';

class BookOpenDemo extends StatefulWidget {
  const BookOpenDemo({Key? key}) : super(key: key);

  @override
  State<BookOpenDemo> createState() => _BookOpenState();
}

class _BookOpenState extends State<BookOpenDemo> {
  // Initialize transform values
  double _rotateX = 0.0;
  double _rotateY = 0.0;
  double _rotateZ = 0.0;

  Widget _buildSlider({
    required String axis,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Axis label and value
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                axis.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              Text(
                '${value.toStringAsFixed(0)}°',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Menlo', // Using monospace font for values
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Custom styled slider
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 2,
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white.withOpacity(0.3),
              thumbColor: Colors.white,
              overlayColor: Colors.white.withOpacity(0.1),
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 6,
                elevation: 0,
              ),
              overlayShape: const RoundSliderOverlayShape(
                overlayRadius: 16,
              ),
            ),
            child: Slider(
              value: value,
              min: -180,
              max: 180,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Book display area
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: GridPatternPainter(isDarkMode: true),
                  ),
                ),
                Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateX(_rotateX * pi / 180)
                    ..rotateY(_rotateY * pi / 180)
                    ..rotateZ(_rotateZ * pi / 180),
                  alignment: Alignment.center,
                  child: const AnimatedBook(
                    coverChild: MinimalistBookCover(
                      title: 'The Subtle Art\nof Not Giving\na F*ck',
                      author: 'Mark Manson',
                      backgroundColor: Color(0xFFFF6B6B),
                      textColor: Colors.white,
                    ),
                    pageChild: Text('Book content ..'),
                    width: 150,
                    height: 200,
                    maxOpenAngle: 89,
                    numberOfPages: 25,
                  ),
                ),
                // place one at the bottom of stack
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: // Transform controls panel
                      Container(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildSlider(
                          axis: 'X',
                          value: _rotateX,
                          onChanged: (value) =>
                              setState(() => _rotateX = value),
                        ),
                        _buildSlider(
                          axis: 'Y',
                          value: _rotateY,
                          onChanged: (value) =>
                              setState(() => _rotateY = value),
                        ),
                        _buildSlider(
                          axis: 'Z',
                          value: _rotateZ,
                          onChanged: (value) =>
                              setState(() => _rotateZ = value),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
