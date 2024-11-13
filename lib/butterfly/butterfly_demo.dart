import 'package:flutter/material.dart';
import 'package:fx_2_folder/butterfly/butterfly.dart';
import 'package:fx_2_folder/butterfly/butterfly_path.dart';

class ButterflyDemo extends StatefulWidget {
  const ButterflyDemo({Key? key}) : super(key: key);

  @override
  State<ButterflyDemo> createState() => _ButterflyDemoState();
}

class _ButterflyDemoState extends State<ButterflyDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: false,
        left: false,
        right: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              // Add this Stack widget
              children: [
                MovingButterfly(
                  screenHeight: constraints.maxHeight,
                  screenWidth: constraints.maxWidth,
                  duration: Duration(seconds: 8), // Slower movement
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
