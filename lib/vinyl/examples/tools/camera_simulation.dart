import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'package:flutter/services.dart';

//make this into web tools for working quickly with flutter animation with transform
class CameraSimulation extends StatefulWidget {
  @override
  _CameraSimulationState createState() => _CameraSimulationState();
}

class _CameraSimulationState extends State<CameraSimulation> {
  double _rotateX = 0;
  double _rotateY = 0;
  double _rotateZ = 0;
  double _translateX = 0;
  double _translateY = 0;
  double _translateZ = 0;
  double _perspectiveX = 0.00;
  double _perspectiveY = 0.00;
  double _perspectiveZ = 0.00;
  double _zoom = 1.0;

// working bottom left
// Transform(
//                 transform: Matrix4.identity()
//                   // ..setEntry(3, 2, _perspectiveZ) // Z perspective
//                   // ..setEntry(3, 1, _perspectiveY) // Y perspective
//                   // ..setEntry(3, 0, _perspectiveX) // X perspective
//                   // ..translate(50.0, -50.0, 0.0)
//                   ..rotateX(-0.3)
//                   ..rotateY(-0.3)
//                   ..rotateZ(0.02094395102393154),
//                 // ..scale(_zoom),
//                 // ..setEntry(3, 2, _perspective) // perspective
//                 // ..rotateX(_rotateX)
//                 // ..rotateY(_rotateY)
//                 // ..rotateZ(_rotateZ)
//                 // ..translate(_translateX, _translateY, _translateZ)
//                 // ..scale(_zoom), // Add zoom effect
//                 alignment: FractionalOffset.center,
//                 child: _build3DScene(),
//               )
  @override
  Widget build(BuildContext context) {
// setEntry(0, 3, x): Translates along the X-axis
// setEntry(1, 3, y): Translates along the Y-axis
// setEntry(2, 3, z): Translates along the Z-axis
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 400,
              width: double.infinity,
              child: Image.asset(
                "assets/images/tracing_cards.png",
                fit: BoxFit.fitHeight,
              ),
            ),
            //           transform = Matrix4.identity()
            // ..translate(50.0, -50.0, 0.0)
            // ..rotateX(-0.3)
            // ..rotateY(-0.3);
            Container(
              height: 400,
              child: Transform(
                transform: Matrix4.identity()
                  ..rotateX(0.3)
                  ..rotateY(0.3)
                  ..rotateZ(-0.02094395102393154)
                  ..translate(_translateX, _translateY, _translateZ),
                // ..setEntry(3, 2, _perspectiveZ) // Z perspective
                // ..setEntry(3, 1, _perspectiveY) // Y perspective
                // ..setEntry(3, 0, _perspectiveX) // X perspective
                // ..translate(_translateX, _translateY, _translateZ)
                // ..rotateX(_rotateX)
                // ..rotateY(_rotateY)
                // ..rotateZ(_rotateZ)
                // ..scale(_zoom),
                alignment: FractionalOffset.center,
                child: _build3DScene(),
              ),
            )
          ],
        ),
        _buildControls(),
        _buildExportButton(),
      ],
    );
  }

  Widget _build3DScene() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Back plane (blue)

        Transform(
          transform: Matrix4.translationValues(0, 0, 0),
          child: Container(color: Colors.blue, width: 200, height: 288),
        ),

        Transform(
          transform: Matrix4.translationValues(0, 0, 100.0),
          child: Container(color: Colors.red, width: 200, height: 288),
        ),

        Transform(
          transform: Matrix4.translationValues(0, 0, 200.0),
          child: Container(color: Colors.yellow, width: 200, height: 288),
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Column(
      children: [
        Slider(
          value: _rotateX,
          min: -math.pi,
          max: math.pi,
          divisions: 300,
          onChanged: (value) => setState(() => _rotateX = value),
          label: 'Rotate X: ${_rotateX.toStringAsFixed(2)}',
        ),
        Slider(
          value: _rotateY,
          min: -math.pi,
          max: math.pi,
          divisions: 300,
          onChanged: (value) => setState(() => _rotateY = value),
          label: 'Rotate Y: ${_rotateY.toStringAsFixed(2)}',
        ),
        Slider(
          value: _rotateZ,
          min: -math.pi,
          max: math.pi,
          divisions: 300,
          onChanged: (value) => setState(() => _rotateZ = value),
          label: 'Rotate Z:${_rotateZ.toStringAsFixed(2)}',
        ),
        Slider(
          value: _translateX,
          min: -200,
          max: 200,
          divisions: 400,
          onChanged: (value) => setState(() => _translateX = value),
          label: 'Translate X: ${_translateX.toStringAsFixed(2)}',
        ),
        Slider(
          value: _translateY,
          min: -200,
          max: 200,
          divisions: 400,
          onChanged: (value) => setState(() => _translateY = value),
          label: 'Translate Y: ${_translateY.toStringAsFixed(2)}',
        ),
        Slider(
          value: _translateZ,
          min: -200,
          max: 200,
          divisions: 400,
          onChanged: (value) => setState(() => _translateZ = value),
          label: 'Translate Z: ${_translateZ.toStringAsFixed(2)}',
        ),
        Text("PerspectiveX"),
        Slider(
          value: _perspectiveX,
          min: -0.01, //0.0001,
          max: 0.01,
          divisions: 300,
          onChanged: (value) => setState(() => _perspectiveX = value),
          label: 'PerspectiveX: ${_perspectiveX.toStringAsFixed(4)}',
        ),
        Text("PerspectiveY"),
        Slider(
          value: _perspectiveY,
          min: -0.01, //0.0001,
          max: 0.01,
          divisions: 300,
          onChanged: (value) => setState(() => _perspectiveY = value),
          label: 'PerspectiveY: ${_perspectiveY.toStringAsFixed(4)}',
        ),
        Text("PerspectiveZ"),
        Slider(
          value: _perspectiveZ,
          min: -0.01, //0.0001,
          max: 0.01,
          divisions: 300,
          onChanged: (value) => setState(() => _perspectiveZ = value),
          label: 'PerspectiveZ: ${_perspectiveZ.toStringAsFixed(4)}',
        ),
        Slider(
          value: _zoom,
          min: 0.5,
          max: 2.0,
          divisions: 150,
          onChanged: (value) => setState(() => _zoom = value),
          label: 'Zoom: ${_zoom.toStringAsFixed(2)}',
        ),
      ],
    );
  }

  Widget _buildExportButton() {
    return ElevatedButton(
      child: Text('Export Settings to Clipboard'),
      onPressed: _exportSettings,
    );
  }

  void _exportSettings() {
    final settings = {
      'rotateX': _rotateX,
      'rotateY': _rotateY,
      'rotateZ': _rotateZ,
      'translateX': _translateX,
      'translateY': _translateY,
      'translateZ': _translateZ,
      'perspectiveX': _perspectiveX,
      'perspectiveY': _perspectiveY,
      'perspectiveZ': _perspectiveZ,
      'zoom': _zoom,
    };

    final jsonString = JsonEncoder.withIndent('  ').convert(settings);
    Clipboard.setData(ClipboardData(text: jsonString));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Settings and code copied to clipboard')),
    );
  }
}
