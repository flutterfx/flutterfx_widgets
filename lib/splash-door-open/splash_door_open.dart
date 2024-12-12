import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:fx_2_folder/splash-door-open/sample_welcome_screen.dart';

class DoorSplashScreen extends StatefulWidget {
  final Widget child; // The widget to reveal after animation
  final Duration animationDuration;

  const DoorSplashScreen({
    Key? key,
    required this.child,
    this.animationDuration = const Duration(seconds: 3),
  }) : super(key: key);

  @override
  State<DoorSplashScreen> createState() => _DoorSplashScreenState();
}

class _DoorSplashScreenState extends State<DoorSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: math.pi / 2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Simulate loading time
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _isLoading = false);
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDoor(bool isLeft) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform(
          alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0015)
            ..rotateY(isLeft ? -_animation.value : _animation.value),
          child: Container(
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                left: isLeft
                    ? BorderSide.none
                    : const BorderSide(color: Colors.grey, width: 1),
                right: isLeft
                    ? const BorderSide(color: Colors.grey, width: 1)
                    : BorderSide.none,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (_isLoading && !isLeft)
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background content to reveal
        widget.child,

        // Door overlay
        Row(
          children: [
            _buildDoor(true), // Left door
            _buildDoor(false), // Right door
          ],
        ),
      ],
    );
  }
}

// Usage example:
class SplashDoorOpenRevealDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //remove debug banner
      debugShowCheckedModeBanner: false,
      home: DoorSplashScreen(
        child: SimpleWelcomeScreen(),
      ),
    );
  }
}
