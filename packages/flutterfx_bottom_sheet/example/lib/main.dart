import 'package:flutter/material.dart';
import 'package:bottom_sheet_fx/bottom_sheet_fx.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FxBottomSheet Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const _DemoHome(),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Presets
// ─────────────────────────────────────────────────────────────

class _Preset {
  final String label;
  final FxBottomSheetStyle style;
  final Color appBackground;
  final Color textColor;

  const _Preset({
    required this.label,
    required this.style,
    required this.appBackground,
    required this.textColor,
  });
}

final _presets = [
  _Preset(
    label: 'Light',
    style: FxBottomSheetStyle.light(),
    appBackground: const Color(0xFFF2F2F7),
    textColor: const Color(0xFF1C1C1E),
  ),
  _Preset(
    label: 'Dark',
    style: FxBottomSheetStyle.dark(),
    appBackground: const Color(0xFF000000),
    textColor: Colors.white,
  ),
  _Preset(
    label: 'Indigo',
    style: FxBottomSheetStyle.light().copyWith(
      backgroundColor: const Color(0xFF3F3D8F),
      handleColor: const Color(0xFF6C6ABF),
      topBorderRadius: 28,
      mainContentScale: 0.88,
    ),
    appBackground: const Color(0xFF1A1845),
    textColor: Colors.white,
  ),
  _Preset(
    label: 'Minimal',
    style: FxBottomSheetStyle.light().copyWith(
      topBorderRadius: 8,
      mainContentScale: 0.97,
      mainContentSlide: 8,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 6,
          offset: const Offset(0, -1),
        ),
      ],
    ),
    appBackground: Colors.white,
    textColor: const Color(0xFF1C1C1E),
  ),
];

// ─────────────────────────────────────────────────────────────
// Demo home — preset picker + controls
// ─────────────────────────────────────────────────────────────

class _DemoHome extends StatefulWidget {
  const _DemoHome();

  @override
  State<_DemoHome> createState() => _DemoHomeState();
}

class _DemoHomeState extends State<_DemoHome> {
  int _presetIndex = 0;
  double _maxHeight = 0.90;

  // A new controller is needed whenever the preset changes because a new
  // FxBottomSheet widget is built. Keying on preset index handles this.
  final Map<int, FxBottomSheetController> _controllers = {};

  FxBottomSheetController _controllerFor(int index) {
    return _controllers.putIfAbsent(index, FxBottomSheetController.new);
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final preset = _presets[_presetIndex];
    final controller = _controllerFor(_presetIndex);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      color: preset.appBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false,
          child: FxBottomSheet(
            key: ValueKey(_presetIndex),
            controller: controller,
            style: preset.style,
            maxHeight: _maxHeight,
            mainContent: _MainContent(
              preset: preset,
              presetIndex: _presetIndex,
              maxHeight: _maxHeight,
              onPresetChanged: (i) => setState(() => _presetIndex = i),
              onMaxHeightChanged: (v) => setState(() => _maxHeight = v),
              onOpen: controller.open,
            ),
            drawerContent: _SheetContent(preset: preset),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Main content (lives behind the sheet)
// ─────────────────────────────────────────────────────────────

class _MainContent extends StatelessWidget {
  final _Preset preset;
  final int presetIndex;
  final double maxHeight;
  final ValueChanged<int> onPresetChanged;
  final ValueChanged<double> onMaxHeightChanged;
  final VoidCallback onOpen;

  const _MainContent({
    required this.preset,
    required this.presetIndex,
    required this.maxHeight,
    required this.onPresetChanged,
    required this.onMaxHeightChanged,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Top bar ──────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: Row(
            children: [
              Icon(Icons.layers_rounded, size: 28, color: preset.textColor),
              const SizedBox(width: 10),
              Text(
                'FlutterFX',
                style: TextStyle(
                  color: preset.textColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),

        // ── Preset chips ─────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: Wrap(
            spacing: 8,
            children: List.generate(_presets.length, (i) {
              final selected = i == presetIndex;
              return ChoiceChip(
                label: Text(_presets[i].label),
                selected: selected,
                onSelected: (_) => onPresetChanged(i),
                selectedColor: preset.textColor,
                labelStyle: TextStyle(
                  color: selected ? preset.appBackground : preset.textColor,
                  fontWeight: FontWeight.w600,
                ),
                side: BorderSide(
                  color: preset.textColor.withValues(alpha: 0.3),
                ),
                backgroundColor: Colors.transparent,
              );
            }),
          ),
        ),

        // ── Height slider ────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Row(
            children: [
              Text(
                'Max height  ${(maxHeight * 100).round()}%',
                style: TextStyle(
                  color: preset.textColor.withValues(alpha: 0.7),
                  fontSize: 13,
                ),
              ),
              Expanded(
                child: Slider(
                  value: maxHeight,
                  min: 0.3,
                  max: 1.0,
                  divisions: 14,
                  activeColor: preset.textColor,
                  inactiveColor: preset.textColor.withValues(alpha: 0.2),
                  onChanged: onMaxHeightChanged,
                ),
              ),
            ],
          ),
        ),

        // ── Centre CTA ───────────────────────────────────────
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.swipe_up_rounded,
                  size: 52,
                  color: preset.textColor.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 20),
                Text(
                  'Bottom Sheet',
                  style: TextStyle(
                    color: preset.textColor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Drag up or tap Open',
                  style: TextStyle(
                    color: preset.textColor.withValues(alpha: 0.5),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: onOpen,
                  icon: const Icon(Icons.arrow_upward_rounded, size: 18),
                  label: const Text('Open'),
                  style: FilledButton.styleFrom(
                    backgroundColor: preset.textColor,
                    foregroundColor: preset.appBackground,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Sheet content
// ─────────────────────────────────────────────────────────────

class _SheetContent extends StatelessWidget {
  final _Preset preset;

  const _SheetContent({required this.preset});

  @override
  Widget build(BuildContext context) {
    final isLight = preset.style.backgroundColor.computeLuminance() > 0.5;
    final titleColor = isLight ? const Color(0xFF1C1C1E) : Colors.white;
    final subtitleColor =
        isLight ? const Color(0xFF6E6E73) : Colors.white.withValues(alpha: 0.6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Discover',
                style: TextStyle(
                  color: titleColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Swipe down or tap outside to dismiss.',
                style: TextStyle(color: subtitleColor, fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            physics: const BouncingScrollPhysics(),
            children: [
              _FeatureCard(
                icon: Icons.bolt_rounded,
                title: 'Smooth animations',
                description:
                    'Scale-and-slide entrance powered by CurvedAnimation.',
                iconColor: const Color(0xFF5856D6),
                isLight: isLight,
              ),
              _FeatureCard(
                icon: Icons.touch_app_rounded,
                title: 'Drag to dismiss',
                description:
                    'Velocity-aware snapping — fling down to close instantly.',
                iconColor: const Color(0xFF34C759),
                isLight: isLight,
              ),
              _FeatureCard(
                icon: Icons.palette_rounded,
                title: 'Style system',
                description:
                    'Light/dark presets with copyWith for rapid customisation.',
                iconColor: const Color(0xFFFF9500),
                isLight: isLight,
              ),
              _FeatureCard(
                icon: Icons.code_rounded,
                title: 'Programmatic control',
                description:
                    'FxBottomSheetController lets you open/close from anywhere.',
                iconColor: const Color(0xFFFF2D55),
                isLight: isLight,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color iconColor;
  final bool isLight;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.iconColor,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = isLight ? Colors.white : const Color(0xFF2C2C2E);
    final titleColor = isLight ? const Color(0xFF1C1C1E) : Colors.white;
    final bodyColor = isLight ? const Color(0xFF6E6E73) : const Color(0xFF98989D);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isLight
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 2),
                  Text(
                    title,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: TextStyle(
                      color: bodyColor,
                      fontSize: 14,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
