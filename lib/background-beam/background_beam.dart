// lib/background_beams.dart
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class BorderBeamsBackground extends StatelessWidget {
  final int numberOfSimultaneousBeams;
  const BorderBeamsBackground({
    super.key,
    this.numberOfSimultaneousBeams = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          BackgroundBeams(numberOfBeams: numberOfSimultaneousBeams),
          const SafeArea(
            child: Center(
              child: Text(
                'Hey!',
                style: TextStyle(color: Colors.white, fontSize: 34),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BeamAnimation {
  final int beamIndex;
  final AnimationController controller;
  final DateTime startTime;

  BeamAnimation({
    required this.beamIndex,
    required this.controller,
    required this.startTime,
  });
}

class BackgroundBeams extends StatefulWidget {
  final int numberOfBeams;

  const BackgroundBeams({
    Key? key,
    required this.numberOfBeams,
  }) : super(key: key);

  @override
  State<BackgroundBeams> createState() => _BackgroundBeamsState();
}

class _BackgroundBeamsState extends State<BackgroundBeams>
    with TickerProviderStateMixin {
  final List<BeamAnimation> _activeBeams = [];
  final Random random = Random();
  Timer? _spawnTimer;

  @override
  void initState() {
    super.initState();
    _startSpawning();
  }

  void _startSpawning() {
    // Initially spawn first beam
    _spawnBeam();

    // Set up timer to check and spawn new beams
    _spawnTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      _checkAndSpawnBeams();
    });
  }

  void _checkAndSpawnBeams() {
    // Remove completed animations
    _activeBeams.removeWhere((beam) => !beam.controller.isAnimating);

    // If we have room for more beams, spawn a new one with random delay
    if (_activeBeams.length < widget.numberOfBeams) {
      // Add random delay between 0-1000ms to prevent simultaneous starts
      Future.delayed(
        Duration(milliseconds: random.nextInt(1000)),
        _spawnBeam,
      );
    }
  }

  void _spawnBeam() {
    if (_activeBeams.length >= widget.numberOfBeams) return;

    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    final beamIndex = random.nextInt(25); // Total number of beam paths

    final beam = BeamAnimation(
      beamIndex: beamIndex,
      controller: controller,
      startTime: DateTime.now(),
    );

    setState(() {
      _activeBeams.add(beam);
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
        setState(() {
          _activeBeams.remove(beam);
        });
      }
    });

    controller.forward();
  }

  @override
  void dispose() {
    _spawnTimer?.cancel();
    for (var beam in _activeBeams) {
      beam.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: Listenable.merge(
              _activeBeams.map((beam) => beam.controller).toList(),
            ),
            builder: (context, child) {
              return CustomPaint(
                painter: BeamsPainter(
                  activeBeams: _activeBeams,
                ),
                size: Size.infinite,
              );
            },
          ),
        ],
      ),
    );
  }
}

class BeamsPainter extends CustomPainter {
  final List<BeamAnimation> activeBeams;

  BeamsPainter({
    required this.activeBeams,
  });

  List<Path> getBeamPaths(Size size) {
    const numberOfBeams = 35;
    const beamPadding = 50.0;

    // Add extra width padding to ensure coverage on edges
    final extraWidth = size.width * 0.1; // 10% extra width on each side
    final totalWidth = size.width + (extraWidth * 2);
    final availableHeight = size.height - (beamPadding * 2);

    // Calculate spacing using expanded width
    final double spacing = totalWidth / (numberOfBeams - 1);

    return List.generate(numberOfBeams, (index) {
      // Shift startX left by extraWidth to start before viewport
      final startX = (spacing * index) - extraWidth;
      final path = Path();

      path.moveTo(startX, -beamPadding);

      final horizontalOffset = size.width * 0.3;

      path.cubicTo(
          startX + horizontalOffset,
          availableHeight * 0.3 + beamPadding,
          startX - horizontalOffset,
          availableHeight * 0.7 + beamPadding,
          startX,
          size.height + beamPadding);

      return path;
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    final beamPaths = getBeamPaths(size);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // Draw base paths with lower opacity
    paint.shader = ui.Gradient.linear(
      const Offset(0, 0),
      Offset(size.width, size.height),
      [
        Colors.grey.withOpacity(0.25),
        Colors.grey.withOpacity(0.25),
      ],
    );

    for (var path in beamPaths) {
      canvas.drawPath(path, paint);
    }

    // Draw each active beam
    for (var beam in activeBeams) {
      final selectedPath = beamPaths[beam.beamIndex];
      final pathMetrics = selectedPath.computeMetrics().single;
      final pathLength = pathMetrics.length;

      final start = beam.controller.value * pathLength;
      final end = (start + pathLength / 10) % pathLength;

      Path shootingStarPath;
      if (end > start) {
        shootingStarPath = pathMetrics.extractPath(start, end);
      } else {
        shootingStarPath = pathMetrics.extractPath(start, pathLength);
        shootingStarPath.addPath(pathMetrics.extractPath(0, end), Offset.zero);
      }

      final pathSegmentLength = pathLength / 10; // Add this line
      final gradientPosition = pathMetrics.getTangentForOffset(start);
      if (gradientPosition != null) {
        final gradientStart = gradientPosition.position;
        final gradientEnd = pathMetrics
                .getTangentForOffset(start + pathSegmentLength)
                ?.position ??
            gradientPosition.position;

        final shootingStarPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5
          ..shader = ui.Gradient.linear(
            gradientStart,
            gradientEnd,
            [
              const Color(0xFFAE48FF).withOpacity(0.0),
              const Color.fromARGB(255, 30, 8, 126),
              const Color.fromARGB(255, 31, 17, 95),
              const Color(0xFF18CCFC),
            ],
            [0.0, 0.2, 0.6, 1.0],
          );

        canvas.drawPath(shootingStarPath, shootingStarPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant BeamsPainter oldDelegate) {
    return true;

    // oldDelegate.progress != progress ||
    //     oldDelegate.currentBeamIndex != currentBeamIndex;
  }
}

class BeamPath {
  final double startX;
  final double startY;
  final double controlX;
  final double controlY;
  final double endX;
  final double endY;

  BeamPath({
    required this.startX,
    required this.startY,
    required this.controlX,
    required this.controlY,
    required this.endX,
    required this.endY,
  });
}
