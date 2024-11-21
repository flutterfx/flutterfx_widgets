import 'package:flutter/material.dart';
import 'package:fx_2_folder/butterfly-interactive/butterfly_interactive.dart';
import 'package:fx_2_folder/butterfly-interactive/design/grid.dart';

class ButterflyInteractiveDemo extends StatefulWidget {
  const ButterflyInteractiveDemo({Key? key}) : super(key: key);

  @override
  State<ButterflyInteractiveDemo> createState() =>
      _ButterflyInteractiveDemoState();
}

class _ButterflyInteractiveDemoState extends State<ButterflyInteractiveDemo> {
  static const double _minButterflies = 1;
  static const double _maxButterflies = 50;
  static const double _initialCount = 3;

  double _butterflyCount = _initialCount;
  // Add a key counter to force refresh
  int _keyCounter = 0;

  void _updateButterflyCount(double value) {
    setState(() {
      _butterflyCount = value;
      // Increment key counter to force rebuild
      _keyCounter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildGridBackground(),
          _buildButterflySwarm(),
          _buildSliderControl(context),
        ],
      ),
    );
  }

  Widget _buildGridBackground() {
    return CustomPaint(
      painter: GridPatternPainter(isDarkMode: true),
      size: Size.infinite,
    );
  }

  Widget _buildButterflySwarm() {
    // Use ValueKey with counter to force rebuild
    return KeyedSubtree(
      key: ValueKey('butterfly_swarm_$_keyCounter'),
      child: ButterflySwarm(
        numberOfButterflies: _butterflyCount.round(),
      ),
    );
  }

  Widget _buildSliderControl(BuildContext context) {
    return Positioned(
      left: 20,
      right: 20,
      bottom: MediaQuery.of(context).padding.bottom + 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCountDisplay(),
          const SizedBox(height: 8),
          _buildCustomSlider(),
        ],
      ),
    );
  }

  Widget _buildCountDisplay() {
    return Text(
      '${_butterflyCount.round()}',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildCustomSlider() {
    return SliderTheme(
      data: _createSliderTheme(),
      child: Slider(
        value: _butterflyCount,
        min: _minButterflies,
        max: _maxButterflies,
        onChanged: _updateButterflyCount,
      ),
    );
  }

  SliderThemeData _createSliderTheme() {
    return SliderThemeData(
      trackHeight: 2,
      activeTrackColor: _SliderColors.activeTrack,
      inactiveTrackColor: _SliderColors.inactiveTrack,
      thumbColor: _SliderColors.thumb,
      thumbShape: const RoundSliderThumbShape(
        enabledThumbRadius: 6,
        elevation: 0,
      ),
      overlayColor: _SliderColors.overlay,
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
    );
  }
}

// Separate class for color constants
class _SliderColors {
  static final activeTrack = Colors.white.withOpacity(0.8);
  static final inactiveTrack = Colors.white.withOpacity(0.2);
  static const thumb = Colors.white;
  static final overlay = Colors.white.withOpacity(0.1);

  // Private constructor to prevent instantiation
  _SliderColors._();
}
