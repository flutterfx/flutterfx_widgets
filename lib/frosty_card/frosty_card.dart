import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class FrostyCardDemo extends StatefulWidget {
  const FrostyCardDemo({Key? key}) : super(key: key);

  @override
  _FrostyCardDemoState createState() => _FrostyCardDemoState();
}

class _FrostyCardDemoState extends State<FrostyCardDemo>
    with SingleTickerProviderStateMixin {
  double _borderRadius = 20;
  double _blurValue = 10;
  double _opacity = 0.2;
  Color _color = Colors.white.withOpacity(0.2);
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _controller.addListener(() {
      setState(() {}); // This triggers a rebuild on each animation frame
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Frosty Card Demo')),
      body: Stack(
        children: [
          // Animated Background
          CustomPaint(
            painter: BackgroundPainter(_controller.value),
            size: Size.infinite,
          ),
          // Frosty Card
          Center(
            child: FrostyCard(
              borderRadius: _borderRadius,
              blurValue: _blurValue,
              opacity: _opacity,
              color: _color,
            ),
          ),
          // Controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.black54,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSlider('Border Radius', _borderRadius, 0, 50, (value) {
                    setState(() => _borderRadius = value);
                  }),
                  _buildSlider('Blur', _blurValue, 0, 20, (value) {
                    setState(() => _blurValue = value);
                  }),
                  _buildSlider('Opacity', _opacity, 0, 1, (value) {
                    setState(() => _opacity = value);
                  }),
                  ElevatedButton(
                    onPressed: _showColorPicker,
                    child: const Text('Change Color'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(String label, double value, double min, double max,
      ValueChanged<double> onChanged) {
    return Row(
      children: [
        Text(label),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
        Text(value.toStringAsFixed(2)),
      ],
    );
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _color,
              onColorChanged: (Color color) {
                setState(() => _color = color.withOpacity(_opacity));
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class FrostyCard extends StatelessWidget {
  final double borderRadius;
  final double blurValue;
  final double opacity;
  final Color color;

  const FrostyCard({
    Key? key,
    required this.borderRadius,
    required this.blurValue,
    required this.opacity,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
        child: Container(
          width: 300,
          height: 200,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: const Center(
            child: Text(
              'Frosty Card',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final double animationValue;

  BackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Background gradient
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Colors.blue.shade900, Colors.purple.shade900],
    );
    paint.shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);

    // Animated circles
    final circleColors = [
      Colors.blue.withOpacity(0.7),
      Colors.purple.withOpacity(0.7),
      Colors.pink.withOpacity(0.7),
    ];

    for (int i = 0; i < 3; i++) {
      final center = Offset(
        size.width * (0.2 + 0.6 * ((animationValue + i / 3) % 1)),
        size.height *
            (0.2 + 0.6 * sin(2 * pi * ((animationValue + i / 3) % 1))),
      );
      final radius = size.width * 0.2;
      paint.color = circleColors[i];
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
