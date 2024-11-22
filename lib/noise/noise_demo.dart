import 'package:flutter/material.dart';
import 'package:fx_2_folder/noise/noise.dart';
import 'package:fx_2_folder/noise/strategy_noise.dart';

class PracticalNoiseShowcase extends StatefulWidget {
  const PracticalNoiseShowcase({super.key});

  @override
  State<PracticalNoiseShowcase> createState() => _PracticalNoiseShowcaseState();
}

class _PracticalNoiseShowcaseState extends State<PracticalNoiseShowcase> {
  NoiseType _selectedType = NoiseType.perlin;
  double _scale = 1.0;
  double _frequency = 0.1;
  double _opacity = 0.3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practical Noise Effects'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildControls(),
            _buildImageEffect(),
            _buildCardEffect(),
            _buildLoadingEffect(),
            _buildBackgroundEffect(),
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Noise Controls',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SegmentedButton<NoiseType>(
              segments: const [
                ButtonSegment(value: NoiseType.perlin, label: Text('Perlin')),
                ButtonSegment(value: NoiseType.value, label: Text('Value')),
                ButtonSegment(value: NoiseType.voronoi, label: Text('Voronoi')),
              ],
              selected: {_selectedType},
              onSelectionChanged: (Set<NoiseType> selection) {
                setState(() {
                  _selectedType = selection.first;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildSlider(
              'Scale',
              _scale,
              0.1,
              2.0,
              (value) => setState(() => _scale = value),
            ),
            _buildSlider(
              'Frequency',
              _frequency,
              0.01,
              0.2,
              (value) => setState(() => _frequency = value),
            ),
            _buildSlider(
              'Opacity',
              _opacity,
              0.0,
              1.0,
              (value) => setState(() => _opacity = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageEffect() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Image Texture Effect',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Stack(
            children: [
              Image.network(
                'https://picsum.photos/400/200',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              Positioned.fill(
                child: ClipRect(
                  child: NoiseVisualizer(
                    noiseStrategy: _getNoiseStrategy(),
                    scale: _scale,
                    frequency: _frequency,
                    opacity: _opacity,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Add texture and grain effects to images using noise overlays.',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardEffect() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Card Background Effect',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 150,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [Colors.blue[300]!, Colors.purple[300]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  NoiseVisualizer(
                    noiseStrategy: _getNoiseStrategy(),
                    scale: _scale,
                    frequency: _frequency,
                    opacity: _opacity,
                  ),
                  const Center(
                    child: Text(
                      'Premium Card',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Create premium-looking cards with noise-based texture effects.',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingEffect() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Loading Skeleton Effect',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 100,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  NoiseVisualizer(
                    noiseStrategy: _getNoiseStrategy(),
                    scale: _scale,
                    frequency: _frequency,
                    opacity: _opacity,
                  ),
                  const Center(
                    child: Text(
                      'Loading...',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Enhance loading skeletons with dynamic noise patterns.',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundEffect() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Animated Background',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 200,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [Colors.teal[300]!, Colors.blue[300]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  NoiseVisualizer(
                    noiseStrategy: _getNoiseStrategy(),
                    scale: _scale,
                    frequency: _frequency,
                    opacity: _opacity,
                  ),
                  const Center(
                    child: Text(
                      'Animated Background',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Create dynamic animated backgrounds using noise patterns.',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.toStringAsFixed(2)}'),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ],
    );
  }

  NoiseStrategy _getNoiseStrategy() {
    switch (_selectedType) {
      case NoiseType.perlin:
        return PerlinNoiseStrategy();
      case NoiseType.value:
        return ValueNoiseStrategy();
      case NoiseType.voronoi:
        return VoronoiNoiseStrategy();
    }
  }
}

enum NoiseType {
  perlin,
  value,
  voronoi,
}
