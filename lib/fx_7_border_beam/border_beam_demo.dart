import 'package:flutter/material.dart';
import 'package:fx_2_folder/fx_7_border_beam/border_beam.dart';

class BorderBeamHomeWidget extends StatelessWidget {
  const BorderBeamHomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: BorderBeam(
          duration: 7,
          colorFrom: Colors.blue,
          colorTo: Colors.purple,
          staticBorderColor:
              const Color.fromARGB(255, 39, 39, 42), //rgb(39 39 42)
          borderRadius: BorderRadius.circular(20),
          padding: EdgeInsets.all(16),
          child: Container(
            width: 200,
            height: 200,
            child: const Center(
              child: Text('Border Beam',
                  style: TextStyle(fontSize: 24, color: Colors.white)),
            ),
          ),
        ),
      ),
    );
  }
}
