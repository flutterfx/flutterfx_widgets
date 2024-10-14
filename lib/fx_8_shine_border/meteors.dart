import 'dart:math';
import 'package:flutter/material.dart';

class MeteorShower extends StatefulWidget {
  final Widget child;
  final int numberOfMeteors;
  final Duration duration;

  const MeteorShower({
    Key? key,
    required this.child,
    this.numberOfMeteors = 10,
    this.duration = const Duration(seconds: 10),
  }) : super(key: key);

  @override
  _MeteorShowerState createState() => _MeteorShowerState();
}

class _MeteorShowerState extends State<MeteorShower>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Meteor> _meteors;
  final double meteorAngle = pi / 4;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      final size = renderBox.size;
      _meteors = List.generate(
          widget.numberOfMeteors, (_) => Meteor(meteorAngle, size));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            widget.child,
            ...List.generate(widget.numberOfMeteors, (index) {
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final meteor = _meteors[index];
                  final progress = ((_controller.value - meteor.delay) % 1.0) /
                      meteor.duration;
                  if (progress < 0 || progress > 1) return SizedBox.shrink();

                  return Positioned(
                    left: meteor.startX +
                        (meteor.endX - meteor.startX) * progress,
                    top: meteor.startY +
                        (meteor.endY - meteor.startY) * progress,
                    child: Opacity(
                      opacity: (1 - progress) * 0.8,
                      child: Transform.rotate(
                        angle: 315 * (pi / 180),
                        child: CustomPaint(
                          size: Size(2, 20),
                          painter: MeteorPainter(),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ],
        );
      },
    );
  }
}

class MeteorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint trailPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.white, Colors.white.withOpacity(0)],
        end: Alignment.topCenter,
        begin: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), trailPaint);

    final Paint circlePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width / 2, size.height), 2, circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Meteor {
  final double startX;
  final double startY;
  late double endX;
  late double endY;
  final double delay;
  final double duration;

  Meteor(double angle, Size size)
      : startX = Random().nextDouble() * size.width / 2,
        startY = Random().nextDouble() * size.height / 4 - size.height / 4,
        delay = Random().nextDouble(),
        duration = 0.3 + Random().nextDouble() * 0.7 {
    var distance = size.height / 3;
    endX = startX + cos(angle) * distance;
    endY = startY + sin(angle) * distance;
  }
}
