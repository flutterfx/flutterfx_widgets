import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fx_2_folder/butterfly/butterfly.dart';

class MovingButterfly extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final Duration duration;

  const MovingButterfly({
    Key? key,
    required this.screenHeight,
    required this.screenWidth,
    this.duration = const Duration(seconds: 6),
  }) : super(key: key);

  @override
  State<MovingButterfly> createState() => _MovingButterflyState();
}

class _MovingButterflyState extends State<MovingButterfly>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  // Path points for the Bézier curve
  late Offset _start;
  late Offset _end;
  late Offset _control1;
  late Offset _control2;

  @override
  void initState() {
    super.initState();

    // Initialize start and end points
    _start = Offset(widget.screenWidth * 0.5, widget.screenHeight - 100);
    _end = Offset(widget.screenWidth * 0.5, 100);

    // Create control points for the curve
    // Adding randomness to make it more natural
    final random = Random();
    _control1 = Offset(
      widget.screenWidth * (0.2 + random.nextDouble() * 0.3),
      widget.screenHeight * 0.6,
    );
    _control2 = Offset(
      widget.screenWidth * (0.5 + random.nextDouble() * 0.3),
      widget.screenHeight * 0.3,
    );

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    // Start the animation
    _controller.forward();

    // Optional: Loop the animation
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Reset control points for variation in the return journey
        _control1 = Offset(
          widget.screenWidth * (0.2 + random.nextDouble() * 0.3),
          widget.screenHeight * 0.6,
        );
        _control2 = Offset(
          widget.screenWidth * (0.5 + random.nextDouble() * 0.3),
          widget.screenHeight * 0.3,
        );
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        // Reset control points for variation in the next journey
        _control1 = Offset(
          widget.screenWidth * (0.2 + random.nextDouble() * 0.3),
          widget.screenHeight * 0.6,
        );
        _control2 = Offset(
          widget.screenWidth * (0.5 + random.nextDouble() * 0.3),
          widget.screenHeight * 0.3,
        );
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Calculate position along the Bézier curve
  Offset _calculatePosition(double t) {
    // Cubic Bézier curve formula
    final double u = 1 - t;
    final double tt = t * t;
    final double uu = u * u;
    final double uuu = uu * u;
    final double ttt = tt * t;

    final double x = uuu * _start.dx +
        3 * uu * t * _control1.dx +
        3 * u * tt * _control2.dx +
        ttt * _end.dx;
    final double y = uuu * _start.dy +
        3 * uu * t * _control1.dy +
        3 * u * tt * _control2.dy +
        ttt * _end.dy;

    return Offset(x, y);
  }

  // Calculate rotation angle based on the curve's tangent
  double _calculateRotation(double t) {
    // Calculate the derivative of the Bézier curve
    final double epsilon = 0.001;
    final Offset currentPos = _calculatePosition(t);
    final Offset nextPos = _calculatePosition(t + epsilon);

    // Calculate the angle of movement
    return atan2(nextPos.dy - currentPos.dy, nextPos.dx - currentPos.dx);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final position = _calculatePosition(_animation.value);
        final rotation = _calculateRotation(_animation.value);

        // Check if we're going up or down and adjust rotation accordingly
        final bool isGoingUp =
            !_controller.status.toString().contains("reverse");
        final adjustedRotation =
            isGoingUp ? rotation + pi / 2 : rotation - pi / 2;

        return Positioned(
          left: position.dx - 25,
          top: position.dy - 17.5,
          child: Transform.rotate(
            angle:
                adjustedRotation, // Use adjustedRotation instead of rotation - pi/2
            child: const FlutterButterfly(width: 50, height: 35),
          ),
        );
      },
    );
  }
}
