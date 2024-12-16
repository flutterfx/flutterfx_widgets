import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:fx_2_folder/debug-overlay-3D/demo_animated_widget.dart';
import 'package:fx_2_folder/stacked-cards/stacked_card.dart';
import 'package:fx_2_folder/vinyl/vinyl.dart';

/// A widget that wraps content in a debug overlay allowing 3D inspection
class DebugTransformOverlay extends StatefulWidget {
  final Widget child;
  final bool enabled;

  const DebugTransformOverlay({
    Key? key,
    required this.child,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<DebugTransformOverlay> createState() => _DebugTransformOverlayState();
}

class _DebugTransformOverlayState extends State<DebugTransformOverlay> {
  // Track rotation angles
  double _rotationX = 0.0;
  double _rotationY = 0.0;
  double _rotationZ = 0.0;

  // Track scale and translation
  double _scale = 1.0;
  Offset _translation = Offset.zero;

  // Track previous scale value for delta calculation
  double _previousScale = 1.0;

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return Stack(
      children: [
        // Transformed content
        GestureDetector(
          onScaleStart: (details) {
            _previousScale = _scale;
          },
          onScaleUpdate: (details) {
            setState(() {
              // Handle rotation using focal point delta
              if (details.pointerCount == 1) {
                _rotationY += details.focalPointDelta.dx * 0.01;
                _rotationX += details.focalPointDelta.dy * 0.01;
              }

              // Handle scaling
              if (details.scale != 1.0) {
                _scale = _previousScale * details.scale;
              }

              // Handle translation
              if (details.pointerCount == 2) {
                _translation += details.focalPointDelta;
              }
            });
          },
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // perspective
              ..rotateX(_rotationX)
              ..rotateY(_rotationY)
              ..rotateZ(_rotationZ)
              ..scale(_scale)
              ..translate(_translation.dx, _translation.dy),
            alignment: Alignment.center,
            child: widget.child,
          ),
        ),

        // Debug controls overlay
        Positioned(
          top: 40,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Gestures:', style: TextStyle(color: Colors.white)),
                Text('• Single finger drag: Rotate',
                    style: TextStyle(color: Colors.white)),
                Text('• Two finger pinch: Scale',
                    style: TextStyle(color: Colors.white)),
                Text('• Two finger pan: Move',
                    style: TextStyle(color: Colors.white)),
                const SizedBox(height: 8),
                _buildRotationSlider(
                  label: 'X Rotation',
                  value: _rotationX,
                  onChanged: (value) => setState(() => _rotationX = value),
                ),
                _buildRotationSlider(
                  label: 'Y Rotation',
                  value: _rotationY,
                  onChanged: (value) => setState(() => _rotationY = value),
                ),
                _buildRotationSlider(
                  label: 'Z Rotation',
                  value: _rotationZ,
                  onChanged: (value) => setState(() => _rotationZ = value),
                ),
                TextButton(
                  onPressed: () => setState(() {
                    _rotationX = 0.0;
                    _rotationY = 0.0;
                    _rotationZ = 0.0;
                    _scale = 1.0;
                    _translation = Offset.zero;
                  }),
                  child: const Text('Reset',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRotationSlider({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: TextStyle(color: Colors.white)),
        SizedBox(
          width: 150,
          child: Slider(
            value: value,
            min: -math.pi,
            max: math.pi,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class OverlayDebugDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent, // Make scaffold background transparent
      body: Stack(
        fit: StackFit.expand, // Make stack fill the available space
        children: [
          // Grid background
          CustomPaint(
            painter: GridPatternPainter(isDarkMode: true),
            size: Size.infinite,
          ),
          // Centered demo widget
          DebugTransformOverlay(
            enabled: true, // Toggle debug overlay
            child: VinylHomeWidget(),

            // LayeredAnimationDemo(), // Your actual widget here
          ),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return const MaterialApp(
  //     home: Scaffold(
  //       body: ,
  //     ),
  //   );
  // }
}
