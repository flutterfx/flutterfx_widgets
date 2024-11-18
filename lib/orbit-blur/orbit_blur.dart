import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

/// Configuration class to manage animation settings
class OrbitConfig extends ChangeNotifier {
  bool _reverse = true;
  double _duration = 10.0;
  bool _showPaths = true;

  bool get reverse => _reverse;
  double get duration => _duration;
  bool get showPaths => _showPaths;

  set reverse(bool value) {
    _reverse = value;
    notifyListeners();
  }

  set duration(double value) {
    _duration = value;
    notifyListeners();
  }

  set showPaths(bool value) {
    _showPaths = value;
    notifyListeners();
  }
}

/// Main widget that combines controls and orbiting circles
class OrbitingIconsWithControls extends StatelessWidget {
  final OrbitConfig config;

  OrbitingIconsWithControls({Key? key})
      : config = OrbitConfig(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: config,
          builder: (context, child) {
            return OrbitingIcons(
              reverse: config.reverse,
              duration: config.duration,
              showPaths: config.showPaths,
            );
          },
        ),
      ],
    );
  }
}

/// Configuration panel widget
class OrbitConfigPanel extends StatelessWidget {
  final OrbitConfig config;

  const OrbitConfigPanel({Key? key, required this.config}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configuration',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Reverse Direction:'),
                Switch(
                  value: config.reverse,
                  onChanged: (value) => config.reverse = value,
                ),
              ],
            ),
            Row(
              children: [
                const Text('Show Paths:'),
                Switch(
                  value: config.showPaths,
                  onChanged: (value) => config.showPaths = value,
                ),
              ],
            ),
            Slider(
              value: config.duration,
              min: 5,
              max: 20,
              divisions: 15,
              label: '${config.duration.round()}s',
              onChanged: (value) => config.duration = value,
            ),
            Text('Duration: ${config.duration.round()} seconds'),
          ],
        ),
      ),
    );
  }
}

/// Main orbiting icons widget
class OrbitingIcons extends StatelessWidget {
  final bool reverse;
  final double duration;
  final bool showPaths;

  const OrbitingIcons({
    Key? key,
    required this.reverse,
    required this.duration,
    required this.showPaths,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final leftIcons = [
      Icons.star,
      Icons.favorite,
      Icons.ac_unit,
    ];

    final rightIcons = [
      Icons.settings,
      Icons.cloud,
      Icons.engineering,
    ];

    // Increased overall width to allow proper spacing
    return SizedBox(
      width: 350,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Left orbit
          Positioned(
            left: 40,  // Adjusted position
            child: OrbitingCircle(
              duration: duration,
              radius: 60,  // Adjusted radius
              showPath: showPaths,
              clockwise: !reverse,
              icons: leftIcons.map((icon) => _buildIcon(icon)).toList(),
            ),
          ),
          // Right orbit
          Positioned(
            right: 40,  // Adjusted position
            child: OrbitingCircle(
              duration: duration,
              radius: 60,  // Adjusted radius
              showPath: showPaths,
              clockwise: reverse,
              icons: rightIcons.map((icon) => _buildIcon(icon)).toList(),
            ),
          ),
          // Center blur overlay with chevron
Center(
  child: Stack(
    alignment: Alignment.center,
    children: [
      // First BackdropFilter for the background blur
      ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.withOpacity(0.15),
            ),
          ),
        ),
      ),
      // Second BackdropFilter specifically for the chevron
      ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: CustomPaint(
            size: const Size(35, 35),
            painter: ChevronPainter(),
          ),
        ),
      ),
    ],
  ),
),
        ],
      ),
    );
  }

  Widget _buildIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 20,
        color: Colors.blue,
      ),
    );
  }
}

class ChevronPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.6)  // Reduced opacity to blend better
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      // Add blur effect to the paint itself
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.5);

    final path = Path();
    
    // Adjusted chevron shape
    path.moveTo(size.width * 0.3, size.height * 0.4);
    path.lineTo(size.width * 0.5, size.height * 0.6);
    path.lineTo(size.width * 0.7, size.height * 0.4);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


class OrbitingCircle extends StatelessWidget {
  final double duration;
  final double radius;
  final bool showPath;
  final bool clockwise;
  final List<Widget> icons;

  const OrbitingCircle({
    Key? key,
    required this.duration,
    required this.radius,
    required this.showPath,
    required this.clockwise,
    required this.icons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: radius * 2,
      height: radius * 2,
      child: Stack(
        clipBehavior: Clip.none, // Allow icons to overflow the container
        children: [
          if (showPath) _buildPath(isDarkMode),
          ...icons.asMap().entries.map((entry) {
            final index = entry.key;
            final icon = entry.value;
            return SingleOrbitingCircle(
              duration: duration,
              delay: duration / icons.length * index,
              radius: radius,
              moveClockwise: clockwise,
              isDarkMode: isDarkMode,
              child: icon,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildPath(bool isDarkMode) {
    return Center(
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isDarkMode
                ? Colors.black.withOpacity(0.1)
                : Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
    );
  }
}
class SingleOrbitingCircle extends StatefulWidget {
  final double duration;
  final double delay;
  final double radius;
  final bool isDarkMode;
  final bool moveClockwise;
  final Widget? child;

  const SingleOrbitingCircle({
    Key? key,
    required this.duration,
    required this.delay,
    required this.radius,
    required this.isDarkMode,
    required this.moveClockwise,
    this.child,
  }) : super(key: key);

  @override
  State<SingleOrbitingCircle> createState() => _SingleOrbitingCircleState();
}

class _SingleOrbitingCircleState extends State<SingleOrbitingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: widget.duration.toInt()),
      vsync: this,
    );

    Future.delayed(Duration(milliseconds: (widget.delay * 1000).toInt()), () {
      if (mounted) {
        _controller.repeat();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final angle = widget.moveClockwise
            ? -_controller.value * 2 * math.pi
            : _controller.value * 2 * math.pi;

        return Transform.translate(
          offset: Offset(
            widget.radius + (widget.radius * math.cos(angle)) - 18,  // -18 to center the 36px icon
            widget.radius + (widget.radius * math.sin(angle)) - 18,  // -18 to center the 36px icon
          ),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[850],
              border: Border.all(
                color: Colors.grey[800]!,
                width: 1,
              ),
            ),
            child: Center(child: widget.child),
          ),
        );
      },
    );
  }
}

// Main app
void main() {
  runApp(
    MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        body: Center(
          child: OrbitingIconsWithControls(),
        ),
      ),
    ),
  );
}