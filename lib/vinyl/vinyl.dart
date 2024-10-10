import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fx_2_folder/vinyl/camera_simulation.dart';
import 'package:fx_2_folder/vinyl/card_stack_4_angles.dart';
import 'package:fx_2_folder/vinyl/easing/super_duper_ease_in.dart';
import 'package:fx_2_folder/vinyl/exmaples/glass_card.dart';
import 'package:fx_2_folder/vinyl/exmaples/spring_examples.dart';
import 'package:fx_2_folder/vinyl/exmaples/spring_playground.dart';
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

      // body: SpringAnimationsPage(),

      body: TransformApp(),
      // body: GlassCardPage(),

      // body: SpringAnimationsDemo(),
    );
  }
}

class TransformApp extends StatefulWidget {
  @override
  _TransformAppState createState() => _TransformAppState();
}

class _TransformAppState extends State<TransformApp>
    with TickerProviderStateMixin {
  late AnimationController animController;
  late Animation<double> _flipAnimation;
  late Animation<double> _pushBackAnimation;
  late Animation<double>
      _combinedVerticalAnimation; // First item falls down + rotate + move back up
  late Animation<double> _topJumpAnimation;
  late Animation<double> _topMoveForwardAnimation;

  late AnimationController animParentController;
  late Animation<double> _headBowForwardAnimation;

  late AnimationController vinylController;
  late Animation<double> _vinylJumpAnimation;

  final List<VinylItem> _vinylItems = List.from(vinylItems);

  String firstVinylId = vinylItems[0].id;

  @override
  void initState() {
    super.initState();

    initAnimations();
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  double _rotateX = 0;
  double _rotateY = 0;

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _rotateY += details.delta.dx / 100;
      _rotateX -= details.delta.dy / 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double baseRotationX = 355 * pi / 180;
    return Scaffold(
      body: GestureDetector(
        onPanUpdate: _onPanUpdate,
        onTap: () => _changeStackOrder(),
        child: Expanded(
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: Listenable.merge([_headBowForwardAnimation]),
                builder: (context, child) {
                  return Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(right: 100),
                      child: Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.0003512553609721081)
                          ..rotateY(323 * pi / 180) // horixontal
                          ..rotateX(baseRotationX +
                              sin(_headBowForwardAnimation.value * pi) *
                                  10 *
                                  pi /
                                  180 +
                              _rotateX) // vertical
                          ..rotateZ(6 * pi / 180) //z : 32
                          ..scale(1.0),
                        alignment: Alignment.center,
                        child: _buildCardStack(),
                      ),
                    ),
                  );
                },
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
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
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
        _vinylJumpAnimation,
      ]),
      builder: (context, child) {
        return Stack(
          children: List.generate(_vinylItems.length, (index) {
            var vinylItem = _vinylItems[index];
            // if (vinylItem.id == 'vinyl_3') {
            bool isSecond =
                false; // At this moment, the second card is the first one in the stack
            if (vinylItem.id == vinylOrder[0]) {
              vinylItem.verticalAnimationValue =
                  _combinedVerticalAnimation.value;
              vinylItem.zPositionValue =
                  lerpDouble(-100.0, 0.0, _pushBackAnimation.value)!;
              vinylItem.rotateX = _flipAnimation.value;
              // } else if (_vinylItems[index].id == 'vinyl_2') {
            } else if (_vinylItems[index].id == vinylOrder[1]) {
              isSecond = true;
              vinylItem.verticalAnimationValue = _topJumpAnimation.value;
              vinylItem.zPositionValue = -50.0 + _topMoveForwardAnimation.value;
              vinylItem.rotateX = 0.0;
              // } else if (_vinylItems[index].id == 'vinyl_1') {
            } else if (_vinylItems[index].id == vinylOrder[2]) {
              vinylItem.verticalAnimationValue = _topJumpAnimation.value;
              vinylItem.zPositionValue =
                  (-0 * 50.0) + _topMoveForwardAnimation.value;
              vinylItem.rotateX = 0.0;
            }

            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..translate(0.0, vinylItem.verticalAnimationValue,
                    vinylItem.zPositionValue)
                ..rotateX(vinylItem.rotateX),
              alignment: Alignment.center, // -index * 50.0
              child: Stack(
                children: [
                  // Container(
                  //   width: 200,
                  //   height: 200,
                  //   color: _vinylItems[index].color,
                  //   child: Text(
                  //     'Layer ${index + 1} + id ${_vinylItems[index].id}',
                  //     style: TextStyle(color: Colors.white),
                  //   ),
                  // ),
                  Container(
                    width: 200,
                    height: 200,
                    child: Image.asset(
                      vinylItem.asset,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(
                        0,
                        isSecond
                            ? _vinylJumpAnimation.value
                            : 0), // Move up and down
                    child: Container(
                      width: 200,
                      height: 200,
                      // color: _vinylItems[index].color,
                      child: Image.asset(
                        "assets/images/vinyl/vinyl.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),

                  if (isFrontImage(vinylItem.rotateX))
                    Container(
                      width: 200,
                      height: 200,
                      child: Image.asset(
                        vinylItem.asset,
                        fit: BoxFit.fill,
                      ),
                    ),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  bool isFrontImage(double angle) {
    const degrees90 = pi / 2;
    const degrees270 = 3 * pi / 2;
    return angle <= degrees90 || angle >= degrees270;
  }

  void resetAnimation() {
    animController.dispose();
    animParentController.dispose();
    // animController.reset();
    initAnimations();
    // animController.forward();
  }

  final SpringDescription spring = const SpringDescription(
    mass: 2,
    stiffness: 150,
    damping: 20,
  );

  initAnimations() {
    animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..addListener(_animationHooks);

    animParentController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));

    vinylController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    // Add a status listener
    animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animParentController.forward();
      }
    });

    animParentController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        print("animation completed | resetting now");
        resetAnimation();
        _changeAnimationListOrder();
        animController.forward();
      }
    });
    // Start the animation and reverse it
    // _controller.forward().then((_) => _controller.reverse());

    // Combine vertical animations on the first Vinyl!
    _combinedVerticalAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 150.0)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 30.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 150.0, end: 150.0)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 40.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 150.0, end: 0.0)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 30.0,
      ),
    ]).animate(animController);

    //1. Top to down from 0 to 90*
    //2. from 90* to 270*
    //3. from 270* to 0
    _flipAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: pi / 2)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 30.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: pi / 2, end: 3 * pi / 2)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 40.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 3 * pi / 2, end: 2 * pi)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 30.0,
      ),
    ]).animate(animController);

    _pushBackAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animController,
        curve: Interval(0.13, 0.85, curve: Curves.linear),
      ),
    );

    // final normalSpringOpen = SpringSimulation(spring, 0, 1, 1);
    // final normalSpringClose = SpringSimulation(spring, 1, 0, 1);
    _topJumpAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -100)
            .chain(CurveTween(curve: SnappySpringCurve())),
        weight: 40.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -100, end: -100)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 30.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -100, end: 0.0)
            .chain(CurveTween(curve: SnappySpringCurve())),
        weight: 40.0,
      ),
    ]).animate(animController);

    _topMoveForwardAnimation = Tween<double>(begin: 0.0, end: -50).animate(
      CurvedAnimation(
        parent: animController,
        curve: Interval(0.0, 0.3, curve: SnappySpringCurve()),
      ),
    );

    _headBowForwardAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: animParentController,
          curve: Interval(0.0, 0.75,
              curve: SnappySpringCurve()) //BouncyElasticCurve()
          ),
    );

    _vinylJumpAnimation = Tween<double>(begin: 0, end: -50).animate(
      CurvedAnimation(
        parent: vinylController,
        curve: Interval(0.0, 1.0, curve: SnappySpringCurve()),
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

  bool _isStackReordered = false;
  _animationHooks() {
    if (animController.value >= 0.5 && !_isStackReordered) {
      _changeStackOrder();
      _isStackReordered = true;
    } else if (animController.value < 0.5) {
      _isStackReordered = false;
    } else if (animController.value > 0.74) {
      vinylController.forward().then((_) => vinylController.reverse());
    }
  }

  // Update called in the middle of animation to make the card go behind another card!
  void _changeStackOrder() {
    print("_changeStackOrder");
    setState(() {
      VinylItem item = _vinylItems.removeAt(_vinylItems.length - 1);
      _vinylItems.insert(0, item);
    });
  }

  // Update called after the animation has finished
  void _changeAnimationListOrder() {
    print("_changeAnimationListOrder");
    setState(() {
      String firstElement = vinylOrder.removeAt(0);
      vinylOrder.add(firstElement);
    });
  }
}

class VinylItem {
  final String id;
  final Color color;
  final String asset;
  double verticalAnimationValue = 0.0;
  double zPositionValue = 0.0;
  double rotateX = 0.0;

  VinylItem(
      {required this.id,
      required this.color,
      required this.asset,
      this.verticalAnimationValue = 0.0,
      this.zPositionValue = 0.0,
      this.rotateX = 0.0});
}

// verticalAnimationValue = _combinedVerticalAnimation.value;
//               zPositionValue =
//                   lerpDouble(-100.0, 0.0, _pushBackAnimation.value)!;
//               rotateX = _flipAnimation.value;

final List<VinylItem> vinylItems = [
  VinylItem(
      id: 'vinyl_1',
      color: Colors.green,
      asset: "assets/images/vinyl/cover_1.png",
      verticalAnimationValue: 0.0,
      zPositionValue: 0.0,
      rotateX: 0.0),
  VinylItem(
      id: 'vinyl_2',
      color: Colors.yellow,
      asset: "assets/images/vinyl/cover_2.png",
      verticalAnimationValue: 0.0,
      zPositionValue: 0.0,
      rotateX: 0.0),
  VinylItem(
      id: 'vinyl_3',
      color: Colors.purple,
      asset: "assets/images/vinyl/cover_3.png",
      verticalAnimationValue: 0.0,
      zPositionValue: 0.0,
      rotateX: 0.0),
];

final vinylOrder = ['vinyl_3', 'vinyl_2', 'vinyl_1'];

double degreesToRadians(double degrees) {
  return degrees * (pi / 180);
}

class BouncyElasticCurve extends Curve {
  @override
  double transform(double t) {
    return -pow(e, -8 * t) * cos(t * 12) + 1;
  }
}

class SnappySpringCurve extends Curve {
  @override
  double transform(double t) {
    return t * t * (3 - 2 * t) + sin(t * pi * 3) * 0.1 * (1 - t);
  }
}
