import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:fx_2_folder/stacked-cards/stacked_card.dart';

class BouncingSquare extends StatefulWidget {
  const BouncingSquare({super.key});

  @override
  State<BouncingSquare> createState() => _BouncingSquareState();
}

class _BouncingSquareState extends State<BouncingSquare>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _radiusController;
  late Animation<double> _jumpAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _cornerRadiusAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowSizeAnimation;
  late Animation<double> _shadowOpacityAnimation;

  int _bottomCorner = 0;
  double _currentRotation = math.pi / 4;

  void _updateRotationAnimation() {
    _rotationAnimation = Tween<double>(
      begin: _currentRotation,
      end: _currentRotation + math.pi / 2,
    ).animate(_mainController);
  }

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _radiusController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _mainController.forward();
    _radiusController.repeat();

    _mainController.addListener(() {
      if (_jumpAnimation.value == 0 || _jumpAnimation.value > -50) {
        _radiusController.forward();
      } else {
        _radiusController.reverse();
      }

      if (_mainController.status == AnimationStatus.completed) {
        setState(() {
          _bottomCorner = (_bottomCorner - 1 < 0) ? 3 : _bottomCorner - 1;
          _currentRotation += math.pi / 2;
          _updateRotationAnimation();
          _mainController.forward(from: 0);
        });
      }
    });

    _jumpAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: -100)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -100, end: 0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_mainController);

    // New scale animation
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_mainController);

    // Shadow size animation - make it more dynamic
    _shadowSizeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 200, end: 40)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 40, end: 200)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_mainController);

    // Shadow opacity animation - make it more subtle
    _shadowOpacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.1, end: 0.05)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.05, end: 0.1)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_mainController);

    _rotationAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: _currentRotation,
          end: _currentRotation + math.pi / 2,
        ),
        weight: 100,
      ),
    ]).animate(_mainController);

    _cornerRadiusAnimation = Tween<double>(
      begin: 0,
      end: 80,
    ).animate(
      CurvedAnimation(
        parent: _radiusController,
        curve: Curves.easeInOut,
      ),
    );

    _updateRotationAnimation();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  BorderRadius getCornerRadius() {
    final radiusValue = _cornerRadiusAnimation.value;

    switch (_bottomCorner) {
      case 0:
        return BorderRadius.only(bottomRight: Radius.circular(radiusValue));
      case 1:
        return BorderRadius.only(bottomLeft: Radius.circular(radiusValue));
      case 2:
        return BorderRadius.only(topLeft: Radius.circular(radiusValue));
      case 3:
        return BorderRadius.only(topRight: Radius.circular(radiusValue));
      default:
        return BorderRadius.zero;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: AnimatedBuilder(
        animation: Listenable.merge([_mainController, _radiusController]),
        builder: (context, child) {
          return Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  painter: GridPatternPainter(isDarkMode: false),
                  size: Size.infinite,
                ),
                // Animated shadow
                Transform.translate(
                  offset: Offset(0, 80),
                  child: Transform.scale(
                    scaleX: 0.7,
                    scaleY: 0.2,
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                          width: _shadowSizeAnimation.value,
                          height: _shadowSizeAnimation.value,
                          decoration: BoxDecoration(
                            color: Colors.black
                                .withOpacity(_shadowOpacityAnimation.value),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Bouncing square
                Transform.translate(
                  offset: Offset(0, _jumpAnimation.value),
                  child: Transform.rotate(
                    angle: _rotationAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: getCornerRadius(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: BouncingSquare()));
}
