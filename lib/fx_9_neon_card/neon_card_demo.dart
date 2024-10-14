import 'package:flutter/material.dart';
import 'package:fx_2_folder/fx_9_neon_card/neon_card.dart';
import 'package:fx_2_folder/fx_9_neon_card/neon_text.dart';

class NeonGradientCardDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        height: 200,
        child: Center(
          child: Container(
            child: const AnimatedGlowRectangle(
              intensity: 0.5,
              glowSpread: .8,
              child: SizedBox(
                width: 300,
                height: 200,
                child: Center(
                  child: GradientText(
                    text: 'Neon\nGradient\nCard',
                    fontSize: 44,
                    gradientColors: [
                      // Pink
                      Color.fromARGB(255, 255, 41, 117),
                      Color.fromARGB(255, 255, 41, 117),
                      Color.fromARGB(255, 9, 221, 222), // Cyan
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
