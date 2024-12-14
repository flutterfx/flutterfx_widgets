import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ScratchToReveal extends StatefulWidget {
  final Widget child;
  final double width;
  final double height;
  final double minScratchPercentage;
  final List<Color> gradientColors;
  final VoidCallback? onComplete;
  final bool enableHapticFeedback;
  final bool enableSoundEffects;

  const ScratchToReveal({
    Key? key,
    required this.child,
    required this.width,
    required this.height,
    this.minScratchPercentage = 50,
    this.gradientColors = const [
      Color(0xFFA97CF8),
      Color(0xFFF38CB8),
      Color(0xFFFDCC92),
    ],
    this.onComplete,
    this.enableHapticFeedback = true,
    this.enableSoundEffects = false,
  }) : super(key: key);

  @override
  State<ScratchToReveal> createState() => _ScratchToRevealState();
}

class _ScratchToRevealState extends State<ScratchToReveal>
    with SingleTickerProviderStateMixin {
  late ui.Image? _scratchImage;
  final _path = Path();
  bool _isComplete = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _createScratchImage();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.5), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.5, end: 1.0), weight: 1),
    ]).animate(_animationController);

    _rotationAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.1), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.1, end: -0.1), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -0.1, end: 0.0), weight: 1),
    ]).animate(_animationController);
  }

  Future<void> _createScratchImage() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()
      ..shader = ui.Gradient.linear(
        Offset.zero,
        Offset(widget.width, widget.height),
        widget.gradientColors,
        [0.0, 0.5, 1.0],
      );

    canvas.drawRect(
      Rect.fromLTWH(0, 0, widget.width, widget.height),
      paint,
    );

    final picture = recorder.endRecording();
    _scratchImage = await picture.toImage(
      widget.width.toInt(),
      widget.height.toInt(),
    );
    setState(() {});
  }

  void _handlePanDown(DragDownDetails details) {
    _path.moveTo(details.localPosition.dx, details.localPosition.dy);
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (widget.enableHapticFeedback) {
      HapticFeedback.selectionClick();
    }
    setState(() {
      _path.lineTo(details.localPosition.dx, details.localPosition.dy);
    });
    _checkCompletion();
  }

  void _checkCompletion() {
    if (_isComplete) return;

    final bounds = _path.getBounds();
    final totalArea = widget.width * widget.height;
    final scratchedArea = bounds.width * bounds.height;
    final percentage = (scratchedArea / totalArea) * 100;

    if (percentage >= widget.minScratchPercentage) {
      setState(() => _isComplete = true);
      _animationController.forward().then((_) {
        widget.onComplete?.call();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          widget.child,
          if (!_isComplete && _scratchImage != null)
            GestureDetector(
              onPanDown: _handlePanDown,
              onPanUpdate: _handlePanUpdate,
              child: CustomPaint(
                size: Size(widget.width, widget.height),
                painter: ScratchPainter(
                  scratchImage: _scratchImage!,
                  path: _path,
                ),
              ),
            ),
          if (_isComplete)
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Transform.rotate(
                    angle: _rotationAnimation.value,
                    child: widget.child,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class ScratchPainter extends CustomPainter {
  final ui.Image scratchImage;
  final Path path;

  ScratchPainter({
    required this.scratchImage,
    required this.path,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 60
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..blendMode = BlendMode.clear;

    canvas.saveLayer(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint(),
    );

    // Draw the gradient background image
    canvas.drawImage(scratchImage, Offset.zero, Paint());

    // Draw the scratch path
    canvas.drawPath(path, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant ScratchPainter oldDelegate) {
    return true; // Always repaint when path updates
  }
}

class ScratchToRevealDemo extends StatelessWidget {
  const ScratchToRevealDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScratchToReveal(
        width: 250,
        height: 250,
        minScratchPercentage: 70,
        onComplete: () {
          // Do something
        },
        child: const Center(
          child: Text(
            '😎',
            style: TextStyle(fontSize: 200),
          ),
        ),
      ),
    );
  }
}
