import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fx_2_folder/vinyl/camera_simulation.dart';
import 'package:fx_2_folder/vinyl/card_stack_4_angles.dart';
import 'package:fx_2_folder/vinyl/easing/super_duper_ease_in.dart';
import 'package:fx_2_folder/vinyl/example_stack_animation.dart';
import 'package:fx_2_folder/vinyl/transform_examples.dart';
import 'package:fx_2_folder/vinyl/widget_viewer.dart';

class VinylHomeWidget extends StatelessWidget {
  const VinylHomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: WidgetViewer()
      // Stacked3DCardsLayout() //Stacked3DCardsLayout()
      // body: CameraSimulation(),

      // body: TransformDemo(),

      body: TransformApp(),
    );
  }
}

class TransformApp extends StatefulWidget {
  @override
  _TransformAppState createState() => _TransformAppState();
}

class _TransformAppState extends State<TransformApp>
    with SingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation<double> _freeFallAnimation;
  late Animation<double> _flipAnimation;
  late Animation<double> _pushBackAnimation;
  late Animation<double> _goBackUPAnimation;
  late Animation<double> _combinedVerticalAnimation;

  double _manualValue = 0;
  @override
  void initState() {
    super.initState();
    animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 6000));
    // animController.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     animController.reverse();
    //   } else if (status == AnimationStatus.dismissed) {
    //     animController.forward();
    //   }
    // });
    animController.forward();

    // _freeFallAnimation = Tween<double>(begin: 0, end: 1).animate(
    //   CurvedAnimation(
    //     parent: animController,
    //     curve: Interval(0.0, 0.33, curve: Curves.linear),
    //   ),
    // );

    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animController,
        curve: Interval(0.0, 0.66, curve: Curves.easeInOut
            // const SuperDuperEaseInAndThenQuickOut(exponent: 3)
            ),
      ),
    );

    _pushBackAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animController,
        curve: Interval(0.33, 0.66, curve: Curves.linear),
      ),
    );

    // _goBackUPAnimation = Tween<double>(begin: 0, end: 1).animate(
    //   CurvedAnimation(
    //     parent: animController,
    //     curve: Interval(0.66, 1.0, curve: Curves.linear),
    //   ),
    // );

    // Combine vertical animations
    _combinedVerticalAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 200.0).chain(
            CurveTween(curve: Interval(0.0, 0.33, curve: Curves.linear))),
        weight: 33.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 200.0, end: 200.0).chain(
            CurveTween(curve: Interval(0.33, 0.66, curve: Curves.linear))),
        weight: 33.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 200.0, end: 0.0).chain(
            CurveTween(curve: Interval(0.66, 1.0, curve: Curves.linear))),
        weight: 34.0,
      ),
    ]).animate(animController);
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0003512553609721081)
                ..rotateY(323 * pi / 180) // horixontal
                ..rotateX(355 * pi / 180) // vertical
                ..rotateZ(6 * pi / 180) //z : 32
                ..scale(1.0),
              alignment: Alignment.center,
              child: _buildCardStack(),
            ),
            Positioned(
                bottom: 0,
                child: _buildSlider(
                  value: _manualValue,
                  onChanged: (value) => setState(() {
                    _manualValue = value;
                    print("_manualValue, value: $_manualValue");
                  }),
                  label: '_manualValue: ${_manualValue.toStringAsFixed(0)}°',
                  // min: -200.0,
                  // max: 200.0,
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildCardStack() {
    return AnimatedBuilder(
        animation: Listenable.merge([
          // _freeFallAnimation,
          _flipAnimation,
          _pushBackAnimation,
          // _goBackUPAnimation,
          _combinedVerticalAnimation,
        ]),
        builder: (context, child) {
          return Stack(
            children: [
              Transform(
                transform: Matrix4.identity()
                  ..translate(0.0, 0.0, 0.0), // -index * 50.0
                child: Container(
                  width: 200,
                  height: 200,
                  color: Colors.green,
                  child: Center(
                    child: Text(
                      'Layer 1',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Transform(
                transform: Matrix4.identity()
                  ..translate(0.0, 0.0, -50.0), // -index * 50.0
                child: Container(
                  width: 200,
                  height: 200,
                  color: Colors.yellow,
                  child: Center(
                    child: Text(
                      'Layer 2',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Transform(
                transform: Matrix4.identity()
                  ..translate(
                      0.0,
                      _combinedVerticalAnimation.value,
                      // combinedLerp(
                      //     0.0, 200.0, _freeFallAnimation, _goBackUPAnimation),
                      // lerpDouble(0.0, 200.0, _freeFallAnimation.value)!,
                      lerpDouble(-100.0, 0.0, _pushBackAnimation.value)!)
                  ..rotateX(lerpDouble(
                      0.0, 2 * pi, _flipAnimation.value)!), // -index * 50.0
                alignment: Alignment.center,
                child: Container(
                  width: 200,
                  height: 200,
                  color: Colors.purple,
                  child: Center(
                    child: Text(
                      'Layer 3',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  _choreo() {
    //------------------
    //First vinyl translates down by Y + 200
    //First vinyl rotates
    //------------------
  }

  double combinedLerp(
    double start,
    double end,
    Animation<double> anim1,
    Animation<double> anim2,
  ) {
    double value = 0.0;
    if (!anim1.isCompleted) {
      value = lerpDouble(start, end, anim1.value)!;
    } else {
      value = lerpDouble(start, end, anim2.value)!;
    }
    return value; // Here we're taking the maximum of the two values
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
}
