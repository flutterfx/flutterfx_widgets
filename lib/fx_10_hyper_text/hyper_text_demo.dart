import 'dart:async';
import 'package:flutter/material.dart';
import 'hyper_text.dart';

class HyperTextDemo extends StatefulWidget {
  const HyperTextDemo({super.key});

  @override
  _HyperTextDemoState createState() => _HyperTextDemoState();
}

class _HyperTextDemoState extends State<HyperTextDemo> {
  Timer? _resetTimer;
  bool _triggerAnimation = false;

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

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
                    Expanded(
                      child: Center(
                        child: HyperText(
                          text: "Hyper Text",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
                          animationTrigger: _triggerAnimation,
                        ),
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
