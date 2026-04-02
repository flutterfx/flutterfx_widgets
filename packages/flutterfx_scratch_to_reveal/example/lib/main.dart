import 'package:flutter/material.dart';
import 'package:flutterfx_scratch_to_reveal/flutterfx_scratch_to_reveal.dart';

void main() {
  runApp(const ScratchToRevealExample());
}

// ─── Preset definitions ────────────────────────────────────────────────────

class _Preset {
  final String label;
  final Color bg;
  final List<Color> gradientColors;
  final Widget revealChild;

  const _Preset({
    required this.label,
    required this.bg,
    required this.gradientColors,
    required this.revealChild,
  });
}

final _presets = [
  _Preset(
    label: 'Purple Dream',
    bg: const Color(0xFF0D0D1A),
    gradientColors: const [Color(0xFFA97CF8), Color(0xFFF38CB8), Color(0xFFFDCC92)],
    revealChild: Container(
      color: const Color(0xFF1A1A2E),
      child: const Center(
        child: Text('🎉', style: TextStyle(fontSize: 80)),
      ),
    ),
  ),
  _Preset(
    label: 'Ocean Blue',
    bg: const Color(0xFF001A2E),
    gradientColors: const [Color(0xFF00C6FF), Color(0xFF0072FF)],
    revealChild: Container(
      color: const Color(0xFF0D1B2A),
      child: const Center(
        child: Text(
          'You won!',
          style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  ),
  _Preset(
    label: 'Sunset',
    bg: const Color(0xFF1A0A00),
    gradientColors: const [Color(0xFFFF6B35), Color(0xFFFF8E53), Color(0xFFFFD700)],
    revealChild: Container(
      color: const Color(0xFF2A1500),
      child: const Center(
        child: Text('🏆', style: TextStyle(fontSize: 80)),
      ),
    ),
  ),
  _Preset(
    label: 'Emerald',
    bg: const Color(0xFF001A0D),
    gradientColors: const [Color(0xFF00B09B), Color(0xFF96C93D)],
    revealChild: Container(
      color: const Color(0xFF0D2A1A),
      child: const Center(
        child: Text(
          '\$500',
          style: TextStyle(color: Colors.greenAccent, fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  ),
  _Preset(
    label: 'Rose Gold',
    bg: const Color(0xFF1A0A10),
    gradientColors: const [Color(0xFFf953c6), Color(0xFFb91d73)],
    revealChild: Container(
      color: const Color(0xFF2A1020),
      child: const Center(
        child: Text('💎', style: TextStyle(fontSize: 80)),
      ),
    ),
  ),
];

// ─── App ───────────────────────────────────────────────────────────────────

class ScratchToRevealExample extends StatefulWidget {
  const ScratchToRevealExample({super.key});

  @override
  State<ScratchToRevealExample> createState() => _ScratchToRevealExampleState();
}

class _ScratchToRevealExampleState extends State<ScratchToRevealExample> {
  int _presetIndex = 0;
  int _key = 0;
  String _status = 'Scratch to reveal!';
  double _scratchThreshold = 50.0;
  double _widgetSize = 280.0;
  bool _haptic = true;

  _Preset get _preset => _presets[_presetIndex];

  void _reset() {
    setState(() {
      _key++;
      _status = 'Scratch to reveal!';
    });
  }

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
                  // ── Status ─────────────────────────────────────────────
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      _status,
                      key: ValueKey(_status),
                      style: TextStyle(
                        color: _status == 'Revealed!'
                            ? Colors.greenAccent
                            : Colors.white54,
                        fontSize: 16,
                        fontWeight: _status == 'Revealed!'
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Widget ─────────────────────────────────────────────
                  ScratchToReveal(
                    key: ValueKey('$_key-$_presetIndex-$_widgetSize-$_scratchThreshold'),
                    width: _widgetSize,
                    height: _widgetSize,
                    minScratchPercentage: _scratchThreshold,
                    gradientColors: _preset.gradientColors,
                    enableHapticFeedback: _haptic,
                    onComplete: () {
                      setState(() => _status = 'Revealed!');
                    },
                    child: SizedBox(
                      width: _widgetSize,
                      height: _widgetSize,
                      child: _preset.revealChild,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Preset picker ──────────────────────────────────────
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: List.generate(_presets.length, (i) {
                      final selected = i == _presetIndex;
                      return GestureDetector(
                        onTap: () => setState(() {
                          _presetIndex = i;
                          _key++;
                          _status = 'Scratch to reveal!';
                        }),
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
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _GradientDot(colors: _presets[i].gradientColors),
                              const SizedBox(width: 6),
                              Text(
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
                            ],
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 24),

                  // ── Controls ───────────────────────────────────────────
                  _Row(
                    label: 'Scratch threshold: ${_scratchThreshold.round()}%',
                    child: SizedBox(
                      width: 140,
                      child: Slider(
                        value: _scratchThreshold,
                        min: 10,
                        max: 90,
                        divisions: 16,
                        activeColor: _preset.gradientColors.first,
                        onChanged: (v) => setState(() {
                          _scratchThreshold = v;
                          _key++;
                          _status = 'Scratch to reveal!';
                        }),
                      ),
                    ),
                  ),
                  _Row(
                    label: 'Card size: ${_widgetSize.round()}px',
                    child: SizedBox(
                      width: 140,
                      child: Slider(
                        value: _widgetSize,
                        min: 160,
                        max: 320,
                        divisions: 8,
                        activeColor: _preset.gradientColors.first,
                        onChanged: (v) => setState(() {
                          _widgetSize = v;
                          _key++;
                          _status = 'Scratch to reveal!';
                        }),
                      ),
                    ),
                  ),
                  _Row(
                    label: 'Haptic feedback',
                    child: Switch(
                      value: _haptic,
                      activeThumbColor: _preset.gradientColors.first,
                      onChanged: (v) => setState(() => _haptic = v),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Reset button ───────────────────────────────────────
                  TextButton(
                    onPressed: _reset,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.2)),
                      ),
                    ),
                    child: const Text(
                      'Reset',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Helpers ───────────────────────────────────────────────────────────────

class _GradientDot extends StatelessWidget {
  final List<Color> colors;
  const _GradientDot({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: colors),
      ),
    );
  }
}

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
              style: const TextStyle(color: Colors.white70, fontSize: 13)),
          child,
        ],
      ),
    );
  }
}
