import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MotionBlurWidget extends StatefulWidget {
  final Widget child;
  final String shaderAsset;

  const MotionBlurWidget({
    Key? key,
    required this.child,
    required this.shaderAsset,
  }) : super(key: key);

  @override
  State<MotionBlurWidget> createState() => _MotionBlurWidgetState();
}

class _MotionBlurWidgetState extends State<MotionBlurWidget> {
  Offset _velocity = Offset.zero;
  double _lastUpdateTime = 0;
  bool _isDragging = false;
  ui.FragmentShader? shader;
  ui.Image? _childImage;
  final GlobalKey _childKey = GlobalKey();

  // Add position tracking
  Offset _position = Offset.zero;
  Offset _dragStartPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    _loadShader();
  }

  Future<void> _loadShader() async {
    try {
      final program = await ui.FragmentProgram.fromAsset(widget.shaderAsset);
      if (mounted) {
        setState(() {
          shader = program.fragmentShader();
        });
      }
      print('Shader loaded successfully!'); // Debug print
    } catch (e) {
      print('Error loading shader: $e');
      // Print more detailed error information
      print('Shader asset path: ${widget.shaderAsset}');
      print('Stack trace: ${StackTrace.current}');
    }
  }

  Future<void> _captureChildImage() async {
    try {
      final RenderRepaintBoundary? boundary = _childKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary != null && boundary.hasSize) {
        final ui.Image image = await boundary.toImage(
            pixelRatio: MediaQuery.of(context).devicePixelRatio);
        if (mounted) {
          setState(() {
            _childImage?.dispose();
            _childImage = image;
          });
        }
      }
    } catch (e) {
      print('Error capturing child image: $e');
    }
  }

  @override
  void dispose() {
    _childImage?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // Calculate bounds to keep the widget within the screen
      final maxX =
          constraints.maxWidth - 100; // 100 is the width of the container
      final maxY =
          constraints.maxHeight - 100; // 100 is the height of the container

      _position = Offset(
        _position.dx.clamp(0, maxX),
        _position.dy.clamp(0, maxY),
      );

      return Stack(
        children: [
          Positioned(
            left: _position.dx,
            top: _position.dy,
            child: GestureDetector(
              onPanStart: (details) async {
                setState(() {
                  _isDragging = true;
                  _lastUpdateTime =
                      DateTime.now().millisecondsSinceEpoch.toDouble();
                  _dragStartPosition = details.globalPosition - _position;
                });
                await _captureChildImage();
              },
              onPanUpdate: (details) {
                final now = DateTime.now().millisecondsSinceEpoch.toDouble();
                final dt = (now - _lastUpdateTime) / 1000.0;

                if (dt > 0) {
                  setState(() {
                    // More aggressive velocity calculation for pronounced motion blur
                    _velocity =
                        (details.delta / dt) * 3.5; // Increased amplification

                    // Only show blur for significant movement
                    if (_velocity.distance < 150) {
                      _velocity = Offset.zero;
                    }

                    _lastUpdateTime = now;

                    // Update position based on drag
                    final newPosition =
                        details.globalPosition - _dragStartPosition;
                    _position = Offset(
                      newPosition.dx.clamp(0, maxX),
                      newPosition.dy.clamp(0, maxY),
                    );
                  });
                }
              },
              onPanEnd: (details) {
                setState(() {
                  _isDragging = false;
                  _velocity = Offset.zero;
                  _childImage?.dispose();
                  _childImage = null;
                });
              },
              child: Stack(
                children: [
                  // Original child in RepaintBoundary for capture
                  RepaintBoundary(
                    key: _childKey,
                    child: widget.child,
                  ),

                  // Shader overlay when dragging
                  if (_isDragging && shader != null && _childImage != null)
                    if (_isDragging && shader != null && _childImage != null)
                      Positioned.fill(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            print(
                                'Applying shader with velocity: ${_velocity.distance}'); // Debug print
                            return CustomPaint(
                              size: Size(
                                  constraints.maxWidth, constraints.maxHeight),
                              painter: ShaderPainter(
                                shader: shader!,
                                strength: (_velocity.distance / 200.0)
                                    .clamp(0.0, 0.95),
                                angle: _velocity != Offset.zero
                                    ? math.atan2(_velocity.dy, _velocity.dx)
                                    : 0.0,
                                image: _childImage!,
                              ),
                            );
                          },
                        ),
                      ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}

class ShaderPainter extends CustomPainter {
  final ui.FragmentShader shader;
  final double strength;
  final double angle;
  final ui.Image image;

  ShaderPainter({
    required this.shader,
    required this.strength,
    required this.angle,
    required this.image,
  });

  @override
  void paint(Canvas canvas, Size size) {
    try {
      print(
          'Painting with shader - Size: $size, Strength: $strength, Angle: $angle'); // Debug print

      shader
        ..setFloat(0, size.width)
        ..setFloat(1, size.height)
        ..setFloat(2, strength)
        ..setFloat(3, angle)
        ..setImageSampler(0, image);

      // Draw the shader effect
      canvas.drawRect(
        Offset.zero & size,
        Paint()..shader = shader,
      );

      print('Shader painted successfully'); // Debug print
    } catch (e) {
      print('Error painting shader: $e');
      print('Stack trace: ${StackTrace.current}');
    }
  }

  @override
  bool shouldRepaint(covariant ShaderPainter oldDelegate) {
    return oldDelegate.strength != strength ||
        oldDelegate.angle != angle ||
        oldDelegate.image != image;
  }
}

class ExampleScreen extends StatefulWidget {
  @override
  _ExampleScreenState createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen>
    with TickerProviderStateMixin {
  late AnimationController _demoController;
  bool _showAutomatedDemo = false;

  @override
  void initState() {
    super.initState();
    _demoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _demoController.dispose();
    super.dispose();
  }

  void _startDemoAnimation() {
    _demoController.reset();
    _demoController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                MotionBlurWidget(
                  shaderAsset: 'shaders/motion_blur.frag',
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Control Panel
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'The motion blur effect is created using multiple semi-transparent copies '
                  'that trail behind the object. The trail length and opacity are '
                  'determined by the movement speed.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _showAutomatedDemo = false;
                        });
                      },
                      icon: const Icon(Icons.touch_app),
                      label: const Text('Interactive'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            !_showAutomatedDemo ? Colors.blue : Colors.grey,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _startDemoAnimation,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Auto Demo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Main App
class MotionBlurDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motion Blur Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: ExampleScreen(),
    );
  }
}
