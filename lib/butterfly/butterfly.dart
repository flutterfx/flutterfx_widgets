import 'dart:math';

import 'package:flutter/material.dart';

class FlutterButterfly extends StatelessWidget {
  const FlutterButterfly({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        height: 200,
        // color: Colors.grey.withOpacity(0.2), // Uncomment to see container bounds
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Left Wing
            Positioned(
              left: 50,
              child: Transform(
                alignment: Alignment.centerRight,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // perspective
                  ..rotateY(0.3) // rotation around Y axis
                  ..rotateZ(-0.2), // slight tilt
                child: getFlutterLogo(true),
              ),
            ),
            // Right Wing
            Positioned(
              right: 50,
              child: Transform(
                alignment: Alignment.centerLeft,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // perspective
                  ..rotateY(-0.3) // opposite rotation for right wing
                  ..rotateZ(0.2), // opposite tilt
                child: getFlutterLogo(false),
              ),
            ),
            // Body (optional - uncomment to add a body)

            Positioned(
              child: Container(
                width: 10,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white38,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget getFlutterLogo(bool isMirrored) {
  if (isMirrored) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(pi), // Rotate around Y axis by 180 degrees
      child: FlutterLogo(size: 100),
    );
  } else {
    return const FlutterLogo(size: 100);
  }
}

// Alternative version with different wing positions
class FlutterButterflyV2 extends StatelessWidget {
  const FlutterButterflyV2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        height: 200,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Left Wing - More upright position
            Positioned(
              left: 40,
              child: Transform(
                alignment: Alignment.centerRight,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.002)
                  ..rotateY(0.5)
                  ..rotateZ(-0.4)
                  ..rotateX(0.2),
                child: const FlutterLogo(size: 120),
              ),
            ),
            // Right Wing - More upright position
            Positioned(
              right: 40,
              child: Transform(
                alignment: Alignment.centerLeft,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.002)
                  ..rotateY(-0.5)
                  ..rotateZ(0.4)
                  ..rotateX(0.2),
                child: const FlutterLogo(size: 120),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Version 3 with more dramatic wing spread
class FlutterButterflyV3 extends StatelessWidget {
  const FlutterButterflyV3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        height: 250,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Left Wing - Wide spread
            Positioned(
              left: 30,
              child: Transform(
                alignment: Alignment.centerRight,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(0.7)
                  ..rotateZ(-0.1)
                  ..rotateX(0.1),
                child: const FlutterLogo(size: 150),
              ),
            ),
            // Right Wing - Wide spread
            Positioned(
              right: 30,
              child: Transform(
                alignment: Alignment.centerLeft,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(-0.7)
                  ..rotateZ(0.1)
                  ..rotateX(0.1),
                child: const FlutterLogo(size: 150),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
