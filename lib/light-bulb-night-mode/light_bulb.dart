import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:fx_2_folder/light-bulb-night-mode/vintage_lightbulb.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDarkMode = true;

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}

class ThemeLightBulb extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool initialState;

  const ThemeLightBulb({
    Key? key,
    required this.onThemeChanged,
    this.initialState = true,
  }) : super(key: key);

  @override
  State<ThemeLightBulb> createState() => _ThemeLightBulbState();
}

class _ThemeLightBulbState extends State<ThemeLightBulb>
    with SingleTickerProviderStateMixin {
  bool isOn = false;
  late AnimationController _controller;
  late Animation<double> _pullAnimation;
  Offset? _dragStart;
  final double _dragThreshold = 30.0;

  @override
  void initState() {
    super.initState();
    isOn = !widget.initialState;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _pullAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    _dragStart = details.globalPosition;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_dragStart == null) return;

    final distance = (details.globalPosition - _dragStart!).distance;
    final progress = (distance / _dragThreshold).clamp(0.0, 1.0);
    _controller.value = progress;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_dragStart == null) return;

    final distance = (_controller.value * _dragThreshold);
    if (distance >= _dragThreshold * 0.5) {
      _controller.forward().then((_) {
        setState(() {
          isOn = !isOn;
          widget.onThemeChanged(isOn);
          _controller.reset();
        });
      });
    } else {
      _controller.reverse();
    }
    _dragStart = null;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 40, right: 20),
        child: SizedBox(
          width: 60,
          height: 120,
          child: GestureDetector(
            onVerticalDragStart: _handleDragStart,
            onVerticalDragUpdate: _handleDragUpdate,
            onVerticalDragEnd: _handleDragEnd,
            child: Stack(
              children: [
                CustomPaint(
                  size: const Size(60, 120),
                  painter: LightBulbPainter(
                    isOn: isOn,
                    pullProgress: _pullAnimation.value,
                  ),
                ),
                LightbulbIcon(
                  size: 60,
                  color: isOn
                      ? const Color.fromARGB(255, 255, 230, 0)
                      : const Color(0xFF757575),
                  strokeWidth: 2,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LightBulbPainter extends CustomPainter {
  final bool isOn;
  final double pullProgress;

  LightBulbPainter({
    required this.isOn,
    required this.pullProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw cord
    _drawCord(canvas, size, paint);

    // Draw filament
    if (isOn) {
      _drawFilament(canvas, size, paint);
    }
  }

  void _drawCord(Canvas canvas, Size size, Paint paint) {
    paint.color = const Color(0xFF424242);
    paint.style = PaintingStyle.stroke;

    final start = Offset(size.width / 2, size.height * 0.35);
    final end = Offset(
      size.width / 2,
      size.height * (0.7 + pullProgress * 0.2),
    );

    final controlPoint1 = Offset(
      start.dx + (10 * math.sin(pullProgress * math.pi)),
      start.dy + (size.height * 0.15),
    );
    final controlPoint2 = Offset(
      end.dx - (10 * math.sin(pullProgress * math.pi)),
      end.dy - (size.height * 0.15),
    );

    final cordPath = Path()
      ..moveTo(start.dx, start.dy)
      ..cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        end.dx,
        end.dy,
      );

    canvas.drawPath(cordPath, paint);

    // Draw pull handle
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(end, 5, paint);
  }

  void _drawFilament(Canvas canvas, Size size, Paint paint) {
    paint.color = const Color(0xFFFFEB3B);
    paint.strokeWidth = 1.5;
    paint.style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height * 0.25);
    final filamentRadius = size.width * 0.2;

    final filamentPath = Path()
      ..moveTo(center.dx - filamentRadius * 0.5, center.dy)
      ..cubicTo(
        center.dx - filamentRadius * 0.3,
        center.dy - filamentRadius * 0.5,
        center.dx + filamentRadius * 0.3,
        center.dy - filamentRadius * 0.5,
        center.dx + filamentRadius * 0.5,
        center.dy,
      );

    canvas.drawPath(filamentPath, paint);
  }

  @override
  bool shouldRepaint(covariant LightBulbPainter oldDelegate) {
    return oldDelegate.isOn != isOn || oldDelegate.pullProgress != pullProgress;
  }
}
