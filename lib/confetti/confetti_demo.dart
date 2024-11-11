import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fx_2_folder/confetti/confetti.dart';

class ConfettiDemo extends StatefulWidget {
  const ConfettiDemo({super.key});

  @override
  State<ConfettiDemo> createState() => _ConfettiDemoScreenState();
}

class _ConfettiDemoScreenState extends State<ConfettiDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<EnhancedConfettiParticle> _particles = [];
  Timer? _timer;
  bool _isPlaying = false;

  // Different confetti configurations
  final EnhancedConfettiOptions _birthdayConfig = const EnhancedConfettiOptions(
    particleCount: 150,
    shapes: [ParticleShape.star, ParticleShape.heart],
    colors: [
      Colors.pink,
      Colors.purple,
      Colors.yellow,
      Colors.cyan,
      Colors.orange,
    ],
    burstSpread: 180,
    burstVelocity: -18.0,
  );

  final EnhancedConfettiOptions _celebrationConfig =
      const EnhancedConfettiOptions(
    particleCount: 200,
    shapes: [
      ParticleShape.rectangle,
      ParticleShape.circle,
      ParticleShape.strip,
      ParticleShape.diamond,
    ],
    initialSpread: 20,
    burstSpread: 150,
    burstVelocity: -12.0,
    turbulenceFactor: 0.7,
  );

  final EnhancedConfettiOptions _gentleConfig = const EnhancedConfettiOptions(
    particleCount: 80,
    shapes: [ParticleShape.strip, ParticleShape.circle],
    colors: [Colors.blue, Colors.teal, Colors.indigo],
    initialSpread: 10,
    burstSpread: 90,
    burstVelocity: -8.0,
    turbulenceFactor: 0.3,
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startConfetti(EnhancedConfettiOptions options) {
    if (_isPlaying) return;

    setState(() {
      _isPlaying = true;
      _particles = List.generate(
        options.particleCount,
        (index) => EnhancedConfettiParticle(
          position: const Offset(0, 0),
          velocity: const Offset(0, 0),
          color: options.colors[index % options.colors.length],
          shape: options.shapes[index % options.shapes.length],
          size: 8 + index % 4 * 2,
        ),
      );
    });

    _controller.forward(from: 0);

    // Stop the animation after 5 seconds
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 5), () {
      setState(() {
        _isPlaying = false;
        _particles.clear();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Stack(
        children: [
          // Confetti layer
          if (_isPlaying)
            CustomPaint(
              painter: EnhancedConfettiPainter(
                particles: _particles,
                progress: _controller.value,
                options: _celebrationConfig,
              ),
              size: Size.infinite,
            ),

          // Controls layer
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ConfettiButton(
                  label: '🎂 Birthday Burst',
                  color: Colors.pink.shade400,
                  onPressed: () => _startConfetti(_birthdayConfig),
                ),
                const SizedBox(height: 20),
                _ConfettiButton(
                  label: '🎉 Celebration',
                  color: Colors.purple.shade400,
                  onPressed: () => _startConfetti(_celebrationConfig),
                ),
                const SizedBox(height: 20),
                _ConfettiButton(
                  label: '🌟 Gentle Rain',
                  color: Colors.blue.shade400,
                  onPressed: () => _startConfetti(_gentleConfig),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfettiButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ConfettiButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 8,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
