import 'package:flutter/material.dart';
import 'package:fx_2_folder/text-3d-pop/text_3d_pop.dart';

class Text3dPopDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Gyro3DText(
          text: "FLUTTER",
          fontSize: 52,
          textColor: const Color.fromARGB(255, 255, 232, 120), // f08c02
          shadowColor: const Color.fromARGB(255, 240, 140, 2),
          maxTiltAngle: 30.0,
          shadowSensitivity: 0.1, // Reduced for smoother movement
          movementThreshold: 2.0, // Minimum 2 degrees tilt to start movement
          smoothingFactor: 0.1, // How much shadows move per degree
        ),
      ),
    );
  }
}
