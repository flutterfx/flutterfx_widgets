import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fx_2_folder/fx_10_hyper_text/hyper_text.dart';
import 'package:fx_2_folder/fx_12/text_rotate.dart';

class TextRotateDemo extends StatefulWidget {
  @override
  _TextRotateDemoState createState() => _TextRotateDemoState();
}

class _TextRotateDemoState extends State<TextRotateDemo> {
  bool _triggerAnimation = false;
  Timer? _resetTimer;

  void _handleAnimationTrigger() {
    setState(() {
      _triggerAnimation = true;
    });

    // Cancel any existing timer
    _resetTimer?.cancel();

    // Set a new timer to reset the trigger after 300ms
    _resetTimer = Timer(Duration(milliseconds: 300), () {
      setState(() {
        _triggerAnimation = false;
      });
    });
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: Center(
                        child: CircularCharacterRotatingText(
                          text: 'Your rotating text here',
                          radius: 100.0,
                          textStyle:
                              TextStyle(fontSize: 18, color: Colors.blue),
                          rotationDuration: Duration(seconds: 15),
                        ),

                        // HyperText(
                        //   text: "Hyper Text",
                        //   textStyle: TextStyle(
                        //     fontSize: 32,
                        //     fontWeight: FontWeight.bold,
                        //     color: Colors.white70,
                        //   ),
                        //   animationTrigger: _triggerAnimation,
                        // ),
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _handleAnimationTrigger,
                      child: Text("Trigger Animation"),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
