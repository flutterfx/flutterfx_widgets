import 'package:flutter/material.dart';
import 'dart:math' as math;

class Stacked3DCardsLayout extends StatelessWidget {
  const Stacked3DCardsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Transform(
          transform: Matrix4.identity()
            // ..setEntry(3, 2, 0.001) // perspective
            ..rotateY(0.1)
            ..rotateX(0.1),
          alignment: Alignment.center,
          child: Stack(
            children: [
              _buildCard(80, 120, -80, Colors.yellow),
              _buildCard(80, 120, -40, Colors.green),
              _buildCard(80, 120, 0, Colors.blue),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardStack(Size size, double? top, double? bottom, double? left,
      double? right, double rotateY, double rotateX) {
    return Positioned(
      top: top != null ? size.height * top : null,
      bottom: bottom != null ? size.height * bottom : null,
      left: left != null ? size.width * left : null,
      right: right != null ? size.width * right : null,
      child: Transform(
        transform: Matrix4.identity()
          // ..setEntry(3, 2, 0.001) // perspective
          ..rotateY(rotateY)
          ..rotateX(rotateX),
        alignment: Alignment.center,
        child: Stack(
          children: [
            _buildCard(80, 120, -80, Colors.yellow),
            _buildCard(80, 120, -40, Colors.green),
            _buildCard(80, 120, 0, Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(double width, double height, double zOffset, Color color) {
    return Transform(
      transform: Matrix4.identity()..translate(0.0, 0.0, zOffset),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
      ),
    );
  }
}
