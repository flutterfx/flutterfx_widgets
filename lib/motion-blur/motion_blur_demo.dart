import 'package:flutter/material.dart';
import 'package:fx_2_folder/motion-blur/motion_blur.dart';
import 'package:fx_2_folder/motion-blur/motion_blur_1.dart';

class MotionStreakingDemo extends StatefulWidget {
  const MotionStreakingDemo({super.key});

  @override
  State<MotionStreakingDemo> createState() => _MotionStreakingDemoState();
}

class _MotionStreakingDemoState extends State<MotionStreakingDemo> {
  Key _sparkleKey = UniqueKey();
  Key _starFallKey = UniqueKey();

  void _replayAnimation() {
    setState(() {
      _sparkleKey =
          UniqueKey(); // This will recreate the AnimatedSparkle widget
      _starFallKey = UniqueKey();
    });
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
          ExampleScreen(),
          Positioned(
            bottom: 50,
            child: IconButton(
              onPressed: _replayAnimation,
              icon: const Icon(
                Icons.replay_circle_filled_rounded,
                color: Colors.white,
                size: 48,
              ),
            ),
          ),
          // MotionBlurWidget(
          //   child: Container(
          //     width: 100,
          //     height: 100,
          //     decoration: BoxDecoration(
          //       color: Colors.red,
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
