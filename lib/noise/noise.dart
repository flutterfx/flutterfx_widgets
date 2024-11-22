import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fx_2_folder/noise/strategy_noise.dart';

// Abstract Strategy Interface
abstract class NoiseStrategy {
  double noise2D(double x, double y);
  Color getColor(double value);
  String get name;
}

// Perlin Noise Implementation
class PerlinNoiseStrategy implements NoiseStrategy {
  final List<int> p = List.generate(512, (i) => 0);

  PerlinNoiseStrategy() {
    final List<int> permutation = [
      151,
      160,
      137,
      91,
      90,
      15,
      131,
      13,
      201,
      95,
      96,
      53,
      194,
      233,
      7,
      225,
      140,
      36,
      103,
      30,
      69,
      142,
      8,
      99,
      37,
      240,
      21,
      10,
      23,
      190,
      6,
      148,
      247,
      120,
      234,
      75,
      0,
      26,
      197,
      62,
      94,
      252,
      219,
      203,
      117,
      35,
      11,
      32,
      57,
      177,
      33,
      88,
      237,
      149,
      56,
      87,
      174,
      20,
      125,
      136,
      171,
      168,
      68,
      175,
      74,
      165,
      71,
      134,
      139,
      48,
      27,
      166,
      77,
      146,
      158,
      231,
      83,
      111,
      229,
      122,
      60,
      211,
      133,
      230,
      220,
      105,
      92,
      41,
      55,
      46,
      245,
      40,
      244,
      102,
      143,
      54,
      65,
      25,
      63,
      161,
      1,
      216,
      80,
      73,
      209,
      76,
      132,
      187,
      208,
      89,
      18,
      169,
      200,
      196,
      135,
      130,
      116,
      188,
      159,
      86,
      164,
      100,
      109,
      198,
      173,
      186,
      3,
      64,
      52,
      217,
      226,
      250,
      124,
      123,
      5,
      202,
      38,
      147,
      118,
      126,
      255,
      82,
      85,
      212,
      207,
      206,
      59,
      227,
      47,
      16,
      58,
      17,
      182,
      189,
      28,
      42,
      223,
      183,
      170,
      213,
      119,
      248,
      152,
      2,
      44,
      154,
      163,
      70,
      221,
      153,
      101,
      155,
      167,
      43,
      172,
      9,
      129,
      22,
      39,
      253,
      19,
      98,
      108,
      110,
      79,
      113,
      224,
      232,
      178,
      185,
      112,
      104,
      218,
      246,
      97,
      228,
      251,
      34,
      242,
      193,
      238,
      210,
      144,
      12,
      191,
      179,
      162,
      241,
      81,
      51,
      145,
      235,
      249,
      14,
      239,
      107,
      49,
      192,
      214,
      31,
      181,
      199,
      106,
      157,
      184,
      84,
      204,
      176,
      115,
      121,
      50,
      45,
      127,
      4,
      150,
      254,
      138,
      236,
      205,
      93,
      222,
      114,
      67,
      29,
      24,
      72,
      243,
      141,
      128,
      195,
      78,
      66,
      215,
      61,
      156,
      180
    ];

    for (int i = 0; i < 256; i++) {
      p[i] = permutation[i];
      p[256 + i] = permutation[i];
    }
  }

  @override
  String get name => 'Perlin Noise';

  @override
  double noise2D(double x, double y) {
    int X = x.floor() & 255;
    int Y = y.floor() & 255;

    x -= x.floor();
    y -= y.floor();

    double u = _fade(x);
    double v = _fade(y);

    int A = p[X] + Y;
    int AA = p[A];
    int AB = p[A + 1];
    int B = p[X + 1] + Y;
    int BA = p[B];
    int BB = p[B + 1];

    double result = _lerp(_lerp(_grad(p[AA], x, y), _grad(p[BA], x - 1, y), u),
        _lerp(_grad(p[AB], x, y - 1), _grad(p[BB], x - 1, y - 1), u), v);

    return (result + 1) / 2; // Normalize to 0-1
  }

  double _fade(double t) => t * t * t * (t * (t * 6 - 15) + 10);

  double _lerp(double a, double b, double t) => a + t * (b - a);

  double _grad(int hash, double x, double y) {
    int h = hash & 15;
    double u = h < 8 ? x : y;
    double v = h < 4
        ? y
        : h == 12 || h == 14
            ? x
            : 0;
    return ((h & 1) == 0 ? u : -u) + ((h & 2) == 0 ? v : -v);
  }

  @override
  Color getColor(double value) {
    int intensity = (value * 255).round();
    return Color.fromRGBO(intensity, intensity, intensity, 1);
  }
}

// Noise Visualization Widget
class NoiseVisualizer extends StatelessWidget {
  final NoiseStrategy noiseStrategy;
  final double scale;
  final double frequency;
  final double opacity;

  const NoiseVisualizer({
    super.key,
    required this.noiseStrategy,
    this.scale = 1.0,
    this.frequency = 0.05,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          noiseStrategy.name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomPaint(
            size: const Size(300, 300),
            painter: NoisePainter(
              noiseStrategy: noiseStrategy,
              scale: scale,
              frequency: frequency,
              opacity: opacity,
            ),
          ),
        ),
      ],
    );
  }
}

// Custom Painter for Noise Visualization
class NoisePainter extends CustomPainter {
  final NoiseStrategy noiseStrategy;
  final double scale;
  final double frequency;
  final double opacity;

  NoisePainter({
    required this.noiseStrategy,
    required this.scale,
    required this.frequency,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (int x = 0; x < size.width; x++) {
      for (int y = 0; y < size.height; y++) {
        double nx = x * frequency * scale;
        double ny = y * frequency * scale;

        double noiseValue = noiseStrategy.noise2D(nx, ny);
        paint.color = noiseStrategy.getColor(noiseValue);

        paint.color = paint.color.withOpacity(opacity);

        canvas.drawRect(
          Rect.fromLTWH(x.toDouble(), y.toDouble(), 1, 1),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(NoisePainter oldDelegate) =>
      oldDelegate.noiseStrategy != noiseStrategy ||
      oldDelegate.scale != scale ||
      oldDelegate.frequency != frequency;
}

class ValueNoiseStrategy implements NoiseStrategy {
  final math.Random _random = math.Random(42);
  final Map<String, double> _valueGrid = {};

  @override
  String get name => 'Value Noise';

  @override
  double noise2D(double x, double y) {
    // Get grid cell coordinates
    int x0 = x.floor();
    int y0 = y.floor();

    // Get relative coordinates within grid cell
    double sx = x - x0;
    double sy = y - y0;

    // Get random values for corners
    double v00 = _getGridValue(x0, y0);
    double v10 = _getGridValue(x0 + 1, y0);
    double v01 = _getGridValue(x0, y0 + 1);
    double v11 = _getGridValue(x0 + 1, y0 + 1);

    // Interpolate values
    double ix0 = _smoothstep(v00, v10, sx);
    double ix1 = _smoothstep(v01, v11, sx);
    return _smoothstep(ix0, ix1, sy);
  }

  double _getGridValue(int x, int y) {
    String key = '$x,$y';
    return _valueGrid.putIfAbsent(key, () => _random.nextDouble());
  }

  double _smoothstep(double a, double b, double t) {
    t = t * t * (3 - 2 * t); // Smoothstep interpolation
    return a + (b - a) * t;
  }

  @override
  Color getColor(double value) {
    // Create a more colorful visualization
    double hue = (value + 1) * 180; // Map [-1,1] to [0,360]
    return HSVColor.fromAHSV(1.0, hue, 0.8, 0.9).toColor();
  }
}

// Example Usage
class NoiseDemo extends StatelessWidget {
  const NoiseDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NoiseVisualizer(
                noiseStrategy: PerlinNoiseStrategy(),
                scale: 1.0,
                frequency: 0.05,
              ),
              const SizedBox(height: 20),
              // Add more noise visualizers with different strategies here
            ],
          ),
        ),
      ),
    );
  }
}

class NoiseGallery extends StatelessWidget {
  const NoiseGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            NoiseVisualizer(
              noiseStrategy: PerlinNoiseStrategy(),
              scale: 1.0,
              frequency: 0.05,
            ),
            const SizedBox(height: 20),
            NoiseVisualizer(
              noiseStrategy: ValueNoiseStrategy(),
              scale: 1.0,
              frequency: 0.1,
            ),
            const SizedBox(height: 20),
            NoiseVisualizer(
              noiseStrategy: VoronoiNoiseStrategy(),
              scale: 1.0,
              frequency: 0.1,
            ),
          ],
        ),
      ),
    );
  }
}
