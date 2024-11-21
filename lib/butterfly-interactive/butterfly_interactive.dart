import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fx_2_folder/butterfly-interactive/butterfly.dart';

class ButterflyConfig {
  final Duration delay;
  final Duration duration;
  final double startXPercent;
  final double scale;

  ButterflyConfig({
    required this.delay,
    required this.duration,
    required this.startXPercent,
    required this.scale,
  });
}

extension VectorNormalization on Offset {
  /// Returns a normalized version of the offset (vector with length 1)
  Offset normalize() {
    final length = sqrt(dx * dx + dy * dy);
    return Offset(dx / length, dy / length);
  }
}

// Enum to define butterfly movement modes
enum ButterflyMode { random, follow }

class ButterflyController extends ChangeNotifier {
  Offset _targetPosition = Offset.zero;
  ButterflyMode _mode = ButterflyMode.random;
  bool _isInteracting = false;

  // Add momentum tracking
  Offset _velocity = Offset.zero;

  Offset get targetPosition => _targetPosition;
  ButterflyMode get mode => _mode;
  bool get isInteracting => _isInteracting;

  void updateTargetPosition(Offset newPosition) {
    _targetPosition = newPosition;
    notifyListeners();
  }

  void setMode(ButterflyMode mode) {
    _mode = mode;
    notifyListeners();
  }

  void startInteraction() {
    _isInteracting = true;
    _mode = ButterflyMode.follow;
    notifyListeners();
  }

  void endInteraction() {
    _isInteracting = false;
    _mode = ButterflyMode.random;
    notifyListeners();
  }
}

// movement_physics.dart
class MovementPhysics {
  static const double maxSpeed = 300.0; // pixels per second
  static const double acceleration = 200.0; // pixels per second squared
  static const double deceleration = 150.0; // pixels per second squared
  static const double hoverAmplitude = 2.0; // pixels
  static const double hoverFrequency = 1.5; // cycles per second
}

// interactive_butterfly.dart
class InteractiveButterfly extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final Duration duration;
  final double startXPercent;
  final double scale;
  final ButterflyController controller;

  const InteractiveButterfly({
    Key? key,
    required this.screenHeight,
    required this.screenWidth,
    required this.controller,
    this.duration = const Duration(seconds: 6),
    this.startXPercent = 0.5,
    this.scale = 1.0,
  }) : super(key: key);

  @override
  State<InteractiveButterfly> createState() => _InteractiveButterflyState();
}

class _InteractiveButterflyState extends State<InteractiveButterfly>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Offset _currentPosition;
  late Offset _randomTarget;
  final _random = Random();

  // Physics variables
  Offset _velocity = Offset.zero;
  double _currentSpeed = 0.0;
  double _hoverPhase = 0.0;

  // Path planning
  final List<Offset> _pathPoints = [];
  int _currentPathIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentPosition = Offset(
      widget.screenWidth * widget.startXPercent,
      widget.screenHeight - 100,
    );
    _randomTarget = _generateRandomTarget();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 16), // ~60 FPS
      vsync: this,
    )..addListener(_updatePosition);

    _controller.repeat();
    _generateNewPath();
  }

  Offset _generateRandomTarget() {
    // Generate a point within reasonable distance
    final maxDistance = widget.screenWidth * 0.3; // Max 30% of screen width
    final angle = _random.nextDouble() * 2 * pi;
    final distance = maxDistance * (0.3 + _random.nextDouble() * 0.7);

    final dx = _currentPosition.dx + cos(angle) * distance;
    final dy = _currentPosition.dy + sin(angle) * distance;

    // Constrain to screen bounds with padding
    return Offset(
      dx.clamp(50.0, widget.screenWidth - 50.0),
      dy.clamp(50.0, widget.screenHeight - 50.0),
    );
  }

  void _generateNewPath() {
    _pathPoints.clear();

    // Start from current position
    _pathPoints.add(_currentPosition);

    // Generate intermediate points for natural path
    final steps = 3 + _random.nextInt(3);
    Offset lastPoint = _currentPosition;

    for (int i = 0; i < steps; i++) {
      final maxDistance = widget.screenWidth * 0.2;
      final angle = _random.nextDouble() * 2 * pi;
      final distance = maxDistance * (0.3 + _random.nextDouble() * 0.7);

      final dx = lastPoint.dx + cos(angle) * distance;
      final dy = lastPoint.dy + sin(angle) * distance;

      final newPoint = Offset(
        dx.clamp(50.0, widget.screenWidth - 50.0),
        dy.clamp(50.0, widget.screenHeight - 50.0),
      );

      _pathPoints.add(newPoint);
      lastPoint = newPoint;
    }

    _currentPathIndex = 0;
  }

  void _updatePosition() {
    if (!mounted) return;

    final deltaTime = 0.016; // ~60 FPS
    setState(() {
      if (widget.controller.mode == ButterflyMode.follow) {
        _updateFollowMode(deltaTime);
      } else {
        _updateRandomMode(deltaTime);
      }

      // Add hovering effect
      _hoverPhase += MovementPhysics.hoverFrequency * deltaTime * 2 * pi;
      final hoverOffset = Offset(
        0,
        sin(_hoverPhase) * MovementPhysics.hoverAmplitude,
      );

      _currentPosition += hoverOffset;
    });
  }

  void _updateFollowMode(double deltaTime) {
    final target = widget.controller.targetPosition;
    final direction = target - _currentPosition;
    final distance = direction.distance;

    if (distance < 1.0) return;

    // Calculate desired velocity
    final targetVelocity = direction.normalize() * MovementPhysics.maxSpeed;

    // Smoothly interpolate current velocity towards target velocity
    _velocity = Offset(
      _lerpDouble(_velocity.dx, targetVelocity.dx, deltaTime * 5),
      _lerpDouble(_velocity.dy, targetVelocity.dy, deltaTime * 5),
    );

    // Update position
    _currentPosition += _velocity * deltaTime;
  }

  void _updateRandomMode(double deltaTime) {
    if (_currentPathIndex >= _pathPoints.length) {
      _generateNewPath();
      return;
    }

    final target = _pathPoints[_currentPathIndex];
    final direction = target - _currentPosition;
    final distance = direction.distance;

    if (distance < 10.0) {
      _currentPathIndex++;
      return;
    }

    // Calculate desired velocity
    final targetVelocity =
        direction.normalize() * MovementPhysics.maxSpeed * 0.5;

    // Smoothly interpolate current velocity towards target velocity
    _velocity = Offset(
      _lerpDouble(_velocity.dx, targetVelocity.dx, deltaTime * 3),
      _lerpDouble(_velocity.dy, targetVelocity.dy, deltaTime * 3),
    );

    // Update position
    _currentPosition += _velocity * deltaTime;
  }

  double _lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }

  double _calculateRotation() {
    if (_velocity.distance < 0.1) return 0.0;
    return atan2(_velocity.dy, _velocity.dx);
  }

  @override
  Widget build(BuildContext context) {
    final rotation = _calculateRotation();

    return Positioned(
      left: _currentPosition.dx - (25 * widget.scale),
      top: _currentPosition.dy - (17.5 * widget.scale),
      child: Transform.rotate(
        angle: rotation + pi / 2,
        child: FlutterButterfly(
          width: 50 * widget.scale,
          height: 35 * widget.scale,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// butterfly_swarm.dart
class ButterflySwarm extends StatefulWidget {
  final int numberOfButterflies;

  const ButterflySwarm({
    Key? key,
    this.numberOfButterflies = 15,
  }) : super(key: key);

  @override
  State<ButterflySwarm> createState() => _ButterflySwarmState();
}

class _ButterflySwarmState extends State<ButterflySwarm> {
  late final ButterflyController _controller;
  final List<ButterflyConfig> _butterflies = [];
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = ButterflyController();
    _initializeButterflies();
  }

  void _initializeButterflies() {
    for (int i = 0; i < widget.numberOfButterflies; i++) {
      _butterflies.add(
        ButterflyConfig(
          delay: Duration(milliseconds: _random.nextInt(5000)),
          duration: Duration(seconds: 6 + _random.nextInt(5)),
          startXPercent: 0.2 + (_random.nextDouble() * 0.6),
          scale: 0.8 + (_random.nextDouble() * 0.4),
        ),
      );
    }
  }

  void _handlePointerEvent(PointerEvent event) {
    if (event is PointerDownEvent) {
      _controller.startInteraction();
      _controller.updateTargetPosition(event.localPosition);
    } else if (event is PointerMoveEvent && _controller.isInteracting) {
      _controller.updateTargetPosition(event.localPosition);
    } else if (event is PointerUpEvent || event is PointerCancelEvent) {
      _controller.endInteraction();
    }
  }

  void _handleMouseEvent(PointerEvent event) {
    if (event is PointerHoverEvent) {
      // For mouse hover, we want to make butterflies follow without clicking
      if (!_controller.isInteracting) {
        _controller.startInteraction();
      }
      _controller.updateTargetPosition(event.localPosition);
    } else if (event is PointerExitEvent) {
      // When mouse leaves the area, stop following
      _controller.endInteraction();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        top: true,
        bottom: false,
        left: false,
        right: true,
        child: MouseRegion(
          onHover: _handleMouseEvent,
          onExit: _handleMouseEvent,
          child: Listener(
            behavior: HitTestBehavior.opaque,
            onPointerDown: _handlePointerEvent,
            onPointerMove: _handlePointerEvent,
            onPointerUp: _handlePointerEvent,
            onPointerCancel: _handlePointerEvent,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: _butterflies.map((config) {
                    return FutureBuilder(
                      future: Future.delayed(config.delay),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return const SizedBox.shrink();
                        }

                        return InteractiveButterfly(
                          screenHeight: constraints.maxHeight,
                          screenWidth: constraints.maxWidth,
                          duration: config.duration,
                          startXPercent: config.startXPercent,
                          scale: config.scale,
                          controller: _controller,
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
