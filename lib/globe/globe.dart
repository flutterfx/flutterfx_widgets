import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:vector_math/vector_math.dart' as vector;

class IconItem {
  final String name;
  final IconData icon;
  vector.Vector3 position;
  double scale;
  final Color color;

  IconItem({
    required this.name,
    required this.icon,
    required this.position,
    required this.color,
    this.scale = 1.0,
  });
}

class IconCloud extends StatefulWidget {
  final List<IconData> icons;
  final double radius;
  final Color defaultIconColor;

  const IconCloud({
    Key? key,
    required this.icons,
    this.radius = 150.0,
    this.defaultIconColor = Colors.white,
  }) : super(key: key);

  @override
  State<IconCloud> createState() => _IconCloudState();
}

class _IconCloudState extends State<IconCloud>
    with SingleTickerProviderStateMixin {
  List<IconItem> iconItems = [];
  late AnimationController _controller;
  double _lastControllerValue = 0.0;
  double _lastInteractionValue = 0.0;

  // Physics-based animation
  SpringDescription _springDescription = const SpringDescription(
    mass: 1,
    stiffness: 50,
    damping: 10,
  );

  // Interaction state
  Offset _lastPanPosition = Offset.zero;
  vector.Vector2 _rotationVelocity = vector.Vector2.zero();
  bool _isInteracting = false;
  DateTime? _lastInteractionTime;

  @override
  void initState() {
    super.initState();
    _initializeIcons();
    _setupAnimation();
  }

  void _initializeIcons() {
    if (widget.icons.isEmpty) return;

    iconItems = List.generate(widget.icons.length, (index) {
      final phi = math.acos(-1.0 + (2.0 * index) / widget.icons.length);
      final theta = math.sqrt(widget.icons.length * math.pi) * phi;

      final x = widget.radius * math.cos(theta) * math.sin(phi);
      final y = widget.radius * math.sin(theta) * math.sin(phi);
      final z = widget.radius * math.cos(phi);

      return IconItem(
        name: 'Icon $index',
        icon: widget.icons[index],
        position: vector.Vector3(x, y, z),
        color: widget.defaultIconColor,
        scale: 1.0,
      );
    });
  }

  void _setupAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(_performAutoRotation);

    _controller.repeat();
  }

  void _performAutoRotation() {
    if (!mounted || iconItems.isEmpty || _isInteracting) return;

    // Don't auto-rotate if we recently had user interaction
    if (_lastInteractionTime != null) {
      final timeSinceInteraction =
          DateTime.now().difference(_lastInteractionTime!);
      if (timeSinceInteraction.inMilliseconds < 500)
        return; // Wait for interaction to settle
    }

    setState(() {
      // Calculate the delta rotation
      final currentValue = _controller.value;
      final deltaValue = currentValue - _lastControllerValue;

      // Handle wrap-around case
      final adjustedDelta = deltaValue.abs() > 0.5
          ? deltaValue.sign * (1 - deltaValue.abs())
          : deltaValue;

      if (adjustedDelta.abs() > 0.0001) {
        // Calculate delta rotation in radians
        final deltaRotation = adjustedDelta *
            2 *
            math.pi *
            0.1; // Reduced speed for smoother motion

        // Create rotation matrix for just the delta
        final deltaRotationMatrix = vector.Matrix4.rotationY(deltaRotation);

        // Apply delta rotation to each item's current position
        for (var item in iconItems) {
          // Transform the current position by the delta rotation
          final transformed = deltaRotationMatrix.transform3(item.position);
          item.position
            ..x = transformed.x
            ..y = transformed.y
            ..z = transformed.z;
        }
      }

      _lastControllerValue = currentValue;
    });
  }

  void _handlePanStart(DragStartDetails details) {
    _isInteracting = true;
    _lastPanPosition = details.localPosition;
    _lastInteractionValue = 0.0;
    // Store the current controller value but don't reset it
    _controller.stop();
    // Keep track of where we stopped for smooth continuation
    _lastControllerValue = _controller.value;
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (!mounted || iconItems.isEmpty) return;

    setState(() {
      final delta = details.localPosition - _lastPanPosition;

      // Calculate rotation deltas (scaled down for better control)
      final deltaX = -delta.dy * 0.005;
      final deltaY = delta.dx * 0.005;

      // Create and combine rotation matrices for X and Y rotations
      final deltaMatrixX = vector.Matrix4.rotationX(deltaX);
      final deltaMatrixY = vector.Matrix4.rotationY(deltaY);
      final combinedMatrix = deltaMatrixY..multiply(deltaMatrixX);

      // Apply the delta rotation to each item's current position
      for (var item in iconItems) {
        final transformed = combinedMatrix.transform3(item.position);
        item.position
          ..x = transformed.x
          ..y = transformed.y
          ..z = transformed.z;
      }

      // Store velocity for physics simulation
      _rotationVelocity = vector.Vector2(deltaY, deltaX);
      _lastInteractionValue +=
          deltaY; // Track total rotation for smooth transition
    });

    _lastPanPosition = details.localPosition;
  }

  void _handlePanEnd(DragEndDetails details) {
    _isInteracting = false;
    _lastInteractionTime = DateTime.now();

    // Calculate initial velocity for physics simulation
    final velocity = _rotationVelocity.length;

    // if (velocity > 0.001) {
    //   // Start physics simulation
    //   final simulation = SpringSimulation(
    //     _springDescription,
    //     0,
    //     1,
    //     velocity,
    //   );

    // Create animation for smooth transition
    // Animation<double> animation = _controller.drive(
    //   Tween<double>(
    //     begin: _lastInteractionValue,
    //     end: 0,
    //   ),
    // );

    // animation.addListener(() {
    //   if (!mounted) return;
    //   setState(() {
    //     final deltaRotation = _lastInteractionValue - animation.value;
    //     final deltaMatrix = vector.Matrix4.rotationY(deltaRotation);

    //     for (var item in iconItems) {
    //       final transformed = deltaMatrix.transform3(item.position);
    //       item.position
    //         ..x = transformed.x
    //         ..y = transformed.y
    //         ..z = transformed.z;
    //     }
    //     _lastInteractionValue = animation.value;
    //   });
    // });

    // Animate to rest using physics
    //   _controller.animateWith(simulation).then((_) {
    //     if (mounted) {
    //       // Instead of resetting, continue from current value
    //       _controller.value =
    //           _controller.value; // Ensure we're at the current value
    //       _controller.repeat(); // Resume auto-rotation
    //       _lastControllerValue = _controller.value; // Maintain continuity
    //     }
    //   });
    // } else {
    //   // If velocity is very low, just resume auto-rotation smoothly
    //   _controller.value = _controller.value; // Maintain current position
    //   _controller.repeat();
    //   _lastControllerValue = _controller.value;
    // }
  }

  @override
  Widget build(BuildContext context) {
    if (iconItems.isEmpty) {
      return SizedBox(
        width: widget.radius * 2,
        height: widget.radius * 2,
      );
    }

    return GestureDetector(
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      child: SizedBox(
        width: widget.radius * 2,
        height: widget.radius * 2,
        child: CustomPaint(
          painter: IconCloudPainter(
            iconItems: iconItems,
            radius: widget.radius,
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

class IconCloudPainter extends CustomPainter {
  final List<IconItem> iconItems;
  final double radius;

  IconCloudPainter({
    required this.iconItems,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final sortedIcons = List<IconItem>.from(iconItems)
      ..sort((a, b) => b.position.z.compareTo(a.position.z));

    for (var item in sortedIcons) {
      final center = Offset(
        size.width / 2 + item.position.x,
        size.height / 2 + item.position.y,
      );

      final opacity = math.max(
          0.4, math.min(1.0, (item.position.z + radius) / (radius * 2)));

      final iconPainter = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(item.icon.codePoint),
          style: TextStyle(
            fontSize: 24 * item.scale,
            fontFamily: item.icon.fontFamily,
            package: item.icon.fontPackage,
            color: item.color.withOpacity(opacity),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      iconPainter.paint(
        canvas,
        center.translate(-iconPainter.width / 2, -iconPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(IconCloudPainter oldDelegate) => true;
}
