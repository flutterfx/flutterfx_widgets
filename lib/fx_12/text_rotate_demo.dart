import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fx_2_folder/fx_10_hyper_text/hyper_text.dart';
import 'package:fx_2_folder/fx_12/text_rotate.dart';

class TextRotateDemo extends StatefulWidget {
  @override
  _TextRotateDemoState createState() => _TextRotateDemoState();
}

class _TextRotateDemoState extends State<TextRotateDemo> {
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
              child: const IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: CircularCharacterRotatingText(
                          text: 'Your rotating text here',
                          radius: 100.0,
                          textStyle:
                              TextStyle(fontSize: 18, color: Colors.blue),
                          rotationDuration: Duration(seconds: 15),
                        ),
                      ),
                    ),
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
