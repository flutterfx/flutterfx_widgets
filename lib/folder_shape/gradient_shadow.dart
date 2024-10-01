import 'package:flutter/material.dart';

class FolderBackCoverGradientPainter extends CustomPainter {
  final Animation<double> animation;
  FolderBackCoverGradientPainter(this.animation) : super(repaint: animation);
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();

    path.lineTo(0, size.height * 0.08);
    path.cubicTo(
        0, size.height * 0.03, size.width * 0.02, 0, size.width * 0.06, 0);
    path.cubicTo(
        size.width * 0.06, 0, size.width * 0.17, 0, size.width * 0.17, 0);
    path.cubicTo(
        size.width * 0.17, 0, size.width * 0.29, 0, size.width * 0.29, 0);
    path.cubicTo(size.width * 0.31, 0, size.width / 3, size.height * 0.01,
        size.width * 0.34, size.height * 0.03);
    path.cubicTo(size.width * 0.34, size.height * 0.03, size.width * 0.4,
        size.height * 0.17, size.width * 0.4, size.height * 0.17);
    path.cubicTo(size.width * 0.41, size.height * 0.19, size.width * 0.43,
        size.height / 5, size.width * 0.45, size.height / 5);
    path.cubicTo(size.width * 0.45, size.height / 5, size.width * 0.57,
        size.height / 5, size.width * 0.57, size.height / 5);
    path.cubicTo(size.width * 0.57, size.height / 5, size.width * 0.75,
        size.height / 5, size.width * 0.75, size.height / 5);
    path.cubicTo(size.width * 0.75, size.height / 5, size.width * 0.94,
        size.height / 5, size.width * 0.94, size.height / 5);
    path.cubicTo(size.width * 0.98, size.height / 5, size.width,
        size.height * 0.24, size.width, size.height * 0.28);
    path.cubicTo(size.width, size.height * 0.28, size.width, size.height * 0.92,
        size.width, size.height * 0.92);
    path.cubicTo(size.width, size.height * 0.97, size.width * 0.98, size.height,
        size.width * 0.94, size.height);
    path.cubicTo(size.width * 0.94, size.height, size.width * 0.06, size.height,
        size.width * 0.06, size.height);
    path.cubicTo(size.width * 0.02, size.height, 0, size.height * 0.97, 0,
        size.height * 0.92);
    path.cubicTo(
        0, size.height * 0.92, 0, size.height * 0.6, 0, size.height * 0.6);
    path.cubicTo(
        0, size.height * 0.6, 0, size.height * 0.41, 0, size.height * 0.41);
    path.cubicTo(0, size.height * 0.41, 0, size.height / 5, 0, size.height / 5);
    path.cubicTo(
        0, size.height / 5, 0, size.height * 0.08, 0, size.height * 0.08);
    path.cubicTo(
        0, size.height * 0.08, 0, size.height * 0.08, 0, size.height * 0.08);

    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment(-0.8, 1),
      stops: [0.0, 0.4 + 0.4 * animation.value], //from .4 to .8
      colors: [
        Colors.transparent,
        Colors.black.withOpacity(.7),
      ],
    );

    Paint paint = Paint()..shader = gradient.createShader(path.getBounds());
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class SVGPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    final Path path = Path();

    // Normalize coordinates
    final double scaleX = size.width / 1080;
    final double scaleY = size.height / 1080;
    final double scale = scaleX < scaleY ? scaleX : scaleY;

    // Transform and scale the canvas
    canvas.translate(size.width * .1, size.height * .1);
    canvas.scale(scale * 12.31);

    // Draw the path
    path.moveTo(0, 10.6616);
    path.cubicTo(3.90088, 12.9416, 8.95617, 15.8621, 12.8524, 18.1541);
    path.cubicTo(17.5784, 20.9341, 22.7708, 24.0116, 27.605, 26.8484);
    path.cubicTo(27.5755, 26.6435, 27.5704, 26.6075, 27.5498, 26.4642);
    path.cubicTo(27.18, 23.8889, 26.8101, 21.3137, 26.4403, 18.7384);
    path.cubicTo(26.4094, 18.5237, 26.3836, 18.3437, 26.3577, 18.1637);
    path.cubicTo(33.1158, 23.5418, 40.6326, 29.5263, 47.3906, 34.9044);
    path.cubicTo(47.2732, 34.9845, 47.508, 34.8243, 47.3906, 34.9044);
    path.cubicTo(47.0196, 32.3213, 46.5572, 28.6123, 46.1862, 26.0292);
    path.cubicTo(57.4306, 36.1862, 71.4346, 48.7877, 82.679, 58.9447);
    path.cubicTo(82.7455, 58.8168, 82.6125, 59.0727, 82.679, 58.9447);
    path.cubicTo(73.6361, 52.9921, 61.7472, 45.1035, 52.7043, 39.1509);
    path.cubicTo(52.7233, 39.2828, 52.7491, 39.4628, 52.7717, 39.6199);
    path.cubicTo(53.1268, 42.0927, 53.482, 44.5655, 53.8371, 47.0384);
    path.cubicTo(53.8607, 47.2031, 53.8933, 47.4299, 53.9116, 47.5571);
    path.cubicTo(47.5775, 42.5648, 40.5147, 37.0975, 34.1806, 32.1052);
    path.cubicTo(34.2772, 32.0467, 34.084, 32.1637, 34.1806, 32.1052);
    path.cubicTo(34.5829, 34.9068, 35.1483, 38.844, 35.5507, 41.6456);
    path.cubicTo(35.6424, 41.5881, 35.4589, 41.7032, 35.5507, 41.6456);
    path.cubicTo(35.1997, 41.4099, 34.4457, 40.6258, 34.1216, 40.345);
    path.cubicTo(26.5458, 33.783, 18.9734, 27.2155, 11.4052, 20.6408);
    path.cubicTo(7.9682, 17.655, 3.44476, 13.774, 0, 10.6616);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class LightningClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Calculate scale factors to fit the path within the given size
    const double originalWidth =
        82.679; // Approximate width of the original path
    const double originalHeight =
        48.2831; // Approximate height of the original path
    final double scaleX = size.width / originalWidth;
    final double scaleY = size.height / originalHeight;
    final double scale = (scaleX < scaleY ? scaleX : scaleY) * .6;

    // Calculate the scaled width and height of the path
    final double scaledWidth = originalWidth * scale;
    final double scaledHeight = originalHeight * scale;

    // Calculate the offset to center the path
    final double offsetX = (size.width - scaledWidth) / 2;
    final double offsetY = (size.height - scaledHeight) / 2;

    // Apply scaling transform
    final Matrix4 matrix = Matrix4.identity()
      ..scale(scale, scale)
      ..translate(offsetX / scale, offsetY / scale);

    path.moveTo(0, 10.6616);
    path.cubicTo(3.90088, 12.9416, 8.95617, 15.8621, 12.8524, 18.1541);
    path.cubicTo(17.5784, 20.9341, 22.7708, 24.0116, 27.605, 26.8484);
    path.cubicTo(27.5755, 26.6435, 27.5704, 26.6075, 27.5498, 26.4642);
    path.cubicTo(27.18, 23.8889, 26.8101, 21.3137, 26.4403, 18.7384);
    path.cubicTo(26.4094, 18.5237, 26.3836, 18.3437, 26.3577, 18.1637);
    path.cubicTo(33.1158, 23.5418, 40.6326, 29.5263, 47.3906, 34.9044);
    path.cubicTo(47.2732, 34.9845, 47.508, 34.8243, 47.3906, 34.9044);
    path.cubicTo(47.0196, 32.3213, 46.5572, 28.6123, 46.1862, 26.0292);
    path.cubicTo(57.4306, 36.1862, 71.4346, 48.7877, 82.679, 58.9447);
    path.cubicTo(82.7455, 58.8168, 82.6125, 59.0727, 82.679, 58.9447);
    path.cubicTo(73.6361, 52.9921, 61.7472, 45.1035, 52.7043, 39.1509);
    path.cubicTo(52.7233, 39.2828, 52.7491, 39.4628, 52.7717, 39.6199);
    path.cubicTo(53.1268, 42.0927, 53.482, 44.5655, 53.8371, 47.0384);
    path.cubicTo(53.8607, 47.2031, 53.8933, 47.4299, 53.9116, 47.5571);
    path.cubicTo(47.5775, 42.5648, 40.5147, 37.0975, 34.1806, 32.1052);
    path.cubicTo(34.2772, 32.0467, 34.084, 32.1637, 34.1806, 32.1052);
    path.cubicTo(34.5829, 34.9068, 35.1483, 38.844, 35.5507, 41.6456);
    path.cubicTo(35.6424, 41.5881, 35.4589, 41.7032, 35.5507, 41.6456);
    path.cubicTo(35.1997, 41.4099, 34.4457, 40.6258, 34.1216, 40.345);
    path.cubicTo(26.5458, 33.783, 18.9734, 27.2155, 11.4052, 20.6408);
    path.cubicTo(7.9682, 17.655, 3.44476, 13.774, 0, 10.6616);
    path.close();

    // Apply the scaling transform to the path
    return path.transform(matrix.storage);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class BigCirclePainter extends CustomPainter {
  final Animation<double> animation;
  final Animation<double> shadowAnimation;

  final Color bgLightiningColor = const Color.fromARGB(255, 112, 112, 112);
  final Color bgLightiningColorShine = const Color.fromARGB(255, 188, 188, 188);
  BigCirclePainter(this.animation, this.shadowAnimation)
      : super(repaint: Listenable.merge([animation, shadowAnimation]));

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawRect(Offset.zero & size, backgroundPaint);

    final Paint paint = Paint()
      ..color = Color.lerp(
          bgLightiningColor, bgLightiningColorShine, animation.value)!
      ..style = PaintingStyle.fill;

    // Calculate the center of the canvas
    final offsetX = size.width - (size.width / 4 * animation.value);
    final offsetY = size.height - (size.height / 4 * animation.value);
    final Offset center = Offset(offsetX, offsetY);

    final double radius = size.width * .65;

    // Draw the circle
    canvas.drawCircle(center, radius, paint);

    // Draw rect from size
    // final verticalOffset = (size.height) * animation.value;

    canvas.save();
    // Use the custom easing function
    // final easedValue = customEase(animation.value);
    final verticalOffset = size.height * 1.0 * (1 - shadowAnimation.value);
    canvas.translate(0, -verticalOffset);

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final path = Path();
    path.addRect(rect);

    const gradient = LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomRight,
      stops: [0.0, .8], //from .4 to .8 animation.value]
      colors: [
        Colors.transparent,
        Colors.black,
      ],
    );

    Paint gradientPaint = Paint()
      ..shader = gradient.createShader(path.getBounds());

    canvas.drawPath(path, gradientPaint);
    // Restore the canvas to its original state
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ReflectionWidget extends StatelessWidget {
  final Animation<double> animation;
  final Animation<double> shadowAnimation;

  ReflectionWidget(this.animation, this.shadowAnimation);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
        ),
        CustomPaint(
          painter: BigCirclePainter(animation, shadowAnimation),
          child: Container(
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ],
    );
  }
}
