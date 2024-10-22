import 'package:flutter/material.dart';
import 'package:fx_2_folder/fx_14_text_reveal/strategies/FadeBlurStrategy.dart';
import 'package:fx_2_folder/fx_14_text_reveal/strategies/FlyingCharactersStrategy.dart';
import 'package:fx_2_folder/fx_14_text_reveal/strategies/SwirlFloatStrategy.dart';
import 'package:fx_2_folder/fx_14_text_reveal/text_reveal_widget.dart';
import 'dart:math' as math;

// Animation Strategy Selection Model
class AnimationPreset {
  final String name;
  final TextAnimationStrategy strategy;
  final String description;

  const AnimationPreset({
    required this.name,
    required this.strategy,
    required this.description,
  });
}

class AnimationDemoScreen extends StatefulWidget {
  const AnimationDemoScreen({Key? key}) : super(key: key);

  @override
  State<AnimationDemoScreen> createState() => _AnimationDemoScreenState();
}

class _AnimationDemoScreenState extends State<AnimationDemoScreen> {
  bool _isAnimating = false;
  String _demoText = "Flutter is pure magic! ✨";
  AnimationUnit _selectedUnit = AnimationUnit.character;
  AnimationDirection _direction = AnimationDirection.forward;
  late AnimationPreset _selectedPreset;
  TextEditingController _textController = TextEditingController();

  // Define animation presets
  final List<AnimationPreset> presets = const [
    AnimationPreset(
      name: "Classic Fade & Blur",
      strategy: FadeBlurStrategy(),
      description: "Smooth fade in with gaussian blur effect",
    ),
    AnimationPreset(
      name: "Gentle Float",
      strategy: FlyingCharactersStrategy(
        maxOffset: 50,
        randomDirection: false,
        angle: -math.pi / 2,
      ),
      description: "Characters float up gently",
    ),
    AnimationPreset(
      name: "Gentle Float with Blur",
      strategy: FlyingCharactersStrategy(
        maxOffset: 50,
        randomDirection: false,
        enableBlur: true,
        angle: -math.pi / 2,
      ),
      description: "Characters float up gently",
    ),
    AnimationPreset(
      name: "Chaos Scatter",
      strategy: FlyingCharactersStrategy(
        maxOffset: 50,
        randomDirection: true,
      ),
      description: "Characters scatter in random directions",
    ),
    AnimationPreset(
      name: "Chaos Scatter with Blur",
      strategy: FlyingCharactersStrategy(
        maxOffset: 50,
        randomDirection: true,
        enableBlur: true,
      ),
      description: "Characters scatter in random directions",
    ),
    AnimationPreset(
      name: "Swirl Float",
      strategy: SwirlFloatStrategy(
        yOffset: -200.0,
        maxXDeviation: 60.0,
        maxBlur: 10.0,
        enableBlur: false,
        curveIntensity: 0.7,
        synchronizeAnimation: true, // More pronounced S-curve
      ),
      description: "Characters float in a swirl",
    ),
    AnimationPreset(
      name: "Swirl Float with Blur",
      strategy: SwirlFloatStrategy(
        yOffset: -200.0,
        maxXDeviation: 60.0,
        maxBlur: 10.0,
        enableBlur: true,
        curveIntensity: 0.7,
        synchronizeAnimation: true, // More pronounced S-curve
      ),
      description: "Characters float in a swirl",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedPreset = presets[0];
    _textController.text = _demoText;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Card(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Animation Preview Area
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: 100.0,
                    ),
                    child: EnhancedTextRevealEffect(
                      text: _demoText,
                      trigger: _isAnimating,
                      strategy: _selectedPreset.strategy,
                      unit: _selectedUnit,
                      direction: _direction,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ), // Replace with your actual widget
                  ),

                  const SizedBox(height: 32),

                  // Controls Section
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _isAnimating = !_isAnimating;
                        });
                      },
                      icon: Icon(_isAnimating
                          ? Icons.stop_rounded
                          : Icons.play_arrow_rounded),
                      label: Text(_isAnimating ? 'Reset' : 'Play'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Animation Settings
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      // Animation Preset Selector
                      DropdownButton<AnimationPreset>(
                        value: _selectedPreset,
                        items: presets.map((preset) {
                          return DropdownMenuItem(
                            value: preset,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(preset.name),
                                // Text(
                                //   preset.description,
                                //   style: TextStyle(
                                //     fontSize: 12,
                                //     color: Colors.grey[600],
                                //   ),
                                // ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (preset) {
                          if (preset != null) {
                            setState(() {
                              _selectedPreset = preset;
                            });
                          }
                        },
                      ),
                      const SizedBox(width: 16),

                      // Animation Unit Selector
                      SegmentedButton<AnimationUnit>(
                        segments: const [
                          ButtonSegment(
                            value: AnimationUnit.character,
                            label: Text('Character'),
                            icon: Icon(Icons.text_fields),
                          ),
                          ButtonSegment(
                            value: AnimationUnit.word,
                            label: Text('Word'),
                            icon: Icon(Icons.wrap_text),
                          ),
                        ],
                        selected: {_selectedUnit},
                        onSelectionChanged: (Set<AnimationUnit> selection) {
                          setState(() {
                            _selectedUnit = selection.first;
                          });
                        },
                      ),
                      const SizedBox(width: 16),

                      // Direction Selector
                      SegmentedButton<AnimationDirection>(
                        segments: const [
                          ButtonSegment(
                            value: AnimationDirection.forward,
                            label: Text('Forward'),
                            icon: Icon(Icons.arrow_forward),
                          ),
                          ButtonSegment(
                            value: AnimationDirection.reverse,
                            label: Text('Reverse'),
                            icon: Icon(Icons.arrow_back),
                          ),
                        ],
                        selected: {_direction},
                        onSelectionChanged:
                            (Set<AnimationDirection> selection) {
                          setState(() {
                            _direction = selection.first;
                          });
                        },
                      ),
                    ],
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
