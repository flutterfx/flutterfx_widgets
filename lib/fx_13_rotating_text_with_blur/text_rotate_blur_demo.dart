import 'package:flutter/material.dart';
import 'package:fx_2_folder/fx_13_rotating_text_with_blur/reveal/clock_reveal.dart';
import 'package:fx_2_folder/fx_13_rotating_text_with_blur/strategies/all_strategies.dart';
import 'package:fx_2_folder/fx_13_rotating_text_with_blur/text_rotate_blur.dart';
import 'package:fx_2_folder/fx_14_text_reveal/strategies/FadeBlurStrategy.dart';

import '../fx_14_text_reveal/text_reveal_widget.dart';

class TextRotateBlurDemo extends StatefulWidget {
  const TextRotateBlurDemo({super.key});

  @override
  _TextRotateBlurDemoState createState() => _TextRotateBlurDemoState();
}

class _TextRotateBlurDemoState extends State<TextRotateBlurDemo> {
  // Idealy have a intro anim, exit anim and a rotate anim!
  // eg. intro strategy choice, exit strategy choice, rotate strategy choice
  // like the reveal text strategies.

  bool _isAnimating = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            // Example 1: Fade in, Wave rotation, Fade out
            RotatingTextWidget(
              text: 'Your rotating text here',
              radius: 100.0,
              textStyle: TextStyle(fontSize: 18, color: Colors.blue),
              rotationDuration: Duration(seconds: 15),
            ),
            ClockHandRevealWidget(
              duration: const Duration(seconds: 2),
              blurSigma: 5.0, // Stronger blur
              wedgeOpacity: 0.50, // 70% opacity
              wedgeAngleDegrees: 30.0,
              onAnimationComplete: () {
                print('Reveal complete!');
              },
              child: RotatingTextWidget(
                text: 'Your rotating text here',
                radius: 100.0,
                textStyle: TextStyle(fontSize: 18, color: Colors.black),
                rotationDuration: Duration(seconds: 15),
              ),
              // Container(
              //   width: 100,
              //   height: 100,
              //   color: Colors.blue,
              //   child: const Center(
              //     child: Text(
              //       'Hello World!',
              //       style: TextStyle(color: Colors.white),
              //     ),
              //   ),
              // ),
            ),

            // SizedBox(height: 20),

            // // Example 2: Flying characters entry, Bounce rotation, Spiral exit
            // EnhancedRotatingText(
            //   text: 'BOUNCE & SPIRAL',
            //   radius: 100,
            //   textStyle: TextStyle(fontSize: 24, color: Colors.purple),
            //   trigger: _isAnimating,
            //   entryStrategy: FlyingCharactersStrategy(),
            //   rotationStrategy: BounceRotationStrategy(
            //     bounceHeight: 25,
            //     bounceFrequency: 2,
            //   ),
            //   exitStrategy: SwirlFloatStrategy(),
            // ),

            // SizedBox(height: 20),

            // // Example 3: Swirl entry, Elastic rotation, Flip exit
            // EnhancedRotatingText(
            //   text: 'ELASTIC MOTION',
            //   radius: 100,
            //   textStyle: TextStyle(fontSize: 24, color: Colors.green),
            //   trigger: _isAnimating,
            //   entryStrategy: SwirlFloatStrategy(),
            //   rotationStrategy: ElasticRotationStrategy(
            //     elasticity: 0.4,
            //     frequency: 3,
            //   ),
            //   exitStrategy: FlipUpStrategy(),
            // ),

            // SizedBox(height: 20),

            // Example 4: Blur entry, Vibration rotation, Float exit
            // EnhancedRotatingText(
            //   text: 'VIBRATING TEXT',
            //   radius: 100,
            //   textStyle: TextStyle(fontSize: 24, color: Colors.orange),
            //   trigger: _isAnimating,
            //   entryStrategy: FadeBlurStrategy(),
            //   rotationStrategy: VibrationRotationStrategy(
            //     vibrationIntensity: 4,
            //     vibrationSpeed: 20,
            //   ),
            //   exitStrategy: SwirlFloatStrategy(),
            // ),

            // SizedBox(height: 20),

            // Control button
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isAnimating = !_isAnimating;
                });
              },
              child: Text(_isAnimating ? 'Stop Animation' : 'Start Animation'),
            ),
          ],
        ),
      ),
    );
    // return const Scaffold(
    //   body: Center(child: Text('Rotating text with blur')),
    // );
  }
}

// Let's also create a simpler FadeBlurStrategy for testing
class FadeBlurStrategy extends TextAnimationStrategy {
  final double maxBlur;

  const FadeBlurStrategy({this.maxBlur = 8.0}) : super();

  @override
  Widget buildAnimatedCharacter({
    required String character,
    required Animation<double> animation,
    TextStyle? style,
  }) {
    return ValueListenableBuilder<double>(
      valueListenable: animation,
      builder: (context, value, _) {
        return Text(
          character,
          style: style?.copyWith(
            color: style.color?.withOpacity(value),
          ),
        );
      },
    );
  }

  @override
  Animation<double> createAnimation(
      {required AnimationController controller,
      required double startTime,
      required double endTime,
      required Curve curve}) {
    // TODO: implement createAnimation
    throw UnimplementedError();
  }
}
