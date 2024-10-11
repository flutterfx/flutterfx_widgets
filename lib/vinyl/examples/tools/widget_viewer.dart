import 'dart:math';

import 'package:flutter/material.dart';

class WidgetViewer extends StatefulWidget {
  @override
  _WidgetViewerState createState() => _WidgetViewerState();
}

class _WidgetViewerState extends State<WidgetViewer> {
  double _horizontalRotation = 0;
  double _verticalRotation = 0;
  double _zRotation = 0;
  double _perspective = 0;
  double _zoom = 1;

  final List<Color> colors = [Colors.green, Colors.yellow, Colors.purple];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('3D Stacked Widget Viewer')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Transform(
                // setEntry(0, 3, x): Translates along the X-axis
                // setEntry(1, 3, y): Translates along the Y-axis
                // setEntry(2, 3, z): Translates along the Z-axis
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0003512553609721081) // perspectivez
                  // ..setEntry(3, 1, _perspective) // y
                  // ..setEntry(3, 0, _perspective) //x
                  ..rotateY(323 * pi / 180) // horixontal
                  ..rotateX(355 * pi / 180) // vertical
                  ..rotateZ(6 * pi / 180) //z : 32
                  ..scale(_zoom),
                alignment: Alignment.center,
                child: Stack(
                  children: List.generate(colors.length, (index) {
                    return Transform(
                      transform: Matrix4.identity()
                        ..translate(0.0, 0.0, -index * 50.0), // -index * 50.0
                      child: Container(
                        width: 200,
                        height: 200,
                        color: colors[index],
                        child: Center(
                          child: Text(
                            'Layer ${index + 1}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildSlider(
                  value: _horizontalRotation,
                  onChanged: (value) =>
                      setState(() => _horizontalRotation = value),
                  label:
                      'Horizontal Rotation: ${_horizontalRotation.toStringAsFixed(0)}°',
                ),
                _buildSlider(
                  value: _verticalRotation,
                  onChanged: (value) =>
                      setState(() => _verticalRotation = value),
                  label:
                      'Vertical Rotation: ${_verticalRotation.toStringAsFixed(0)}°',
                ),
                _buildSlider(
                  value: _zRotation,
                  onChanged: (value) => setState(() => _zRotation = value),
                  label: 'Z Rotation: ${_zRotation.toStringAsFixed(0)}°',
                ),
                _buildSlider(
                  value: _perspective,
                  min: -0.1,
                  max: 0.1,
                  onChanged: (value) => setState(() {
                    _perspective = value;
                    print("Perspective, value: $_perspective");
                  }),
                  label: 'Perspective: ${_perspective.toStringAsFixed(0)}°',
                ),
                _buildSlider(
                  value: _zoom,
                  min: 0.5,
                  max: 2.0,
                  onChanged: (value) => setState(() => _zoom = value),
                  label: 'Zoom: ${_zoom.toStringAsFixed(2)}x',
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _resetTransformations,
                  child: Text('Reset'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider({
    required double value,
    required ValueChanged<double> onChanged,
    required String label,
    double min = 0,
    double max = 360,
  }) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _resetTransformations() {
    setState(() {
      _horizontalRotation = 0;
      _verticalRotation = 0;
      _zoom = 1;
    });
  }
}
