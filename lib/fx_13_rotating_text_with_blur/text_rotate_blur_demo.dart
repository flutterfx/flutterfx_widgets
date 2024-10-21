import 'package:flutter/material.dart';
import 'package:fx_2_folder/fx_12_rotating_text/text_rotate.dart';
import 'package:fx_2_folder/fx_13_rotating_text_with_blur/sweeping_reveal.dart';

class TextRotateBlurDemo extends StatefulWidget {
  const TextRotateBlurDemo({super.key});

  @override
  _TextRotateBlurDemoState createState() => _TextRotateBlurDemoState();
}

class _TextRotateBlurDemoState extends State<TextRotateBlurDemo> {
  bool _isRevealed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sweeping Reveal Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SweepingReveal(
              child: RotatingTextWidget(
                text: 'Your rotating text here',
                radius: 100.0,
                textStyle: TextStyle(fontSize: 18, color: Colors.blue),
                rotationDuration: Duration(seconds: 20000),
              ),
              duration: Duration(seconds: 2),
              reveal: true,
              blurSigma: 80.0,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => {
                setState(() {
                  _isRevealed = !_isRevealed;
                })
              },
              child: Text('Reveal'),
            ),
            // ElevatedButton(
            //   onPressed: () => _revealKey.currentState?.hide(),
            //   child: Text('Hide'),
            // ),
          ],
        ),
      ),
    );
  }
}
