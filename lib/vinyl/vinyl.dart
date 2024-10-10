import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fx_2_folder/vinyl/camera_simulation.dart';
import 'package:fx_2_folder/vinyl/card_stack_4_angles.dart';
import 'package:fx_2_folder/vinyl/easing/super_duper_ease_in.dart';
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
  late Animation<double> _flipAnimation;
  late Animation<double> _pushBackAnimation;
  late Animation<double>
      _combinedVerticalAnimation; // First item falls down + rotate + move back up
  late Animation<double> _topJumpAnimation;
  late Animation<double> _topMoveForwardAnimation;

  final List<VinylItem> _vinylItems = vinylItems;

  // double _manualValue = 0;
  @override
  void initState() {
    super.initState();
    animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..addListener(_animationHooks);

    // Combine vertical animations on the first Vinyl!
    _combinedVerticalAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 120.0).chain(
            CurveTween(curve: Interval(0.0, 0.33, curve: Curves.linear))),
        weight: 33.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 120.0, end: 120.0).chain(
            CurveTween(curve: Interval(0.33, 0.5, curve: Curves.linear))),
        weight: 17.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 120.0, end: 0.0)
            .chain(CurveTween(curve: Interval(0.5, 1.0, curve: Curves.linear))),
        weight: 50.0,
      ),
    ]).animate(animController);

    //1. Top to down from 0 to 90*
    //2. from 90* to 270*
    //3. from 270* to 0
    _flipAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: pi / 2)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 25.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: pi / 2, end: 3 * pi / 2)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 50.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 3 * pi / 2, end: 2 * pi)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 25.0,
      ),
    ]).animate(animController);

    _pushBackAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animController,
        curve: Interval(0.13, 0.85, curve: Curves.linear),
      ),
    );

    _topJumpAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -120)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 40.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -120, end: -120)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 20.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -120, end: 0.0)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 40.0,
      ),
    ]).animate(animController);

    _topMoveForwardAnimation = Tween<double>(begin: 0.0, end: -50).animate(
      CurvedAnimation(
        parent: animController,
        curve: Interval(0.0, 0.33, curve: Curves.linear),
      ),
    );
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => _changeOrder(),
        child: Expanded(
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                left: 0,
                child: Center(
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.0003512553609721081)
                      ..rotateY(323 * pi / 180) // horixontal
                      ..rotateX(355 * pi / 180) // vertical
                      ..rotateZ(6 * pi / 180) //z : 32
                      ..scale(1.0),
                    alignment: Alignment.center,
                    child: _buildCardStack(),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: _buildSlider(
                  value: animController.value,
                  onChanged: (value) => setState(() {
                    animController.value = value;
                    print("animController Seekbar, value: $value");
                  }),
                  label:
                      'Animation: ${animController.value.toStringAsFixed(3)}°',
                  min: 0.0,
                  max: 1.0,
                ),
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          4.0), // Change this value for different radii
                    ),
                    foregroundColor: Colors.black, // Text color
                    backgroundColor: Colors.white, // Background color
                  ),
                  onPressed: () {
                    animController.forward();
                  },
                  child: const Text('Animate'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardStack() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _flipAnimation,
        _pushBackAnimation,
        _combinedVerticalAnimation,
        _topJumpAnimation,
        _topMoveForwardAnimation,
      ]),
      builder: (context, child) {
        return Stack(
          children: List.generate(_vinylItems.length, (index) {
            var verticalAnimationValue = 0.0;
            var zPositionValue = 0.0;
            var rotateX = 0.0;
            if (_vinylItems[index].id == 'vinyl_3') {
              verticalAnimationValue = _combinedVerticalAnimation.value;
              zPositionValue =
                  lerpDouble(-100.0, 0.0, _pushBackAnimation.value)!;
              rotateX = _flipAnimation.value;
              // lerpDouble(0.0, 2 * pi, _flipAnimation.value)!;
            } else if (_vinylItems[index].id == 'vinyl_2') {
              verticalAnimationValue = _topJumpAnimation.value;
              zPositionValue = -50.0 + _topMoveForwardAnimation.value;
              rotateX = 0.0;
            } else if (_vinylItems[index].id == 'vinyl_1') {
              verticalAnimationValue = _topJumpAnimation.value;
              zPositionValue = (-0 * 50.0) + _topMoveForwardAnimation.value;
              rotateX = 0.0;
            }

            return Transform(
              transform: Matrix4.identity()
                ..translate(0.0, verticalAnimationValue, zPositionValue)
                ..rotateX(rotateX),
              alignment: Alignment.center, // -index * 50.0
              child: Container(
                width: 200,
                height: 200,
                color: _vinylItems[index].color,
                child: Center(
                  child: Text(
                    'Layer ${index + 1} + id ${_vinylItems[index].id}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
          }),
        );

        // Stack(
        //   children: [
        //     Transform(
        //       transform: Matrix4.identity()
        //         ..translate(0.0, 0.0, 0.0), // -index * 50.0
        //       child: Container(
        //         width: 200,
        //         height: 200,
        //         color: Colors.green,
        //         child: Center(
        //           child: Text(
        //             'Layer 1',
        //             style: TextStyle(color: Colors.white),
        //           ),
        //         ),
        //       ),
        //     ),
        //     Transform(
        //       transform: Matrix4.identity()
        //         ..translate(0.0, 0.0, -50.0), // -index * 50.0
        //       child: Container(
        //         width: 200,
        //         height: 200,
        //         color: Colors.yellow,
        //         child: Center(
        //           child: Text(
        //             'Layer 2',
        //             style: TextStyle(color: Colors.white),
        //           ),
        //         ),
        //       ),
        //     ),
        //     Transform(
        //       transform: Matrix4.identity()
        //         ..translate(
        //             0.0,
        //             _combinedVerticalAnimation.value,
        //             // combinedLerp(
        //             //     0.0, 200.0, _freeFallAnimation, _goBackUPAnimation),
        //             // lerpDouble(0.0, 200.0, _freeFallAnimation.value)!,
        //             lerpDouble(-100.0, 0.0, _pushBackAnimation.value)!)
        //         ..rotateX(lerpDouble(
        //             0.0, 2 * pi, _flipAnimation.value)!), // -index * 50.0
        //       alignment: Alignment.center,
        //       child: Container(
        //         width: 200,
        //         height: 200,
        //         color: Colors.purple,
        //         child: Center(
        //           child: Text(
        //             'Layer 3',
        //             style: TextStyle(color: Colors.white),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // );
      },
    );
  }

  _choreo() {
    //------------------
    //First vinyl translates down by Y + 200
    //First vinyl rotates
    //------------------
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

  bool _isStackReordered = false;
  _animationHooks() {
    if (animController.value >= 0.5 && !_isStackReordered) {
      _changeOrder();
      _isStackReordered = true;
    } else if (animController.value < 0.5) {
      _isStackReordered = false;
    }
  }

  void _changeOrder() {
    print("_changeOrder");
    setState(() {
      VinylItem item = vinylItems.removeAt(2);
      vinylItems.insert(0, item);
    });
  }
}

class VinylItem {
  final String id;
  final Color color;

  VinylItem({required this.id, required this.color});
}

final List<VinylItem> vinylItems = [
  VinylItem(id: 'vinyl_1', color: Colors.green),
  VinylItem(id: 'vinyl_2', color: Colors.yellow),
  VinylItem(id: 'vinyl_3', color: Colors.purple),
];
