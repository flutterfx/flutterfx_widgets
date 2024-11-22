import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fx_2_folder/loader-avatars/strategies/loader_strategy_pulse.dart';
import 'package:fx_2_folder/loader-avatars/strategies/loader_strategy_ripple.dart';
import 'package:fx_2_folder/loader-avatars/strategies/loader_strategy_wave.dart';

// Step 1: Define the strategy interface
abstract class AvatarAnimationStrategy {
  Duration getAnimationDuration(int index);
  Duration getAnimationDelay(int index, int totalAvatars);
  bool get shouldReverseAnimation;

  Widget buildAnimatedAvatar({
    required Widget child,
    required Animation<double> animation,
    required int index,
  });
}

// Step 3: Main widget that uses the strategy
class AnimatedAvatarRow extends StatefulWidget {
  final int numberOfAvatars;
  final double avatarSize;
  final double overlapFactor;
  final Curve animationCurve;
  final AvatarAnimationStrategy animationStrategy;
  final List<ImageProvider>? avatarImages;
  final List<Color>? borderColors;

  const AnimatedAvatarRow({
    Key? key,
    this.numberOfAvatars = 5,
    this.avatarSize = 45.0,
    this.overlapFactor = 0.6,
    this.animationCurve = Curves.easeInOut,
    required this.animationStrategy,
    this.avatarImages,
    this.borderColors,
  }) : super(key: key);

  @override
  State<AnimatedAvatarRow> createState() => _AnimatedAvatarRowState();
}

class _AnimatedAvatarRowState extends State<AnimatedAvatarRow>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  static const List<Color> _defaultBorderColors = [
    Color(0xFFFFE0B2),
    Color(0xFFE1BEE7),
    Color(0xFFBBDEFB),
    Color(0xFFC8E6C9),
    Color(0xFFFFCDD2),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controllers = List.generate(
      widget.numberOfAvatars,
      (index) => AnimationController(
        duration: widget.animationStrategy.getAnimationDuration(index),
        vsync: this,
      ),
    );

    _animations = List.generate(
      widget.numberOfAvatars,
      (index) => Tween<double>(
        begin: 0.0,
        end: math.pi * 2,
      ).animate(
        CurvedAnimation(
          parent: _controllers[index],
          curve: widget.animationCurve,
        ),
      ),
    );

    for (int i = 0; i < widget.numberOfAvatars; i++) {
      Future.delayed(
        widget.animationStrategy.getAnimationDelay(i, widget.numberOfAvatars),
        () {
          if (mounted) {
            _controllers[i].repeat(
              reverse: widget.animationStrategy.shouldReverseAnimation,
            );
          }
        },
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Color _getBorderColor(int index) {
    if (widget.borderColors != null && index < widget.borderColors!.length) {
      return widget.borderColors![index];
    }
    return _defaultBorderColors[index % _defaultBorderColors.length];
  }

  Widget _buildAvatar(int index) {
    final hasImage =
        widget.avatarImages != null && index < widget.avatarImages!.length;
    final borderColor = _getBorderColor(index);

    return Container(
      width: widget.avatarSize,
      height: widget.avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: borderColor,
          width: 3.0,
        ),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: ClipOval(
          child: hasImage
              ? Image(
                  image: widget.avatarImages![index],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const FlutterLogo(),
                )
              : const FlutterLogo(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rowWidth = widget.avatarSize +
        (widget.avatarSize *
            (1 - widget.overlapFactor) *
            (widget.numberOfAvatars - 1));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: rowWidth,
        height: widget.avatarSize + 24.0, // Account for animation displacement
        child: Stack(
          clipBehavior: Clip.none,
          children: List.generate(
            widget.numberOfAvatars,
            (index) {
              return Positioned(
                left: index * (widget.avatarSize * (1 - widget.overlapFactor)),
                child: AnimatedBuilder(
                  animation: _animations[index],
                  builder: (context, child) {
                    return widget.animationStrategy.buildAnimatedAvatar(
                      child: child!,
                      animation: _animations[index],
                      index: index,
                    );
                  },
                  child: _buildAvatar(index),
                ),
              );
            },
          ).reversed.toList(),
        ),
      ),
    );
  }
}

// Example usage
class ExampleImplementation extends StatelessWidget {
  const ExampleImplementation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animated Avatar Row')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Wave animation example
              AnimatedAvatarRow(
                numberOfAvatars: 5,
                avatarSize: 50,
                animationStrategy: WaveAnimationStrategy(
                  animationDuration: const Duration(milliseconds: 1200),
                  staggerDelay: const Duration(milliseconds: 120),
                  reverseWave: false,
                ),
              ),
              const SizedBox(height: 20),

              // Ripple animation example
              AnimatedAvatarRow(
                numberOfAvatars: 5,
                avatarSize: 50,
                animationStrategy: RippleAnimationStrategy(
                  maxDisplacement: 15.0,
                  staggerDelay: const Duration(milliseconds: 150),
                ),
              ),
              const SizedBox(height: 20),

              // Pulse animation example with custom settings
              AnimatedAvatarRow(
                numberOfAvatars: 5,
                avatarSize: 50,
                animationStrategy: PulseAnimationStrategy(
                  scaleAmount: 0.4,
                  waveWidth: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
