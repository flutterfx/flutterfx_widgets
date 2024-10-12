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
          children: [
            BlurFade(
              // delay: const Duration(milliseconds: 0),
              duration: const Duration(milliseconds: 200),
              isVisible: _isVisible,
              child: const Text(
                'Hello, World! 👋',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            BlurFade(
              delay: const Duration(milliseconds: 100),
              duration: const Duration(milliseconds: 200),
              isVisible: _isVisible,
              child: const Text(
                'Nice to meet you',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => setState(() => _isVisible = !_isVisible),
              child: Text(_isVisible ? 'Hide' : 'Show'),
            ),
          ],
        ),
      ),
    );
  }
}

// class FadeBlurExample extends StatefulWidget {
//   @override
//   _FadeBlurExampleState createState() => _FadeBlurExampleState();
// }

// class _FadeBlurExampleState extends State<FadeBlurExample>
//     with TickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _opacityAnimation;
//   late Animation<double> _blurAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: Duration(milliseconds: 500),
//       vsync: this,
//     );

//     _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Interval(0.3, 1.0, curve: Curves.linear),
//       ),
//     );

//     _blurAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.0, 0.7, curve: Curves.linear),
//       ),
//     );

//     // _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _toggleVisibility() {
//     if (_controller.status == AnimationStatus.completed) {
//       _controller.reverse();
//     } else {
//       _controller.forward();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         alignment: Alignment.center,
//         children: [
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             bottom: 0,
//             child: AnimatedBuilder(
//               animation: _controller,
//               builder: (context, child) {
//                 return Center(
//                   child: Opacity(
//                     opacity: _opacityAnimation.value,
//                     child: ImageFiltered(
//                       imageFilter: ImageFilter.blur(
//                         sigmaX: _blurAnimation.value,
//                         sigmaY: _blurAnimation.value,
//                       ),
//                       child: Text(
//                         'Hello, World!',
//                         style: TextStyle(
//                             fontSize: 24, fontWeight: FontWeight.bold),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Positioned(
//               bottom: 30,
//               left: 0,
//               right: 0,
//               child: MaterialButton(
//                   onPressed: _toggleVisibility, child: Text("Animate!"))),
//         ],
//       ),
//     );
//   }
// }
