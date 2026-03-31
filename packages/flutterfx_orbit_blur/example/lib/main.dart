import 'package:flutter/material.dart';
import 'package:flutterfx_orbit_blur/flutterfx_orbit_blur.dart';

void main() {
  runApp(const OrbitBlurExample());
}

// ─── Preset definitions ────────────────────────────────────────────────────

class _Preset {
  final String label;
  final Color bg;
  final OrbitStyle style;
  final List<IconData>? leftIcons;
  final List<IconData>? rightIcons;
  final List<Widget>? leftWidgets;
  final List<Widget>? rightWidgets;

  const _Preset({
    required this.label,
    required this.bg,
    required this.style,
    this.leftIcons,
    this.rightIcons,
    this.leftWidgets,
    this.rightWidgets,
  });
}

final _presets = [
  // 1 ── Default dark
  const _Preset(
    label: 'Dark (default)',
    bg: Colors.black,
    style: OrbitStyle.dark(),
  ),

  // 2 ── Light preset
  const _Preset(
    label: 'Light',
    bg: Color(0xFFF0F0F0),
    style: OrbitStyle.light(),
  ),

  // 3 ── Amber / custom colors
  _Preset(
    label: 'Amber',
    bg: const Color(0xFF1A1200),
    style: OrbitStyle(
      iconColor: Colors.amber,
      iconContainerColor: Colors.amber.withValues(alpha: 0.15),
      iconContainerBorderColor: Colors.amber.withValues(alpha: 0.4),
      orbitPathColor: Colors.amber.withValues(alpha: 0.15),
      centerBlurSigma: 10,
      centerColor: Colors.amber.withValues(alpha: 0.2),
      centerWidget: const Icon(Icons.bolt, color: Colors.amber, size: 26),
    ),
    leftIcons: const [Icons.bolt, Icons.star, Icons.local_fire_department],
    rightIcons: const [Icons.sunny, Icons.flash_on, Icons.auto_awesome],
  ),

  // 4 ── Purple / custom center widget
  _Preset(
    label: 'Purple',
    bg: const Color(0xFF0D001A),
    style: OrbitStyle(
      iconColor: Colors.purpleAccent,
      iconContainerColor: Colors.purple.withValues(alpha: 0.2),
      iconContainerBorderColor: Colors.purpleAccent.withValues(alpha: 0.5),
      orbitPathColor: Colors.purpleAccent.withValues(alpha: 0.15),
      centerBlurSigma: 14,
      centerColor: Colors.purpleAccent.withValues(alpha: 0.2),
      centerWidget: const Icon(Icons.rocket_launch,
          color: Colors.purpleAccent, size: 26),
    ),
    leftIcons: const [Icons.stars, Icons.auto_awesome, Icons.bubble_chart],
    rightIcons: const [Icons.diamond, Icons.hexagon, Icons.blur_on],
  ),

  // 5 ── Custom widgets (emoji + badge)
  _Preset(
    label: 'Custom widgets',
    bg: const Color(0xFF0A0A1A),
    style: OrbitStyle(
      centerBlurSigma: 8,
      centerColor: Colors.blueAccent.withValues(alpha: 0.2),
      centerWidget: const Text('⚡', style: TextStyle(fontSize: 22)),
    ),
    leftWidgets: const [
      _EmojiOrb(emoji: '🚀'),
      _EmojiOrb(emoji: '⭐'),
      _EmojiOrb(emoji: '🔥'),
    ],

    rightWidgets: const [
      _ColorBadge(color: Colors.redAccent, label: 'R'),
      _ColorBadge(color: Colors.greenAccent, label: 'G'),
      _ColorBadge(color: Colors.blueAccent, label: 'B'),
    ],
  ),
];

// ─── App ───────────────────────────────────────────────────────────────────

class OrbitBlurExample extends StatefulWidget {
  const OrbitBlurExample({super.key});

  @override
  State<OrbitBlurExample> createState() => _OrbitBlurExampleState();
}

class _OrbitBlurExampleState extends State<OrbitBlurExample> {
  int _presetIndex = 0;
  bool _reverse = true;
  bool _showPaths = true;
  double _duration = 10.0;

  _Preset get _preset => _presets[_presetIndex];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        color: _preset.bg,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ── Widget ────────────────────────────────────────────
                  OrbitingIcons(
                    reverse: _reverse,
                    duration: _duration,
                    showPaths: _showPaths,
                    style: _preset.style,
                    leftIcons: _preset.leftIcons,
                    rightIcons: _preset.rightIcons,
                    leftWidgets: _preset.leftWidgets,
                    rightWidgets: _preset.rightWidgets,
                  ),

                  const SizedBox(height: 40),

                  // ── Preset picker ──────────────────────────────────────
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: List.generate(_presets.length, (i) {
                      final selected = i == _presetIndex;
                      return GestureDetector(
                        onTap: () => setState(() => _presetIndex = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: selected
                                ? Colors.white.withValues(alpha: 0.2)
                                : Colors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: selected
                                  ? Colors.white.withValues(alpha: 0.6)
                                  : Colors.white.withValues(alpha: 0.15),
                            ),
                          ),
                          child: Text(
                            _presets[i].label,
                            style: TextStyle(
                              color: Colors.white.withValues(
                                  alpha: selected ? 1.0 : 0.5),
                              fontSize: 12,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 28),

                  // ── Controls ───────────────────────────────────────────
                  _Row(
                    label: 'Reverse direction',
                    child: Switch(
                      value: _reverse,
                      onChanged: (v) => setState(() => _reverse = v),
                    ),
                  ),
                  _Row(
                    label: 'Show orbit paths',
                    child: Switch(
                      value: _showPaths,
                      onChanged: (v) => setState(() => _showPaths = v),
                    ),
                  ),
                  _Row(
                    label: 'Speed: ${_duration.round()}s / orbit',
                    child: SizedBox(
                      width: 160,
                      child: Slider(
                        value: _duration,
                        min: 3,
                        max: 20,
                        divisions: 17,
                        onChanged: (v) => setState(() => _duration = v),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Custom orbit item widgets ─────────────────────────────────────────────

class _EmojiOrb extends StatelessWidget {
  final String emoji;
  const _EmojiOrb({required this.emoji});

  @override
  Widget build(BuildContext context) =>
      Text(emoji, style: const TextStyle(fontSize: 20));
}

class _ColorBadge extends StatelessWidget {
  final Color color;
  final String label;
  const _ColorBadge({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(label,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}

// ─── Layout helper ─────────────────────────────────────────────────────────

class _Row extends StatelessWidget {
  final String label;
  final Widget child;
  const _Row({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(color: Colors.white70, fontSize: 13)),
          child,
        ],
      ),
    );
  }
}
