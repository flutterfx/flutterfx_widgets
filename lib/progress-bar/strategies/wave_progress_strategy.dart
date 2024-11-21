import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:fx_2_folder/progress-bar/progress_bar.dart';

/// Strategy for wave-style liquid progress animation
class DynamicWaveProgressStrategy implements ProgressAnimationStrategy {
  // Configuration for wave animation
  final Duration waveDuration;
  final bool autoAnimate;
  final Curve waveCurve;

  /// Creates a wave progress strategy
  /// [waveDuration] controls how fast the waves move
  /// [autoAnimate] determines if waves should animate automatically
  /// [waveCurve] defines the wave motion curve
  const DynamicWaveProgressStrategy({
    this.waveDuration = const Duration(milliseconds: 2000),
    this.autoAnimate = true,
    this.waveCurve = Curves.linear,
  });

  @override
  Widget buildProgressWidget({
    required double progress,
    required Animation<double> animation,
    required BuildContext context,
    required ProgressStyle style,
  }) {
    return _WaveProgressWidget(
      progress: progress,
      style: style,
      waveDuration: waveDuration,
      autoAnimate: autoAnimate,
      waveCurve: waveCurve,
    );
  }
}

/// Internal widget to handle wave animation state
class _WaveProgressWidget extends StatefulWidget {
  final double progress;
  final ProgressStyle style;
  final Duration waveDuration;
  final bool autoAnimate;
  final Curve waveCurve;

  const _WaveProgressWidget({
    Key? key,
    required this.progress,
    required this.style,
    required this.waveDuration,
    required this.autoAnimate,
    required this.waveCurve,
  }) : super(key: key);

  @override
  State<_WaveProgressWidget> createState() => _WaveProgressWidgetState();
}

class _WaveProgressWidgetState extends State<_WaveProgressWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _waveController;
  late final Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize wave animation controller
    _waveController = AnimationController(
      vsync: this,
      duration: widget.waveDuration,
    );

    // Create curved animation for wave movement
    _waveAnimation = CurvedAnimation(
      parent: _waveController,
      curve: widget.waveCurve,
    );

    // Start animation if auto-animate is enabled and progress < 100%
    if (widget.autoAnimate && widget.progress < 1.0) {
      _waveController.repeat();
    }
  }

  @override
  void didUpdateWidget(_WaveProgressWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle animation state based on progress
    if (widget.progress >= 1.0) {
      _waveController.stop();
    } else if (widget.autoAnimate && !_waveController.isAnimating) {
      _waveController.repeat();
    }

    // Update animation duration if changed
    if (widget.waveDuration != oldWidget.waveDuration) {
      _waveController.duration = widget.waveDuration;
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.style.width,
      height: widget.style.height,
      padding: widget.style.padding,
      child: ClipRRect(
        borderRadius: widget.style.borderRadius ?? BorderRadius.circular(8),
        child: CustomPaint(
          painter: WaveProgressPainter(
            progress: widget.progress,
            color: widget.style.primaryColor,
            animation: _waveAnimation,
          ),
        ),
      ),
    );
  }
}

/// Custom painter for wave progress effect with dynamic wave animation
class WaveProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Animation<double> animation;

  // Constants for wave configuration
  static const double _twoPi = 2 * math.pi;
  static const int _waveCount =
      2; // Number of overlapping waves for more natural effect

  WaveProgressPainter({
    required this.progress,
    required this.color,
    required this.animation,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate wave parameters based on progress
    final maxWaveHeight = size.height * 0.1; // Maximum height of waves at 0%
    final currentWaveHeight =
        maxWaveHeight * (1 - progress); // Waves reduce as progress increases

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Calculate the base water level
    final waterLevel = size.height * (1 - progress);

    // Create path for the wave
    final path = Path();
    path.moveTo(0, size.height); // Start from bottom-left

    // Width of one complete wave cycle
    final waveWidth = size.width / 2;

    // Draw multiple overlapping waves
    for (var i = 0; i < _waveCount; i++) {
      final wavePhase = i * math.pi / 2; // Phase difference between waves
      final opacity = i == 0 ? 1.0 : 0.5; // Second wave is more transparent

      paint.color = color.withOpacity(opacity);

      final wavePath = Path();
      wavePath.moveTo(0, size.height);

      // Draw wave points
      for (double x = 0; x <= size.width; x++) {
        final relativeX = x / waveWidth;
        final normalizedProgress = math.min(1.0, math.max(0.0, progress));

        // Wave function with dynamic amplitude and frequency
        final y = waterLevel +
            currentWaveHeight *
                math.sin((relativeX * _twoPi) +
                    (animation.value * 2 * _twoPi) +
                    wavePhase) *
                (1 -
                    normalizedProgress *
                        0.7); // Reduce wave height as progress increases

        wavePath.lineTo(x, y);
      }

      // Complete the wave path
      wavePath.lineTo(size.width, size.height);
      wavePath.lineTo(0, size.height);
      wavePath.close();

      // Draw the wave
      canvas.drawPath(wavePath, paint);
    }

    // Add a gentle gradient overlay for depth effect
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withOpacity(0.1),
          color.withOpacity(0.3),
        ],
        stops: const [0.0, 1.0],
      ).createShader(
          Rect.fromLTWH(0, waterLevel, size.width, size.height - waterLevel));

    canvas.drawRect(
      Rect.fromLTWH(0, waterLevel, size.width, size.height - waterLevel),
      gradientPaint,
    );
  }

  @override
  bool shouldRepaint(WaveProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.animation != animation;
  }
}
