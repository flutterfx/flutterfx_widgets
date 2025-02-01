import 'dart:math' as math;
import 'package:flutter/material.dart';

class FlickeringGrid extends StatefulWidget {
  final double squareSize;
  final double gridGap;
  final double flickerChance;
  final Color color;
  final double? width;
  final double? height;
  final double maxOpacity;

  const FlickeringGrid({
    super.key,
    this.squareSize = 4,
    this.gridGap = 6,
    this.flickerChance = 0.3,
    this.color = Colors.black,
    this.width,
    this.height,
    this.maxOpacity = 0.3,
  });

  @override
  State<FlickeringGrid> createState() => _FlickeringGridState();
}

class _FlickeringGridState extends State<FlickeringGrid>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<double> squares = [];
  Size? _size;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _controller.addListener(_updateSquares);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateSize(Size size) {
    if (_size != size) {
      _size = size;
      _initializeSquares();
    }
  }

  void _initializeSquares() {
    if (_size == null) return;

    final cols = (_size!.width / (widget.squareSize + widget.gridGap)).floor();
    final rows = (_size!.height / (widget.squareSize + widget.gridGap)).floor();

    squares = List.generate(
      cols * rows,
      (_) => _random.nextDouble() * widget.maxOpacity,
    );
  }

  void _updateSquares() {
    if (squares.isEmpty) return;

    const deltaTime = 1 / 60; // Assuming 60 FPS

    for (var i = 0; i < squares.length; i++) {
      if (_random.nextDouble() < widget.flickerChance * deltaTime) {
        squares[i] = _random.nextDouble() * widget.maxOpacity;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = widget.width ?? constraints.maxWidth;
        final height = widget.height ?? constraints.maxHeight;

        _updateSize(Size(width, height));

        return CustomPaint(
          size: Size(width, height),
          painter: _GridPainter(
            squares: squares,
            squareSize: widget.squareSize,
            gridGap: widget.gridGap,
            color: widget.color,
          ),
        );
      },
    );
  }
}

class _GridPainter extends CustomPainter {
  final List<double> squares;
  final double squareSize;
  final double gridGap;
  final Color color;

  _GridPainter({
    required this.squares,
    required this.squareSize,
    required this.gridGap,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cols = (size.width / (squareSize + gridGap)).floor();
    final rows = (size.height / (squareSize + gridGap)).floor();

    for (var i = 0; i < cols; i++) {
      for (var j = 0; j < rows; j++) {
        if (i * rows + j >= squares.length) continue;

        final opacity = squares[i * rows + j];
        final paint = Paint()
          ..color = color.withOpacity(opacity)
          ..style = PaintingStyle.fill;

        canvas.drawRect(
          Rect.fromLTWH(
            i * (squareSize + gridGap),
            j * (squareSize + gridGap),
            squareSize,
            squareSize,
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) {
    return true;
  }
}

class FlickeringGridDemo extends StatelessWidget {
  const FlickeringGridDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      color: Colors.black,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: const Stack(
          children: [
            // Positioned.fill(
            //   child: FlickeringGrid(
            //     squareSize: 4,
            //     gridGap: 6,
            //     color: Color(0xFF6B7280),
            //     maxOpacity: 0.5,
            //     flickerChance: 0.1,
            //   ),
            // ),
            Positioned.fill(child: FlickeringGridShowcase())
          ],
        ),
      ),
    );
  }
}

// FlickeringGrid Theme Showcase
class FlickeringGridThemes {
  // 0 A random color
  static const randomColor = FlickeringGridConfig(
    squareSize: 4,
    gridGap: 6,
    color: Color(0xFF6B7280), // Bright matrix green
    maxOpacity: 0.5,
    flickerChance: 0.1,
    description: 'Random chosen color',
  );

  // 1. Matrix Digital Rain
  static const matrixRain = FlickeringGridConfig(
    squareSize: 3,
    gridGap: 4,
    color: Color(0xFF00FF41), // Bright matrix green
    maxOpacity: 0.7,
    flickerChance: 0.15,
    description:
        'Inspired by The Matrix, creates a digital rain effect with rapid, bright flickers',
  );

  // 2. Gentle Starfield
  static const starfield = FlickeringGridConfig(
    squareSize: 2,
    gridGap: 12,
    color: Color(0xFFE1E1E1), // Soft white
    maxOpacity: 0.3,
    flickerChance: 0.05,
    description: 'Resembles a distant starfield, with subtle, sparse twinkling',
  );

  // 3. Cyber Network
  static const cyberNetwork = FlickeringGridConfig(
    squareSize: 6,
    gridGap: 8,
    color: Color(0xFF00FFFF), // Cyan
    maxOpacity: 0.4,
    flickerChance: 0.08,
    description:
        'Creates a cyber network feel with medium-sized nodes and moderate activity',
  );

  // 4. Neon Pulse
  static const neonPulse = FlickeringGridConfig(
    squareSize: 8,
    gridGap: 10,
    color: Color(0xFFFF00FF), // Magenta
    maxOpacity: 0.6,
    flickerChance: 0.12,
    description:
        'Bold, neon aesthetic with larger squares and pronounced flicking',
  );

  // 5. Subtle Fabric
  static const subtleFabric = FlickeringGridConfig(
    squareSize: 3,
    gridGap: 3,
    color: Color(0xFF808080), // Gray
    maxOpacity: 0.2,
    flickerChance: 0.03,
    description: 'Creates a subtle, fabric-like texture with minimal movement',
  );

  // 6. Data Stream
  static const dataStream = FlickeringGridConfig(
    squareSize: 4,
    gridGap: 2,
    color: Color(0xFF4A90E2), // Blue
    maxOpacity: 0.5,
    flickerChance: 0.2,
    description:
        'Simulates rapid data flow with closely packed squares and frequent updates',
  );

  // 7. Retro Gaming
  static const retroGaming = FlickeringGridConfig(
    squareSize: 10,
    gridGap: 4,
    color: Color(0xFFFFFF00), // Yellow
    maxOpacity: 0.8,
    flickerChance: 0.1,
    description:
        'Large, bold squares with high contrast for a retro gaming feel',
  );

  // 8. Ethereal Mist
  static const etherealMist = FlickeringGridConfig(
    squareSize: 5,
    gridGap: 15,
    color: Color(0xFFB4A7D6), // Soft purple
    maxOpacity: 0.3,
    flickerChance: 0.04,
    description:
        'Widely spaced, soft-colored squares create a misty, ethereal effect',
  );

  // 9. Circuit Board
  static const circuitBoard = FlickeringGridConfig(
    squareSize: 4,
    gridGap: 8,
    color: Color(0xFF50C878), // Emerald green
    maxOpacity: 0.5,
    flickerChance: 0.06,
    description:
        'Mimics a circuit board with moderate spacing and steady updates',
  );

  // 10. Rain Drops
  static const rainDrops = FlickeringGridConfig(
    squareSize: 3,
    gridGap: 20,
    color: Color(0xFF87CEEB), // Sky blue
    maxOpacity: 0.6,
    flickerChance: 0.15,
    description: 'Widely spaced small squares simulate rainfall patterns',
  );
}

// Configuration class to hold theme values
class FlickeringGridConfig {
  final double squareSize;
  final double gridGap;
  final Color color;
  final double maxOpacity;
  final double flickerChance;
  final String description;

  const FlickeringGridConfig({
    required this.squareSize,
    required this.gridGap,
    required this.color,
    required this.maxOpacity,
    required this.flickerChance,
    required this.description,
  });
}

class FullscreenFlickeringGrid extends StatelessWidget {
  final FlickeringGridConfig config;
  final String title;

  const FullscreenFlickeringGrid({
    super.key,
    required this.config,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: FlickeringGrid(
              squareSize: config.squareSize,
              gridGap: config.gridGap,
              color: config.color,
              maxOpacity: config.maxOpacity,
              flickerChance: config.flickerChance,
            ),
          ),
          Positioned(
            left: 16,
            bottom: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    config.description,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Square Size: ${config.squareSize}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    'Grid Gap: ${config.gridGap}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    'Max Opacity: ${config.maxOpacity}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    'Flicker Chance: ${config.flickerChance}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Update the ThemePreviewCard to handle taps
class ThemePreviewCard extends StatelessWidget {
  final String title;
  final FlickeringGridConfig config;

  const ThemePreviewCard({
    super.key,
    required this.title,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      margin: const EdgeInsets.all(4),
      child: InkWell(
        // Add this InkWell widget
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FullscreenFlickeringGrid(
                config: config,
                title: title,
              ),
            ),
          );
        },
        child: Column(
          children: [
            SizedBox(
              height: 183,
              child: FlickeringGrid(
                squareSize: config.squareSize,
                gridGap: config.gridGap,
                color: config.color,
                maxOpacity: config.maxOpacity,
                flickerChance: config.flickerChance,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Also fix the titles in the FlickeringGridShowcase
class FlickeringGridShowcase extends StatelessWidget {
  const FlickeringGridShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GridView.count(
        crossAxisCount: 2,
        children: const [
          ThemePreviewCard(
            title: 'Random Color',
            config: FlickeringGridThemes.randomColor,
          ),
          ThemePreviewCard(
            title: 'Matrix Digital Rain',
            config: FlickeringGridThemes.matrixRain,
          ),
          ThemePreviewCard(
            title: 'Gentle Starfield',
            config: FlickeringGridThemes.starfield,
          ),
          ThemePreviewCard(
            title: 'Cyber Network',
            config: FlickeringGridThemes.cyberNetwork,
          ),
          ThemePreviewCard(
            title: 'Neon Pulse',
            config: FlickeringGridThemes.neonPulse,
          ),
          ThemePreviewCard(
            title: 'Subtle Fabric',
            config: FlickeringGridThemes.subtleFabric,
          ),
          ThemePreviewCard(
            title: 'Data Stream',
            config: FlickeringGridThemes.dataStream,
          ),
          ThemePreviewCard(
            title: 'Retro Gaming',
            config: FlickeringGridThemes.retroGaming,
          ),
          ThemePreviewCard(
            title: 'Ethereal Mist',
            config: FlickeringGridThemes.etherealMist,
          ),
          ThemePreviewCard(
            title: 'Circuit Board',
            config: FlickeringGridThemes.circuitBoard,
          ),
          ThemePreviewCard(
            title: 'Rain Drops',
            config: FlickeringGridThemes.rainDrops,
          ),
        ],
      ),
    );
  }
}
