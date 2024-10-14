import 'package:flutter/material.dart';
import 'package:fx_2_folder/fx_8_shine_border/meteors.dart';

class MeteorDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MeteorShower(
        numberOfMeteors: 10,
        duration: Duration(seconds: 5),
        child: Text(
          'Shine Border',
          style: TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.w600,
            foreground: Paint()
              ..shader = LinearGradient(
                colors: [Colors.white, Colors.white.withOpacity(0.2)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
          ),
        ));
  }
}
