import 'package:flutter/material.dart';
import 'dart:math' show pi;
import 'dart:math' as math;
import 'dart:async';

abstract class LightAnimationStrategy {
  void initAnimation(List<AnimationController> controllers);
  void disposeAnimation();
  void startAnimation();
  void stopAnimation();
}

class SynchronizedBlinkStrategy implements LightAnimationStrategy {
  final List<AnimationController> _controllers = [];
  final Duration duration;

  SynchronizedBlinkStrategy({
    this.duration = const Duration(milliseconds: 1200),
  });

  @override
  void initAnimation(List<AnimationController> controllers) {
    _controllers.addAll(controllers);
    for (var controller in _controllers) {
      controller.duration = duration;
      controller.value = 0;
    }
  }

  @override
  void startAnimation() {
    bool isOn = false;
    Timer.periodic(duration, (_) {
      isOn = !isOn;
      for (var controller in _controllers) {
        controller.value = isOn ? 1 : 0;
      }
    });
  }

  @override
  void stopAnimation() {
    for (var controller in _controllers) {
      controller.value = 0;
    }
  }

  @override
  void disposeAnimation() {
    stopAnimation();
    _controllers.clear();
  }
}

class SequentialBlinkStrategy implements LightAnimationStrategy {
  final List<AnimationController> _controllers = [];
  final Duration duration;
  Timer? _sequenceTimer;
  int _currentIndex = 0;

  SequentialBlinkStrategy({
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  void initAnimation(List<AnimationController> controllers) {
    _controllers.addAll(controllers);
    for (var controller in _controllers) {
      controller.duration = duration;
      controller.value = 0;
    }
  }

  @override
  void startAnimation() {
    stopAnimation();
    _currentIndex = 0;

    void animateNext() {
      if (_controllers.isEmpty) return;

      // Turn off previous light
      if (_currentIndex > 0) {
        _controllers[(_currentIndex - 1) % _controllers.length].value = 0;
      } else {
        _controllers.last.value = 0;
      }

      // Turn on current light
      _controllers[_currentIndex].value = 1;

      _currentIndex = (_currentIndex + 1) % _controllers.length;
    }

    _sequenceTimer = Timer.periodic(duration, (_) => animateNext());
    animateNext();
  }

  @override
  void stopAnimation() {
    _sequenceTimer?.cancel();
    for (var controller in _controllers) {
      controller.value = 0;
    }
  }

  @override
  void disposeAnimation() {
    stopAnimation();
    _controllers.clear();
  }
}

class WaveBlinkStrategy implements LightAnimationStrategy {
  final List<AnimationController> _controllers = [];
  final Duration duration;
  Timer? _waveTimer;

  WaveBlinkStrategy({
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  void initAnimation(List<AnimationController> controllers) {
    _controllers.addAll(controllers);
    for (var controller in _controllers) {
      controller.duration = duration;
      controller.value = 0;
    }
  }

  @override
  void startAnimation() {
    if (_controllers.isEmpty) return;

    final segmentDuration = duration ~/ _controllers.length;
    int currentIndex = 0;

    _waveTimer = Timer.periodic(segmentDuration, (_) {
      // Turn off all lights that are more than 2 positions behind
      for (var i = 0; i < _controllers.length; i++) {
        if ((i + 2) < currentIndex) {
          _controllers[i].value = 0;
        }
      }

      // Turn on current light
      if (currentIndex < _controllers.length) {
        _controllers[currentIndex].value = 1;
      }

      currentIndex = (currentIndex + 1) % (_controllers.length + 3);
    });
  }

  @override
  void stopAnimation() {
    _waveTimer?.cancel();
    for (var controller in _controllers) {
      controller.value = 0;
    }
  }

  @override
  void disposeAnimation() {
    stopAnimation();
    _controllers.clear();
  }
}

class DecorativeLightsDecorator extends StatefulWidget {
  final Widget child;
  final int numberOfLights;
  final double bulbHeight;
  final double bulbWidth;
  final List<Color> colors;
  final bool enableAnimation;
  final LightAnimationStrategy animationStrategy;

  const DecorativeLightsDecorator({
    Key? key,
    required this.child,
    this.numberOfLights = 10,
    this.bulbHeight = 15.0,
    this.bulbWidth = 8.0,
    this.colors = const [Colors.red, Colors.green],
    this.enableAnimation = true,
    required this.animationStrategy,
  }) : super(key: key);

  @override
  State<DecorativeLightsDecorator> createState() =>
      _DecorativeLightsDecoratorState();
}

class _DecorativeLightsDecoratorState extends State<DecorativeLightsDecorator>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _controllers = List.generate(
      widget.numberOfLights,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1200),
      ),
    );

    widget.animationStrategy.initAnimation(_controllers);

    if (widget.enableAnimation) {
      widget.animationStrategy.startAnimation();
    }
  }

  @override
  void didUpdateWidget(DecorativeLightsDecorator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animationStrategy != widget.animationStrategy ||
        oldWidget.numberOfLights != widget.numberOfLights) {
      _disposeControllers();
      _initializeControllers();
    }
  }

  void _disposeControllers() {
    widget.animationStrategy.disposeAnimation();
    for (var controller in _controllers) {
      controller.dispose();
    }
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        widget.child,
        Positioned(
          left: 16,
          right: 16,
          top: 0,
          child: SizedBox(
            height: widget.bulbHeight * 1.3,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final availableWidth = constraints.maxWidth;
                final calculatedSpacing =
                    availableWidth / (widget.numberOfLights - 1);

                return Stack(
                  clipBehavior: Clip.none,
                  children: List.generate(
                    widget.numberOfLights,
                    (index) => Positioned(
                      left: index * calculatedSpacing,
                      child: LightBulb(
                        key: ValueKey('light_$index'),
                        color: widget.colors[index % widget.colors.length],
                        height: widget.bulbHeight,
                        width: widget.bulbWidth,
                        controller: _controllers[index],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class LightBulb extends StatelessWidget {
  final Color color;
  final double height;
  final double width;
  final AnimationController controller;
  // Add a random tilt angle between -15 and +15 degrees
  final double tiltAngle;

  LightBulb({
    Key? key,
    required this.color,
    required this.height,
    required this.width,
    required this.controller,
  })  : tiltAngle = math.Random().nextDouble() * 30 -
            15, // Random angle between -15 and +15 degrees
        super(key: key);

  Color get offStateColor {
    final hslColor = HSLColor.fromColor(color);
    return hslColor
        .withLightness((hslColor.lightness * 0.3).clamp(0.0, 1.0))
        .toColor();
  }

  Color get onStateColor {
    final hslColor = HSLColor.fromColor(color);
    return hslColor
        .withLightness((hslColor.lightness * 1.2).clamp(0.0, 1.0))
        .withSaturation((hslColor.saturation * 1.1).clamp(0.0, 1.0))
        .toColor();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final isOn = controller.value > 0.5;

        return Transform.rotate(
          angle: tiltAngle * (pi / 180), // Convert degrees to radians
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSocket(),
              _buildBulb(isOn),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSocket() {
    return Container(
      width: width * 0.6,
      height: height * 0.15,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(2),
          bottomRight: Radius.circular(2),
        ),
      ),
    );
  }

  Widget _buildBulb(bool isOn) {
    final currentColor = isOn ? onStateColor : offStateColor;

    return Container(
      width: width,
      height: height * 0.85,
      decoration: BoxDecoration(
        color: currentColor,
        borderRadius: BorderRadius.circular(width / 2),
        boxShadow: isOn
            ? [
                BoxShadow(
                  color: currentColor.withOpacity(0.4),
                  blurRadius: width * 1.5,
                  spreadRadius: width * 0.4,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.7),
                  blurRadius: width * 0.5,
                  spreadRadius: width * 0.1,
                ),
              ]
            : [],
      ),
    );
  }
}

class ExampleUsage extends StatelessWidget {
  const ExampleUsage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DecorativeLightsDecorator(
              numberOfLights: 8,
              colors: const [
                Colors.red,
                Colors.green,
                Colors.blue,
                Colors.yellow,
              ],
              animationStrategy: SynchronizedBlinkStrategy(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Synchronized Blink',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            DecorativeLightsDecorator(
              numberOfLights: 8,
              colors: const [
                Colors.red,
                Colors.green,
                Colors.blue,
                Colors.yellow,
              ],
              animationStrategy: SequentialBlinkStrategy(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Sequential Blink',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            DecorativeLightsDecorator(
              numberOfLights: 8,
              colors: const [
                Colors.red,
                Colors.green,
                Colors.blue,
                Colors.yellow,
              ],
              animationStrategy: WaveBlinkStrategy(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Wave Effect',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
