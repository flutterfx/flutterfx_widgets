import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A widget that displays circles orbiting around a center point.
/// Each circle moves in its own orbit with customizable properties.
class OrbitingCircles extends StatelessWidget {
  // Constructor with named parameters for better readability
  const OrbitingCircles({
    super.key,
    this.children, // Widgets to display inside the orbiting circles
    this.orbitDuration = 20, // Time for one complete orbit (in seconds)
    this.startDelay = 10, // Delay before animation starts (in seconds)
    this.orbitRadius = 50, // Base radius for the first orbit
    this.showOrbitPaths = true, // Whether to show the circular paths
  });

  // Properties with clear names and documentation
  final List<Widget>? children; // Optional list of child widgets
  final double orbitDuration; // How long one orbit takes
  final double startDelay; // Delay before starting animation
  final double orbitRadius; // Base radius of the first orbit
  final bool showOrbitPaths; // Show or hide orbit paths

  @override
  Widget build(BuildContext context) {
    // Check if we're in dark mode
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Calculate the size needed to contain all orbits
    // We use 3 times the base radius to accommodate all orbits
    final containerSize = orbitRadius * 3;

    return SizedBox(
      width: containerSize * 2.5,
      height: containerSize * 2.5,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Draw orbit paths if enabled
          if (showOrbitPaths) ..._buildOrbitPaths(isDarkMode),

          // Draw orbiting circles if there are children
          if (children != null) ..._buildOrbitingCircles(isDarkMode),
        ],
      ),
    );
  }

  // Helper method to build orbit path circles
  List<Widget> _buildOrbitPaths(bool isDarkMode) {
    return List.generate(3, (index) {
      final pathRadius = orbitRadius * (index + 1);
      return Center(
        child: Container(
          width: pathRadius * 2,
          height: pathRadius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: _getPathColor(isDarkMode),
              width: 1,
            ),
          ),
        ),
      );
    });
  }

  // Helper method to build the orbiting circles
  List<Widget> _buildOrbitingCircles(bool isDarkMode) {
    return List.generate(
      children!.length,
      (index) {
        final circleRadius = orbitRadius * (index + 1);
        return Center(
          child: SingleOrbitingCircle(
            duration: orbitDuration,
            delay: startDelay * index,
            radius: circleRadius,
            moveClockwise: index.isEven,
            isDarkMode: isDarkMode,
            child: children![index],
          ),
        );
      },
    );
  }

  // Helper method to get the color for paths
  Color _getPathColor(bool isDarkMode) {
    return isDarkMode
        ? Colors.white.withOpacity(0.1)
        : Colors.black.withOpacity(0.1);
  }
}

/// A single orbiting circle widget that handles its own animation
class SingleOrbitingCircle extends StatefulWidget {
  const SingleOrbitingCircle({
    super.key,
    required this.duration,
    required this.delay,
    required this.radius,
    required this.isDarkMode,
    required this.moveClockwise,
    this.child,
  });

  final double duration; // Time for one complete orbit
  final double delay; // Delay before animation starts
  final double radius; // Distance from center
  final bool isDarkMode; // Current theme mode
  final bool moveClockwise; // Direction of movement
  final Widget? child; // Widget to display inside circle

  @override
  State<SingleOrbitingCircle> createState() => _SingleOrbitingCircleState();
}

class _SingleOrbitingCircleState extends State<SingleOrbitingCircle>
    with SingleTickerProviderStateMixin {
  // Animation controller for circular movement
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Setup the animation controller
    _controller = AnimationController(
      duration: Duration(seconds: widget.duration.toInt()),
      vsync: this,
    );

    // Start animation after delay
    Future.delayed(Duration(seconds: widget.delay.toInt()), () {
      if (mounted) {
        _controller.repeat(); // Continuously repeat the animation
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Clean up the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Calculate the current position in the orbit
        final angle = widget.moveClockwise
            ? -_controller.value * 2 * math.pi // Clockwise
            : _controller.value * 2 * math.pi; // Counter-clockwise

        // Use transform to position the circle
        return Transform(
          transform: Matrix4.identity()
            ..translate(
              widget.radius * math.cos(angle), // X position
              widget.radius * math.sin(angle), // Y position
            ),
          child: _buildCircle(),
        );
      },
    );
  }

  // Helper method to build the circle
  Widget _buildCircle() {
    final circleColor = widget.isDarkMode
        ? Colors.white.withOpacity(0.1)
        : Colors.black.withOpacity(0.1);

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: circleColor,
        border: Border.all(color: circleColor),
      ),
      child: Center(child: widget.child),
    );
  }
}

// Example usage:
// OrbitingCircles(
//   children: [
//     Icon(Icons.star),
//     Icon(Icons.favorite),
//     Icon(Icons.music_note),
//   ],
//   orbitDuration: 15,
//   startDelay: 5,
//   orbitRadius: 60,
//   showOrbitPaths: true,
// )