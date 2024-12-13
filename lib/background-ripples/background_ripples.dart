import 'package:flutter/material.dart';

class Ripple extends StatefulWidget {
  final double mainCircleSize;
  final double mainCircleOpacity;
  final int numCircles;
  final Color color;
  final Duration duration;

  const Ripple({
    super.key,
    this.mainCircleSize = 210,
    this.mainCircleOpacity = 0.24,
    this.numCircles = 8,
    this.color = Colors.black,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<Ripple> createState() => _RippleState();
}

class _RippleState extends State<Ripple> with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _scaleAnimations;

  @override
  void initState() {
    super.initState();

    // Create controllers with staggered starts
    _controllers = List.generate(
      widget.numCircles,
      (index) {
        final controller = AnimationController(
          duration: widget.duration,
          vsync: this,
        );

        // Calculate delay for each circle
        final delay = (index * 0.1 * widget.duration.inMilliseconds).toInt();

        Future.delayed(Duration(milliseconds: delay), () {
          if (mounted) {
            controller.repeat(reverse: true); // Key change: added reverse
          }
        });

        return controller;
      },
    );

    // Create smooth animations
    _scaleAnimations = _controllers.map((controller) {
      return Tween<double>(
        begin: 1.0,
        end: 0.9,
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut, // Smooth easing both ways
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.transparent],
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: Stack(
        children: List.generate(widget.numCircles, (index) {
          final size = widget.mainCircleSize + (index * 70);
          final opacity = widget.mainCircleOpacity - (index * 0.03);
          final borderOpacity = (5 + index * 5) / 100;

          return Center(
            child: AnimatedBuilder(
              animation: _scaleAnimations[index],
              builder: (context, child) => Transform.scale(
                scale: _scaleAnimations[index].value,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withOpacity(opacity),
                    border: Border.all(
                      color: widget.color.withOpacity(borderOpacity),
                      width: 1,
                      style: index == widget.numCircles - 1
                          ? BorderStyle.solid
                          : BorderStyle.solid,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class BackgroundRippleDemo extends StatelessWidget {
  const BackgroundRippleDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Center(
          child: Text(
            'Hola!',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Ripple(
          color: Colors.blue,
          mainCircleSize: 130,
          mainCircleOpacity: 0.34,
          numCircles: 5,
          duration: Duration(seconds: 1),
        ),
      ],
    );
  }
}
