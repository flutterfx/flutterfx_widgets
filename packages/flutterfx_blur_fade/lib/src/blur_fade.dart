import 'package:flutter/material.dart';
import 'dart:ui';

class BlurFade extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final bool? isVisible;

  const BlurFade({
    Key? key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 200),
    this.isVisible,
  }) : super(key: key);

  @override
  _BlurFadeState createState() => _BlurFadeState();
}

class _BlurFadeState extends State<BlurFade>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _blurAnimation;

  bool _isFirstBuild = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _blurAnimation = Tween<double>(begin: 10.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    _handleVisibilityChange();
  }

  void _handleVisibilityChange() {
    Future.delayed(widget.delay, () {
      if (!mounted) return;

      if (widget.isVisible == true) {
        _controller.forward();
      } else if (widget.isVisible == false) {
        _controller.reverse();
      } else if (_isFirstBuild) {
        _controller.forward();
      }

      _isFirstBuild = false;
    });
  }

  @override
  void didUpdateWidget(BlurFade oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      _handleVisibilityChange();
    }
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
        return Opacity(
          opacity: _opacityAnimation.value,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: _blurAnimation.value,
              sigmaY: _blurAnimation.value,
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
}
