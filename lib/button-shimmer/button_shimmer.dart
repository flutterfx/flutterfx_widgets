import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ShimmerButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color shimmerColorFrom;
  final Color shimmerColorTo;
  final double borderRadius;
  final Duration shimmerDuration;
  final Color background;
  final EdgeInsetsGeometry padding;
  final double borderWidth;
  final Color staticBorderColor;

  const ShimmerButton({
    Key? key,
    required this.child,
    this.onPressed,
    this.shimmerColorFrom = const Color(0xFFFFAA40),
    this.shimmerColorTo = const Color(0xFF9C40FF),
    this.borderRadius = 100.0,
    this.shimmerDuration = const Duration(seconds: 3),
    this.background = Colors.black,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    this.borderWidth = 1.5,
    this.staticBorderColor = const Color(0x1AFFFFFF), // 10% white
  }) : super(key: key);

  @override
  State<ShimmerButton> createState() => _ShimmerButtonState();
}

class _ShimmerButtonState extends State<ShimmerButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.shimmerDuration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onPressed,
      child: Container(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..translate(0.0, _isPressed ? 4.0 : 0.0, _isPressed ? 10.0 : 0.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: Stack(
            children: [
              Container(
                color: widget.background,
                padding: widget.padding,
                child: widget.child,
              ),

              // Shimmer border
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: ShimmerBorderPainter(
                        progress: _animation.value,
                        borderWidth: widget.borderWidth,
                        colorFrom: widget.shimmerColorFrom,
                        colorTo: widget.shimmerColorTo,
                        staticBorderColor: widget.staticBorderColor,
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                      ),
                    );
                  },
                ),
              ),

              // Highlight overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(_isPressed ? 0.2 : 0.1),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShimmerBorderPainter extends CustomPainter {
  final double progress;
  final double borderWidth;
  final Color colorFrom;
  final Color colorTo;
  final Color staticBorderColor;
  final BorderRadius borderRadius;

  ShimmerBorderPainter({
    required this.progress,
    required this.borderWidth,
    required this.colorFrom,
    required this.colorTo,
    required this.staticBorderColor,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = borderRadius.toRRect(rect);

    // Draw static border
    final staticPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..color = staticBorderColor;
    canvas.drawRRect(rrect, staticPaint);

    final path = Path()..addRRect(rrect);
    final pathMetrics = path.computeMetrics().first;
    final pathLength = pathMetrics.length;

    // Adjust the animation to prevent the jump
    final animationProgress = progress % 1.0;
    final start = animationProgress * pathLength;
    final end = (start + pathLength / 8) % pathLength;

    Path extractPath;
    if (end > start) {
      extractPath = pathMetrics.extractPath(start, end);
    } else {
      extractPath = pathMetrics.extractPath(start, pathLength);
      extractPath.addPath(pathMetrics.extractPath(0, end), Offset.zero);
    }

    // Calculate gradient start and end points
    final gradientStart =
        pathMetrics.getTangentForOffset(start)?.position ?? Offset.zero;
    final gradientEnd = pathMetrics
            .getTangentForOffset((start + pathLength / 8) % pathLength)
            ?.position ??
        Offset.zero;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    paint.shader = ui.Gradient.linear(
      gradientStart,
      gradientEnd,
      [
        colorTo.withOpacity(0.0),
        colorTo,
        colorFrom,
      ],
      [0.0, 0.3, 1.0],
    );

    canvas.drawPath(extractPath, paint);
  }

  @override
  bool shouldRepaint(covariant ShimmerBorderPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
