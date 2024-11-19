import 'package:flutter/material.dart';

class MotionBlurDemo extends StatefulWidget {
  const MotionBlurDemo({Key? key}) : super(key: key);

  @override
  State<MotionBlurDemo> createState() => _MotionBlurDemoState();
}

class _MotionBlurDemoState extends State<MotionBlurDemo>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  // Control the number of blur copies
  final int numberOfCopies = 10;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      // Using easeInOut for smooth acceleration and deceleration
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Title and Description
                Positioned(
                  top: 40,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Motion Blur Demonstration',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'This demo shows how motion blur works:\n'
                        '1. The square leaves "traces" as it moves\n'
                        '2. Each trace has decreasing opacity\n'
                        '3. Traces stretch more during fast movement',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),

                // Motion Blur Effect using multiple trailing copies
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Stack(
                      children: [
                        // Generate trailing copies with decreasing opacity
                        for (int i = 0; i < numberOfCopies; i++)
                          Positioned(
                            left: _calculatePosition(i),
                            top: 200,
                            child: Opacity(
                              opacity: _calculateOpacity(i),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),

                        // Main square
                        Positioned(
                          left: _animation.value *
                              (MediaQuery.of(context).size.width - 70),
                          top: 200,
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                // Velocity Indicator
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Positioned(
                      top: 300,
                      left: 20,
                      child: Text(
                        'Current Velocity: ${(_controller.velocity * 100).toStringAsFixed(1)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Control Panel
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'Motion blur is created by leaving multiple semi-transparent copies '
                  'of the object behind it as it moves. The faster the movement, '
                  'the more stretched and visible the blur becomes.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _startAnimation,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Start Animation',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Calculate position for each trailing copy
  double _calculatePosition(int index) {
    if (!_controller.isAnimating) return 0;

    // Current position
    double currentPos =
        _animation.value * (MediaQuery.of(context).size.width - 70);

    // Calculate how far behind this copy should be based on velocity
    double velocity = _controller.velocity;
    double trailDistance =
        velocity * 100; // Adjust this multiplier to change trail length

    // Each copy is increasingly further behind
    double offset = (trailDistance * index) / numberOfCopies;

    return currentPos - offset;
  }

  // Calculate opacity for each trailing copy
  double _calculateOpacity(int index) {
    if (!_controller.isAnimating) return 0;

    // Base opacity decreases for each trailing copy
    double baseOpacity = 1 - (index / numberOfCopies);

    // Modify opacity based on velocity
    double velocity = _controller.velocity.abs();
    double velocityFactor =
        velocity * 2; // Adjust this multiplier to change opacity sensitivity

    return (baseOpacity * velocityFactor).clamp(0.0, 0.3);
  }
}
