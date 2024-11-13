import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fx_2_folder/butterfly/butterfly.dart';
import 'package:fx_2_folder/butterfly/butterfly_path.dart';

class ButterflyDemo extends StatefulWidget {
  const ButterflyDemo({Key? key}) : super(key: key);

  @override
  State<ButterflyDemo> createState() => _ButterflyDemoState();
}

class _ButterflyDemoState extends State<ButterflyDemo> {
  // List to store butterfly configurations
  final List<ButterflyConfig> butterflies = [];
  static const int numberOfButterflies =
      15; // Change this to adjust number of butterflies

  @override
  void initState() {
    super.initState();
    // Create random butterflies with different delays and paths
    final random = Random();

    for (int i = 0; i < numberOfButterflies; i++) {
      butterflies.add(
        ButterflyConfig(
          // Random delay between 0 and 5 seconds
          delay: Duration(milliseconds: random.nextInt(5000)),
          // Random duration between 6 and 10 seconds
          duration: Duration(seconds: 6 + random.nextInt(5)),
          // Random starting X position between 20% and 80% of screen width
          startXPercent: 0.2 + (random.nextDouble() * 0.6),
          // Random size between 0.8 and 1.2 of original size
          scale: 0.8 + (random.nextDouble() * 0.4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: false,
        left: false,
        right: false,
        child: LayoutBuilder(builder: (context, constraints) {
          return Stack(
            children: butterflies.map((config) {
              return FutureBuilder(
                future: Future.delayed(config.delay),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const SizedBox.shrink();
                  }

                  return MovingButterfly(
                    screenHeight: constraints.maxHeight,
                    screenWidth: constraints.maxWidth,
                    duration: config.duration,
                    startXPercent: config.startXPercent,
                    scale: config.scale,
                  );
                },
              );
            }).toList(),
          );
        }),
      ),
    );
  }
}

// Configuration class for each butterfly
class ButterflyConfig {
  final Duration delay;
  final Duration duration;
  final double startXPercent;
  final double scale;

  ButterflyConfig({
    required this.delay,
    required this.duration,
    required this.startXPercent,
    required this.scale,
  });
}
