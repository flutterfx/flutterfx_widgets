// progress_loader.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

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

/// Linear progress bar strategy
class LinearProgressStrategy implements ProgressAnimationStrategy {
  @override
  Widget buildProgressWidget({
    required double progress,
    required Animation<double> animation,
    required BuildContext context,
    required ProgressStyle style,
  }) {
    return Container(
      width: style.width,
      height: style.height,
      padding: style.padding,
      child: ClipRRect(
        borderRadius: style.borderRadius ?? BorderRadius.circular(8),
        child: Stack(
          children: [
            Container(color: style.backgroundColor),
            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: style.primaryColor,
                  gradient: style.gradientColors != null
                      ? LinearGradient(
                          colors: style.gradientColors!,
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        )
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Circular progress bar strategy
class CircularProgressStrategy implements ProgressAnimationStrategy {
  final double strokeWidth;

  CircularProgressStrategy({this.strokeWidth = 8.0});

  @override
  Widget buildProgressWidget({
    required double progress,
    required Animation<double> animation,
    required BuildContext context,
    required ProgressStyle style,
  }) {
    return Container(
      width: style.width,
      height:
          style.width, // Using width for both dimensions to keep it circular
      padding: style.padding,
      child: CustomPaint(
        painter: CircularProgressPainter(
          progress: progress,
          strokeWidth: strokeWidth,
          backgroundColor: style.backgroundColor,
          progressColor: style.primaryColor,
          gradientColors: style.gradientColors,
        ),
      ),
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;
  final List<Color>? gradientColors;

  CircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.progressColor,
    this.gradientColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - strokeWidth / 2;

    // Draw background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Create the progress arc path
    final rect = Rect.fromCircle(center: center, radius: radius);
    final path = Path()
      ..addArc(
        rect,
        -math.pi / 2, // Start from top
        2 * math.pi * progress, // Progress amount
      );

    final pathMetrics = path.computeMetrics().first;
    final pathLength = pathMetrics.length;

    // Calculate gradient points based on the current progress
    final startPoint = pathMetrics.getTangentForOffset(0)?.position ?? center;
    final endPoint =
        pathMetrics.getTangentForOffset(pathLength)?.position ?? center;

    // Draw progress arc
    final progressPaint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    if (gradientColors != null && gradientColors!.length >= 2) {
      // Create a gradient that follows the arc
      progressPaint.shader = ui.Gradient.linear(
        startPoint,
        endPoint,
        [
          gradientColors![0],
          gradientColors![1],
          gradientColors![0], // Add the first color again for smooth transition
        ],
        [0.0, 0.5, 1.0],
      );
    } else {
      progressPaint.color = progressColor;
    }

    // Draw the progress path
    canvas.drawPath(path, progressPaint);
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.progressColor != progressColor;
  }
}
