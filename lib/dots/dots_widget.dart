import 'dart:math' show pow, sqrt, Random;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;

/// A beautiful, interactive dot pattern that responds to touch with physical animations.
///
/// This widget creates a grid of dots that react to touch input with smooth,
/// spring-based animations. When touched, the dots create a dent-like effect,
/// moving away from the touch point in a physically accurate manner.
///
/// Example usage:
/// ```dart
/// Scaffold(
///   body: DotPattern(),
/// )
/// ```
class DotPattern extends StatefulWidget {
  /// Creates an interactive dot pattern.
  ///
  /// The pattern fills its container with a responsive grid of animated dots.
  const DotPattern({super.key});

  @override
  State<DotPattern> createState() => _DotPatternState();
}

class _DotPatternState extends State<DotPattern>
    with SingleTickerProviderStateMixin {
  // Animation Configuration
  late final AnimationController _animationController;
  static const Duration _animationDuration = Duration(milliseconds: 300);

  // Touch Tracking
  Offset? _targetTouchLocation;
  Offset? _currentTouchLocation;
  DateTime _lastFeedbackTime = DateTime.now();

  // Grid Configuration
  static const int _columns = 15;
  static const int _rows = 30;
  static const double _dotSize = 6;
  static const double _maxEffectRadius = 100;

  // Physics Configuration
  static const double _dragAnimationSpeed =
      0.6; // Controls how quickly dots follow touch
  static const double _springStiffness =
      0.85; // Controls the springiness of the effect

  @override
  void initState() {
    super.initState();
    _setupAnimationController();
  }

  /// Sets up the animation controller with spring physics
  void _setupAnimationController() {
    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..addListener(_updateTouchLocation);
  }

  /// Updates the touch location with spring physics animation
  void _updateTouchLocation() {
    if (_targetTouchLocation == null || _currentTouchLocation == null) return;

    setState(() {
      final double progress = _animationController.value;
      // Apply spring physics using quadratic easing
      final springProgress = -pow(progress - 1, 2) * _springStiffness + 1;

      _currentTouchLocation = Offset.lerp(
        _currentTouchLocation,
        _targetTouchLocation,
        springProgress * _dragAnimationSpeed,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _handleTouch,
      onPanUpdate: _handleTouch,
      onPanEnd: (_) => _clearTouch(),
      child: Container(
        color: Colors.black,
        child: CustomPaint(
          painter: _DotsPainter(
            columns: _columns,
            rows: _rows,
            dotSize: _dotSize,
            touchLocation: _currentTouchLocation,
            maxEffectRadius: _maxEffectRadius,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }

  /// Handles touch input and triggers haptic feedback
  void _handleTouch(dynamic details) {
    setState(() {
      _targetTouchLocation = details.localPosition;

      // Initialize touch location if this is the first touch
      if (_currentTouchLocation == null) {
        _currentTouchLocation = _targetTouchLocation;
        _animationController.value = 0;
      }

      // For drag updates, continue from current animation progress
      final startValue =
          details is DragUpdateDetails ? _animationController.value : 0.0;

      _animationController.forward(from: startValue);
    });

    _triggerHapticFeedback();
  }

  /// Provides haptic feedback with rate limiting
  void _triggerHapticFeedback() {
    final now = DateTime.now();
    if (now.difference(_lastFeedbackTime).inMilliseconds > 100) {
      HapticFeedback.lightImpact();
      _lastFeedbackTime = now;
    }
  }

  /// Clears touch state when interaction ends
  void _clearTouch() {
    setState(() {
      _targetTouchLocation = null;
      _currentTouchLocation = null;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

/// Custom painter that renders the dot grid with interactive effects
class _DotsPainter extends CustomPainter {
  final int columns;
  final int rows;
  final double dotSize;
  final Offset? touchLocation;
  final double maxEffectRadius;

  // Physics configuration
  static const double _dentStrength =
      20.0; // Controls the depth of the touch effect

  const _DotsPainter({
    required this.columns,
    required this.rows,
    required this.dotSize,
    required this.touchLocation,
    required this.maxEffectRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final cellWidth = size.width / (columns - 1);
    final cellHeight = size.height / (rows - 1);

    _drawDotGrid(canvas, paint, size, cellWidth, cellHeight);
  }

  /// Draws the grid of interactive dots
  void _drawDotGrid(Canvas canvas, Paint paint, Size size, double cellWidth,
      double cellHeight) {
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < columns; col++) {
        final position = _calculateDotPosition(col, row, cellWidth, cellHeight);
        final adjustedPosition = _applyTouchEffect(position);

        canvas.drawCircle(
            adjustedPosition.center, adjustedPosition.size / 2, paint);
      }
    }
  }

  /// Calculates the base position for a dot
  Offset _calculateDotPosition(
      int col, int row, double cellWidth, double cellHeight) {
    return Offset(col * cellWidth, row * cellHeight);
  }

  /// Applies touch-based displacement and scaling to a dot
  ({Offset center, double size}) _applyTouchEffect(Offset originalCenter) {
    double scale = 1.0;
    Offset displacement = Offset.zero;

    if (touchLocation != null) {
      final toTouch = touchLocation! - originalCenter;
      final distance = toTouch.distance;

      if (distance < maxEffectRadius) {
        final normalizedDistance = distance / maxEffectRadius;

        // Calculate scale with smooth falloff
        scale = 0.3 + (pow(normalizedDistance, 1.5) * 0.7);

        // Calculate displacement using a bell curve for smooth transition
        final displacementStrength = _dentStrength *
            (1 - normalizedDistance) *
            (1 - pow(normalizedDistance, 2));

        displacement = toTouch.normalize() * displacementStrength;
      }
    }

    return (
      center: originalCenter + displacement,
      size: dotSize * scale,
    );
  }

  @override
  bool shouldRepaint(_DotsPainter oldDelegate) {
    return touchLocation != oldDelegate.touchLocation;
  }
}

/// Extension for vector normalization
extension VectorNormalization on Offset {
  /// Returns a normalized version of the offset (vector with length 1)
  Offset normalize() {
    final length = sqrt(dx * dx + dy * dy);
    return Offset(dx / length, dy / length);
  }
}
