import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:fx_2_folder/vinyl/camera_simulation.dart';
import 'package:fx_2_folder/vinyl/card_stack_4_angles.dart';
import 'package:fx_2_folder/vinyl/transform_examples.dart';
import 'package:fx_2_folder/vinyl/widget_viewer.dart';

class VinylHomeWidget extends StatelessWidget {
  const VinylHomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: WidgetViewer()
        // Stacked3DCardsLayout() //Stacked3DCardsLayout()
        // body: CameraSimulation(),

        // body: TransformDemo(),

        //body: TransformApp(),
        );
  }
}

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage>
//     with SingleTickerProviderStateMixin {
//   double x = 0;
//   double y = 0;
//   late AnimationController _controller;
//   late Animation<double> _perspectiveAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 6),
//       vsync: this,
//     )..repeat(reverse: true);

//     _perspectiveAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeInOut,
//     ));
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: AnimatedBuilder(
//           animation: _perspectiveAnimation,
//           builder: (context, child) {
//             return Transform(
//               transform: Matrix4.identity()
//                 ..setEntry(3, 2, _perspectiveAnimation.value)
//                 ..rotateX(x)
//                 ..rotateY(y),
//               alignment: FractionalOffset.center,
//               child: GestureDetector(
//                 onPanUpdate: (details) {
//                   setState(() {
//                     y -= details.delta.dx / 100;
//                     x += details.delta.dy / 100;
//                   });
//                 },
//                 child: Container(
//                   color: Colors.red,
//                   height: 200.0,
//                   width: 200.0,
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

class TransformApp extends StatefulWidget {
  @override
  _TransformAppState createState() => _TransformAppState();
}

class _TransformAppState extends State<TransformApp>
    with SingleTickerProviderStateMixin {
  double _rotateX = 0.0;
  double _rotateY = 0.0;
  double _rotateZ = 0.0;
  double _translateX = 0.0;
  double _translateY = 0.0;
  double _translateZ = 0.0;
  double _perspectiveValue = 0.002;
  TextEditingController _perspectiveController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _perspectiveController.text = _perspectiveValue.toString();
  }

  void _updatePerspective(String value) {
    double? newValue = double.tryParse(value);
    if (newValue != null) {
      setState(() {
        _perspectiveValue = newValue;
        print("_updatePerspective: $_perspectiveValue");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    rebuildAllChildren(context);
    return Scaffold(
      appBar: AppBar(title: Text('3D Transform Playground')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, _perspectiveValue)
                  ..rotateX(_rotateX)
                  ..rotateY(_rotateY)
                  ..rotateZ(_rotateZ)
                  ..translate(_translateX, _translateY, _translateZ),
                alignment: FractionalOffset.center,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      'Perspective: ${_perspectiveValue.toStringAsFixed(6)}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Container(
                //   width: 200,
                //   height: 200,
                //   decoration: const BoxDecoration(
                //     image: DecorationImage(
                //       image: NetworkImage('https://picsum.photos/200'),
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                // ),
              ),
            ),
          ),
          _buildControlPanel(),
        ],
      ),
    );
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  Widget _buildControlPanel() {
    return Container(
      height: 300,
      child: ListView(
        children: [
          _buildSlider('Rotate X', _rotateX, -pi, pi,
              (v) => setState(() => _rotateX = v)),
          _buildSlider('Rotate Y', _rotateY, -pi, pi,
              (v) => setState(() => _rotateY = v)),
          _buildSlider('Rotate Z', _rotateZ, -pi, pi,
              (v) => setState(() => _rotateZ = v)),
          _buildSlider('Translate X', _translateX, -100, 100,
              (v) => setState(() => _translateX = v)),
          _buildSlider('Translate Y', _translateY, -100, 100,
              (v) => setState(() => _translateY = v)),
          _buildSlider('Translate Z', _translateZ, -100, 100,
              (v) => setState(() => _translateZ = v)),
          _buildTextField(
              'Perspective', _perspectiveController, _updatePerspective),
        ],
      ),
    );
  }

  Widget _buildSlider(String label, double value, double min, double max,
      ValueChanged<double> onChanged) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label),
          ),
          Expanded(
            child: Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
          SizedBox(
            width: 50,
            child: Text(value.toStringAsFixed(2)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      ValueChanged<String> onChanged) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label)),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType:
                  TextInputType.numberWithOptions(decimal: true, signed: false),
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    onChanged(controller.text);
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
              onChanged: onChanged,
              onSubmitted: (value) {
                onChanged(value);
                FocusScope.of(context).unfocus();
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
