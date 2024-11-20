import 'package:flutter/material.dart';
import 'package:fx_2_folder/fx_14_text_reveal/strategies/chaotic_spring_reveal_strategy.dart';
import 'package:fx_2_folder/fx_14_text_reveal/text_reveal_widget.dart';
import 'package:fx_2_folder/loader-sphere/grid.dart';

class TextChaoticSpringDemo extends StatefulWidget {
  const TextChaoticSpringDemo({Key? key}) : super(key: key);

  @override
  State<TextChaoticSpringDemo> createState() => _TextChaoticSpringDemoState();
}

class _TextChaoticSpringDemoState extends State<TextChaoticSpringDemo> {
  bool _isAnimating = false;
  final String _demoText = "Animate with Spring Physics!";

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        CustomPaint(
          painter: GridPatternPainter(isDarkMode: true),
          size: Size.infinite,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EnhancedTextRevealEffect(
              text: _demoText,
              trigger: _isAnimating,
              strategy: FancySpringStrategy(),
              unit: AnimationUnit.character,
              style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.normal),
              duration: Duration(milliseconds: 4000),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isAnimating = !_isAnimating;
                });
              },
              child: Text(_isAnimating ? "Reset" : "Animate"),
            ),
          ],
        ),
      ],
    );
  }
}
