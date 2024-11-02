import 'package:flutter/material.dart';
import 'package:fx_2_folder/dots/dots_widget.dart';

class DotPatternWidget extends StatelessWidget {
  const DotPatternWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: DotPattern(),
      ),
    );
  }
}
