// particles_demo.dart
import 'package:flutter/material.dart';
import 'package:fx_2_folder/button-shimmer/button_shimmer.dart';
import 'package:fx_2_folder/stacked-expand-cards/stacked_expand_card.dart';

class ButtonShimmerDemo extends StatefulWidget {
  const ButtonShimmerDemo({Key? key}) : super(key: key);

  @override
  State<ButtonShimmerDemo> createState() => _ParticlesDemoState();
}

class _ParticlesDemoState extends State<ButtonShimmerDemo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: double.infinity,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: GridPatternPainter(isDarkMode: true),
              ),
            ),
            ShimmerButton(
              onPressed: () {
                // Handle tap
                print('onpressed');
              },
              shimmerColorFrom: Color.fromARGB(255, 255, 255, 255), // Orange
              shimmerColorTo: Color.fromARGB(255, 255, 255, 255), // Purple
              background: Colors.black,
              borderRadius: 100,
              shimmerDuration: Duration(seconds: 3),
              borderWidth: 1.5,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Text(
                'Click Me',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            )
          ],
        ),
      ),
    );
  }
}
