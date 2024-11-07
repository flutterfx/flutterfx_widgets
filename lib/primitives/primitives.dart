import 'dart:math' as math;
import 'package:flutter/material.dart';

class MotionDemo extends StatefulWidget {
  const MotionDemo({super.key});

  @override
  State<MotionDemo> createState() => _MotionDemoState();
}

class _MotionDemoState extends State<MotionDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  double _currentRotation = 0.0;
  double _lastSliderValue = 0.0;
  double _lastUpdateTime = 0.0;
  bool _isSliding = false;
  double _velocity = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.decelerate,
    ))
      ..addListener(() {
        setState(() {
          _currentRotation = _rotationAnimation.value;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSliderChangeStart(double value) {
    _isSliding = true;
    _controller.stop();
    _lastUpdateTime = DateTime.now().millisecondsSinceEpoch / 1000.0;
    _lastSliderValue = value;
  }

  void _onSliderChanged(double value) {
    final now = DateTime.now().millisecondsSinceEpoch / 1000.0;
    final dt = now - _lastUpdateTime;

    if (dt > 0 && _isSliding) {
      _velocity = (value - _lastSliderValue) / dt;
      _currentRotation = value;
    }

    _lastUpdateTime = now;
    _lastSliderValue = value;
    setState(() {});
  }

  void _onSliderChangeEnd(double value) {
    _isSliding = false;

    // Only animate if there's significant velocity
    if (_velocity.abs() > 50) {
      // Threshold for "fast" movement
      final velocityDirection = _velocity.sign;
      final momentumDistance =
          _velocity.abs() * 0.5; // Scale factor for momentum

      _rotationAnimation = Tween<double>(
        begin: _currentRotation,
        end: _currentRotation + (momentumDistance * velocityDirection),
      ).animate(CurvedAnimation(
        parent: _controller,
        // Use a physics-based curve for momentum
        curve: Curves.easeOutCubic,
      ));

      _controller
        ..duration = Duration(milliseconds: (momentumDistance * 2).round())
        ..forward(from: 0.0);
    }

    // Reset velocity
    _velocity = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Transform.rotate(
                  angle: _currentRotation * math.pi / 180,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 80, child: Text('rotate')),
                      Expanded(
                        child: Slider(
                          value: _currentRotation,
                          min: -180,
                          max: 180,
                          onChangeStart: _onSliderChangeStart,
                          onChanged: _onSliderChanged,
                          onChangeEnd: _onSliderChangeEnd,
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        child: Text(
                          _currentRotation.toStringAsFixed(1),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
