// progress_loader.dart
import 'package:flutter/material.dart';

/// Abstract class defining the contract for progress animation strategies
abstract class ProgressAnimationStrategy {
  Widget buildProgressWidget({
    required double progress,
    required Animation<double> animation,
    required BuildContext context,
    required ProgressStyle style,
  });
}

/// Style configuration for progress loaders
class ProgressStyle {
  final Color primaryColor;
  final Color backgroundColor;
  final double width;
  final double height;
  final EdgeInsets padding;
  final BorderRadius? borderRadius;
  final List<Color>? gradientColors;
  final Curve curve;
  final Duration animationDuration;

  const ProgressStyle({
    this.primaryColor = Colors.blue,
    this.backgroundColor = Colors.grey,
    this.width = 200,
    this.height = 20,
    this.padding = EdgeInsets.zero,
    this.borderRadius,
    this.gradientColors,
    this.curve = Curves.easeInOut,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  ProgressStyle copyWith({
    Color? primaryColor,
    Color? backgroundColor,
    double? width,
    double? height,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
    List<Color>? gradientColors,
    Curve? curve,
    Duration? animationDuration,
  }) {
    return ProgressStyle(
      primaryColor: primaryColor ?? this.primaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      width: width ?? this.width,
      height: height ?? this.height,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      gradientColors: gradientColors ?? this.gradientColors,
      curve: curve ?? this.curve,
      animationDuration: animationDuration ?? this.animationDuration,
    );
  }
}

/// Main progress loader widget that uses a strategy pattern
class ProgressLoader extends StatefulWidget {
  final double progress;
  final ProgressAnimationStrategy strategy;
  final ProgressStyle style;
  final ValueChanged<double>? onProgressUpdate;

  const ProgressLoader({
    Key? key,
    required this.progress,
    required this.strategy,
    this.style = const ProgressStyle(),
    this.onProgressUpdate,
  }) : super(key: key);

  @override
  State<ProgressLoader> createState() => _ProgressLoaderState();
}

class _ProgressLoaderState extends State<ProgressLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.style.animationDuration,
    );
    _animation = Tween<double>(
      begin: 0,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.style.curve,
    ))
      ..addListener(() {
        if (widget.onProgressUpdate != null) {
          widget.onProgressUpdate!(_animation.value);
        }
      });
    _controller.forward();
  }

  @override
  void didUpdateWidget(ProgressLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(
        begin: oldWidget.progress,
        end: widget.progress,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: widget.style.curve,
      ));
      _controller.forward(from: 0);
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
      animation: _animation,
      builder: (context, child) {
        return widget.strategy.buildProgressWidget(
          progress: _animation.value,
          animation: _animation,
          context: context,
          style: widget.style,
        );
      },
    );
  }
}
