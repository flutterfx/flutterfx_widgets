import 'package:flutter/material.dart';
import 'dart:math' as math;

class TransformDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('3D Transform Variations'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1.0,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: 100,
        itemBuilder: (context, index) {
          return TransformedSquare(index: index);
        },
      ),
    );
  }
}

class TransformedSquare extends StatelessWidget {
  final int index;

  TransformedSquare({required this.index});

  Widget build(BuildContext context) {
    late Matrix4 transform;

    switch (index % 4) {
      // case 0: // Above left
      //   transform = Matrix4.identity()
      //     ..translate(-50.0, -50.0, 0.0)
      //     ..rotateX(-0.3)
      //     ..rotateY(0.3);
      //   break;
      // case 1: // Above right
      //   transform = Matrix4.identity()
      //     ..translate(50.0, -50.0, 0.0)
      //     ..rotateX(-0.3)
      //     ..rotateY(-0.3);
      //   break;
      // case 2: // Below left
      //   transform = Matrix4.identity()
      //     ..translate(-50.0, 50.0, 0.0)
      //     ..rotateX(0.3)
      //     ..rotateY(0.3);
      //   break;
      // case 3: // Below right
      //   transform = Matrix4.identity()
      //     ..translate(50.0, 50.0, 0.0)
      //     ..rotateX(0.3)
      //     ..rotateY(-0.3);
      //   break;
      default:
        transform = Matrix4.identity()
          ..translate(50.0, -50.0, 0.0)
          ..rotateX(-0.3)
          ..rotateY(-0.3);
        break;
    }

    return Transform(
        transform: transform,
        alignment: FractionalOffset.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 400,
              width: double.infinity,
              child: Image.asset(
                "assets/images/tracing_cards.png",
                fit: BoxFit.fitHeight,
              ),
            ),
            Container(
              width: 100,
              height: 180,
              color: Colors.blue.withOpacity(0.5),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ));
  }
  // @override
  // Widget build(BuildContext context) {
  //   final random = math.Random(index);

  //   final perspective = 0.001 * random.nextDouble();
  //   final rotateX = random.nextDouble() * math.pi;
  //   final rotateY = random.nextDouble() * math.pi;
  //   final rotateZ = random.nextDouble() * math.pi;
  //   final translateX = 50.0 * (random.nextDouble() - 0.5);
  //   final translateY = 50.0 * (random.nextDouble() - 0.5);
  //   final translateZ = 50.0 * (random.nextDouble() - 0.5);
  //   final zoom = 0.5 + random.nextDouble();

  //   return Transform(
  //     transform: Matrix4.identity()
  //       ..setEntry(3, 2, perspective)
  //       ..rotateX(rotateX)
  //       ..rotateY(rotateY)
  //       ..rotateZ(rotateZ)
  //       ..translate(translateX, translateY, translateZ)
  //       ..scale(zoom),
  //     alignment: FractionalOffset.center,
  //     child: Container(
  //       color: Colors.blue.withOpacity(0.5),
  //       child: Center(
  //         child: Text(
  //           '${index + 1}',
  //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
