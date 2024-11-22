import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fx_2_folder/splash-reveal/sample_home_screen.dart';

class SplashRevealController {
  _SplashRevealWidgetState? _state;
  bool _isAnimating = false;

  Future<void> startReveal() async {
    if (_state != null && !_isAnimating) {
      _isAnimating = true;
      await _state!._startAnimation();
      _isAnimating = false;
    }
  }

  void reset() {
    if (_state != null) {
      _state!._resetAnimation();
    }
  }

  bool get isAnimating => _isAnimating;
}

class SplashRevealWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Color overlayColor;
  final VoidCallback? onAnimationComplete;
  final SplashRevealController controller;

  const SplashRevealWidget({
    Key? key,
    required this.child,
    required this.controller,
    this.duration = const Duration(milliseconds: 1000),
    this.overlayColor = Colors.white,
    this.onAnimationComplete,
  }) : super(key: key);

  @override
  State<SplashRevealWidget> createState() => _SplashRevealWidgetState();
}

class _SplashRevealWidgetState extends State<SplashRevealWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    widget.controller._state = this;
  }

  Future<void> _startAnimation() async {
    await _controller.forward();
    if (widget.onAnimationComplete != null) {
      widget.onAnimationComplete!();
    }
  }

  void _resetAnimation() {
    _controller.reset();
  }

  @override
  void dispose() {
    if (widget.controller._state == this) {
      widget.controller._state = null;
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The main content that will be revealed
        widget.child,

        // The white overlay that will be clipped away
        AnimatedBuilder(
          animation: _animation,
          builder: (context, _) {
            return ClipPath(
              clipper: CircularRevealClipper(
                revealPercent: _animation.value,
              ),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: widget.overlayColor,
                // Added logo and loading indicator
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Custom App Logo
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 155, 155, 155),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.dashboard_rounded,
                        size: 36,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // App Name
                    const Text(
                      'Dashboard',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 155, 155, 155),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class CircularRevealClipper extends CustomClipper<Path> {
  final double revealPercent;

  CircularRevealClipper({required this.revealPercent});

  @override
  Path getClip(Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius =
        sqrt((size.width * size.width + size.height * size.height).toDouble()) +
            20;
    final radius = maxRadius * revealPercent;

    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addOval(Rect.fromCircle(center: center, radius: radius))
      ..fillType = PathFillType.evenOdd;

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class LoadingApp1 extends StatefulWidget {
  const LoadingApp1({Key? key}) : super(key: key);

  @override
  State<LoadingApp1> createState() => _LoadingAppState();
}

class _LoadingAppState extends State<LoadingApp1> {
  final _revealController = SplashRevealController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
    await _revealController.startReveal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashRevealWidget(
        controller: _revealController,
        duration: const Duration(milliseconds: 1500),
        overlayColor: Colors.white,
        onAnimationComplete: () {
          print('Reveal completed!');
        },
        child: Stack(
          children: [
            const MonochromeHomeScreen(),
            if (_isLoading)
              Container(
                color: Colors.white,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF757575),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
