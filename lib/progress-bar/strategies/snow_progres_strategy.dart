import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:fx_2_folder/progress-bar/progress_bar.dart';

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'dart:math' as math;

class SnowProgressStrategy implements ProgressAnimationStrategy {
  final int snowflakeCount;
  final double maxSnowflakeSize;
  final Color? snowColor;

  const SnowProgressStrategy({
    this.snowflakeCount = 40, // Increased for smoother effect
    this.maxSnowflakeSize = 3,
    this.snowColor,
  });

  @override
  Widget buildProgressWidget({
    required double progress,
    required Animation<double> animation,
    required BuildContext context,
    required ProgressStyle style,
  }) {
    return _SnowProgressWidget(
      progress: progress,
      style: style,
      snowflakeCount: snowflakeCount,
      maxSnowflakeSize: maxSnowflakeSize,
      snowColor: snowColor ?? style.primaryColor,
    );
  }
}

class _SnowProgressWidget extends StatefulWidget {
  final double progress;
  final ProgressStyle style;
  final int snowflakeCount;
  final double maxSnowflakeSize;
  final Color snowColor;

  const _SnowProgressWidget({
    Key? key,
    required this.progress,
    required this.style,
    required this.snowflakeCount,
    required this.maxSnowflakeSize,
    required this.snowColor,
  }) : super(key: key);

  @override
  State<_SnowProgressWidget> createState() => _SnowProgressWidgetState();
}

class _SnowProgressWidgetState extends State<_SnowProgressWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Snowflake> snowflakes;
  final math.Random random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
          seconds: 12), // Increased duration for slower animation
    )..repeat();

    // Initialize snowflakes with better vertical distribution
    snowflakes = List.generate(
      widget.snowflakeCount,
      (index) => _createSnowflake(
        initialY: (index / widget.snowflakeCount) * 1.2 - 0.2,
      ),
    );
  }

  Snowflake _createSnowflake({double? initialY}) {
    return Snowflake(
      x: random.nextDouble(),
      y: initialY ?? random.nextDouble() * -0.2,
      size: _generateSnowflakeSize(),
      // Much slower speed range
      speed: random.nextDouble() * 0.04 + 0.03,
      wobbleFrequency: random.nextDouble() * 1.0 + 0.5, // Gentler wobble
      wobbleAmplitude: random.nextDouble() * 0.01 + 0.005, // Smaller amplitude
      opacity: random.nextDouble() * 0.4 + 0.6,
    );
  }

  double _generateSnowflakeSize() {
    // Gaussian distribution for natural size variation
    final u1 = random.nextDouble();
    final u2 = random.nextDouble();
    final normalRandom =
        math.sqrt(-2.0 * math.log(u1)) * math.cos(2.0 * math.pi * u2);
    final size = (normalRandom * 0.5 + 1.0) * widget.maxSnowflakeSize;
    return math.min(
        math.max(size, widget.maxSnowflakeSize * 0.3), widget.maxSnowflakeSize);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.style.width,
      height: widget.style.height,
      padding: widget.style.padding,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          _updateSnowflakes();
          return CustomPaint(
            painter: SnowProgressPainter(
              progress: widget.progress,
              snowflakes: snowflakes,
              snowColor: widget.snowColor,
              backgroundColor: widget.style.backgroundColor,
              animation: _controller,
            ),
          );
        },
      ),
    );
  }

  void _updateSnowflakes() {
    final time = _controller.value * 2 * math.pi;

    for (var i = 0; i < snowflakes.length; i++) {
      // Slower vertical movement
      snowflakes[i].y += snowflakes[i].speed;

      // Smoother horizontal wobble
      snowflakes[i].x += math.sin(time * snowflakes[i].wobbleFrequency + i) *
          snowflakes[i].wobbleAmplitude;

      // Reset snowflake when it goes below container
      if (snowflakes[i].y > 1.1) {
        snowflakes[i] = _createSnowflake();
      }
    }
  }
}

class Snowflake {
  double x;
  double y;
  final double size;
  final double speed;
  final double wobbleFrequency;
  final double wobbleAmplitude;
  final double opacity;

  Snowflake({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.wobbleFrequency,
    required this.wobbleAmplitude,
    required this.opacity,
  });
}

class SnowProgressPainter extends CustomPainter {
  final double progress;
  final List<Snowflake> snowflakes;
  final Color snowColor;
  final Color backgroundColor;
  final Animation<double> animation;

  SnowProgressPainter({
    required this.progress,
    required this.snowflakes,
    required this.snowColor,
    required this.backgroundColor,
    required this.animation,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, bgPaint);

    // Calculate snow height ensuring full coverage at 100%
    final maxSnowHeight = size.height;
    final baseSnowHeight = maxSnowHeight * progress;

    // Draw accumulated snow with smooth surface
    final snowPath = Path();
    final snowPaint = Paint()
      ..color = snowColor
      ..style = PaintingStyle.fill;

    snowPath.moveTo(0, size.height);

    if (progress >= 0.95) {
      // When near 100%, make the surface completely flat
      snowPath.lineTo(0, size.height * (1 - progress));
      snowPath.lineTo(size.width, size.height * (1 - progress));
    } else {
      // Generate smooth curve points with subtle movement
      final points = List.generate(30, (i) {
        final x = size.width * (i / 29);
        final waveFactor =
            (1 - progress) * 0.05; // Reduce wave height as progress increases
        final normalizedHeight =
            math.sin(i * 0.3 + animation.value * 2) * waveFactor;
        final y = size.height - (baseSnowHeight * (1 + normalizedHeight));
        return Offset(x, y);
      });

      // Draw smooth curve through points
      snowPath.lineTo(0, points.first.dy);

      for (var i = 0; i < points.length - 1; i++) {
        final current = points[i];
        final next = points[i + 1];
        final controlPoint = Offset(
          (current.dx + next.dx) / 2,
          current.dy + (next.dy - current.dy) * 0.5,
        );
        snowPath.quadraticBezierTo(
          controlPoint.dx,
          controlPoint.dy,
          next.dx,
          next.dy,
        );
      }
    }

    snowPath.lineTo(size.width, size.height);
    snowPath.close();

    // Add subtle gradient for depth
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        snowColor,
        snowColor.withOpacity(0.85),
      ],
    ).createShader(Offset.zero & size);

    snowPaint.shader = gradient;
    canvas.drawPath(snowPath, snowPaint);

    // Draw falling snowflakes
    for (final snowflake in snowflakes) {
      final snowflakeX = snowflake.x * size.width;
      final snowflakeY = snowflake.y * size.height;

      // Only draw snowflakes above the snow pile
      if (snowflakeY < size.height - (baseSnowHeight * 0.9)) {
        final flakePaint = Paint()
          ..color = snowColor.withOpacity(snowflake.opacity)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(
          Offset(snowflakeX, snowflakeY),
          snowflake.size,
          flakePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(SnowProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.snowColor != snowColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.animation != animation;
  }
}
