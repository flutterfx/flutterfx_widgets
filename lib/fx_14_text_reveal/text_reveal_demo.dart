import 'package:flutter/material.dart';
import 'package:fx_2_folder/fx_14_text_reveal/text_reveal_widget.dart';
import 'package:fx_2_folder/fx_9_neon_card/neon_card.dart';
import 'package:fx_2_folder/fx_9_neon_card/neon_text.dart';

class TextRevealDemo extends StatefulWidget {
  @override
  State<TextRevealDemo> createState() => _TextRevealDemoState();
}

class _TextRevealDemoState extends State<TextRevealDemo> {
  bool _triggerAnimation = false;

  void _onTriggerPressed() {
    setState(() {
      _triggerAnimation = !_triggerAnimation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 370,
            child: TextRevealEffect(
              text:
                  "A flutter widget that animatestext reveal", //TODO bug fix: dont split words in the middle!
              style: TextStyle(fontSize: 20),
              duration: Duration(milliseconds: 2500),
              trigger: _triggerAnimation,
            ),
          ),
          SizedBox(height: 60),
          ElevatedButton(
            onPressed: _onTriggerPressed,
            child: Text("Trigger Animation"),
          ),
        ],
      ),
    );
  }
}
