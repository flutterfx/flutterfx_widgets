import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:fx_2_folder/visibility/blur_fade_widget.dart';

class BlurFadeExample extends StatefulWidget {
  @override
  State<BlurFadeExample> createState() => _BlurFadeExampleState();
}

class _BlurFadeExampleState extends State<BlurFadeExample> {
  bool _isVisible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlurFade(
              isVisible: _isVisible,
              child: const Text(
                'Hello, World! 👋',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(padding: EdgeInsets.all(5)),
            BlurFade(
              delay: const Duration(milliseconds: 100),
              isVisible: _isVisible,
              child: const Text(
                'Nice...........',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(padding: EdgeInsets.all(5)),
            BlurFade(
              delay: const Duration(milliseconds: 200),
              isVisible: _isVisible,
              child: const Text(
                'to...........',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(padding: EdgeInsets.all(5)),
            BlurFade(
              delay: const Duration(milliseconds: 300),
              isVisible: _isVisible,
              child: const Text(
                'meet...........',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(padding: EdgeInsets.all(5)),
            BlurFade(
              delay: const Duration(milliseconds: 400),
              isVisible: _isVisible,
              child: const Text(
                'you...........',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () => setState(() => _isVisible = !_isVisible),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(150, 50),
              ),
              child: Text(_isVisible ? 'Hide' : 'Show'),
            ),
          ],
        ),
      ),
    );
  }
}
