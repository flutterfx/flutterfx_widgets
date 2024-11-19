import 'package:flutter/material.dart';
import 'package:fx_2_folder/gemini-splash/combined_.dart';
import 'package:fx_2_folder/gemini-splash/glowing_fog.dart';

class SparkleDemo extends StatefulWidget {
  const SparkleDemo({super.key});

  @override
  State<SparkleDemo> createState() => _SparkleDemoState();
}

class _SparkleDemoState extends State<SparkleDemo> {
  Key _combinedKey = UniqueKey();

  final GlobalKey<MysticalWavesState> _wavesKey = GlobalKey();

  void _replayAnimation() {
    setState(() {
      _combinedKey = UniqueKey();
      _wavesKey.currentState?.stopAnimation();
    });
  }

  void _onStarAnimationComplete() {
    // Start waves animation when star animation completes
    _wavesKey.currentState?.startAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          UnifiedStarAnimation(
            key: _combinedKey,
            size: 50,
            color: Colors.yellow,
            totalDuration: Duration(milliseconds: 2000),
            onAnimationComplete: _onStarAnimationComplete,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: MysticalWaves(
                key: _wavesKey,
                height: 200,
                animationDuration: const Duration(milliseconds: 400),
                waveDuration: const Duration(seconds: 3),
                waveColors: [
                  Color(0xFFFFD700).withOpacity(0.5), // Radiant gold
                  Color(0xFFFFA500).withOpacity(0.4), // Glowing orange
                  Color(0xFFFFE4B5).withOpacity(0.3), // Soft moccasin
                ]),
          ),
          Positioned(
            bottom: 50,
            child: Row(
              children: [
                IconButton(
                  onPressed: _replayAnimation,
                  icon: const Icon(
                    Icons.replay_circle_filled_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
