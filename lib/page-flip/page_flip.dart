import 'package:flutter/material.dart';
import 'dart:math' as math;

class PageFlipDemo extends StatefulWidget {
  const PageFlipDemo({super.key});

  @override
  State<PageFlipDemo> createState() => _PageFlipDemoState();
}

class _PageFlipDemoState extends State<PageFlipDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int currentIndex = 0;
  bool isFlipping = false;
  bool isForward = true;

  // Sample pages - you can replace these with your content
  final List<Widget> pages = [
    Container(
        color: Colors.red,
        child: const Center(
            child: Text('Page 1',
                style: TextStyle(fontSize: 24, color: Colors.white)))),
    Container(
        color: Colors.blue,
        child: const Center(
            child: Text('Page 2',
                style: TextStyle(fontSize: 24, color: Colors.white)))),
    Container(
        color: Colors.green,
        child: const Center(
            child: Text('Page 3',
                style: TextStyle(fontSize: 24, color: Colors.white)))),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            if (isForward) {
              currentIndex = (currentIndex + 1) % pages.length;
            } else {
              currentIndex = (currentIndex - 1 + pages.length) % pages.length;
            }
            isFlipping = false;
          });
          _controller.reset();
        }
      });
  }

  void _nextPage() {
    if (!isFlipping && currentIndex < pages.length - 1) {
      setState(() {
        isFlipping = true;
        isForward = true;
      });
      _controller.forward();
    }
  }

  void _previousPage() {
    if (!isFlipping && currentIndex > 0) {
      setState(() {
        isFlipping = true;
        isForward = false;
      });
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                // Calculate rotation for current page (0 to pi)
                double frontRotation = isFlipping
                    ? (isForward ? _animation.value : -_animation.value) *
                        math.pi
                    : 0.0;

                // Calculate rotation for next page (pi to 0)
                double backRotation = isFlipping
                    ? (isForward
                        ? (-math.pi +
                            (_animation.value *
                                math.pi)) // Changed this line only
                        : (-math.pi + (_animation.value * math.pi)))
                    : math.pi;

                // Calculate next/previous page index
                int nextIndex = isForward
                    ? (currentIndex + 1) % pages.length
                    : (currentIndex - 1 + pages.length) % pages.length;

                return Stack(
                  children: [
                    // Next/Previous page (starts from backfacing)
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.002) // perspective
                        ..rotateY(isForward ? backRotation : -backRotation),
                      child: Visibility(
                        visible:
                            isFlipping && frontRotation.abs() > math.pi / 2,
                        child: pages[nextIndex],
                      ),
                    ),
                    // Current page (starts from front facing)
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.002) // perspective
                        ..rotateY(frontRotation),
                      child: Visibility(
                        visible:
                            !isFlipping || frontRotation.abs() <= math.pi / 2,
                        child: pages[currentIndex],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: currentIndex > 0 ? _previousPage : null,
                  child: const Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: currentIndex < pages.length - 1 ? _nextPage : null,
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
