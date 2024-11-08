import 'package:flutter/material.dart';
import 'package:fx_2_folder/slider/slider.dart';
import 'package:fx_2_folder/stacked-scroll/stacked_scroll.dart';

class StackedScrollDemo extends StatefulWidget {
  const StackedScrollDemo({Key? key}) : super(key: key);

  @override
  State<StackedScrollDemo> createState() => _DemoState();
}

class _DemoState extends State<StackedScrollDemo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: double.infinity,
      width: double.infinity,
      child: Positioned.fill(
        child: StackingCardsList(),
      ),
    );
  }
}
