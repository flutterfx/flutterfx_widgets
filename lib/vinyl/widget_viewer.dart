import 'dart:math';

import 'package:flutter/material.dart';

class WidgetViewer extends StatefulWidget {
  @override
  _WidgetViewerState createState() => _WidgetViewerState();
}

class _WidgetViewerState extends State<WidgetViewer> {
  double _horizontalRotation = 0;
  double _verticalRotation = 0;
  double _zoom = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('3D Widget Viewer')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // perspective
                  ..rotateY(_horizontalRotation * pi / 180)
                  ..rotateX(_verticalRotation * pi / 180)
                  ..scale(_zoom),
                alignment: Alignment.center,
                child: Container(
                  width: 200,
                  height: 200,
                  color: Colors.blue,
                  child: Center(
                      child: Text('2D Widget',
                          style: TextStyle(color: Colors.white))),
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
