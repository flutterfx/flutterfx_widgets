import 'package:flutter/material.dart';
import 'package:fx_2_folder/fx_7_border_beam/border_beam.dart';

class BorderBeamHomeWidget extends StatelessWidget {
  const BorderBeamHomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: BorderBeam(
        duration: 5,
        colorFrom: Colors.blue,
        colorTo: Colors.purple,
        staticBorderColor: Colors.grey,
        borderRadius: BorderRadius.circular(20),
        padding: EdgeInsets.all(16),
        child: Container(
          width: 200,
          height: 200,
          color: Colors.white,
          child: Center(
            child: Text('Border Beam',
                style: TextStyle(fontSize: 24, color: Colors.black)),
          ),
        ),
      )),
      // SpringAnimationsDemo(),
    );
  }
}
