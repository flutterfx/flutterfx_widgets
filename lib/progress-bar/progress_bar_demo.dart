import 'package:flutter/material.dart';
import 'package:fx_2_folder/progress-bar/design/grid.dart';
import 'package:fx_2_folder/progress-bar/progress_bar.dart';
import 'package:fx_2_folder/progress-bar/strategies/wave_progress_strategy.dart';

class ProgressBarDemo extends StatefulWidget {
  const ProgressBarDemo({Key? key}) : super(key: key);

  @override
  State<ProgressBarDemo> createState() => _ProgressBarDemoState();
}

class _ProgressBarDemoState extends State<ProgressBarDemo> {
  // Current progress value
  double _progress = 0.7;

  // Define consistent color palette
  static const Color _primaryWhite = Color(0xFFFFFFFF);
  static const Color _softWhite = Color(0xFFE0E0E0);
  static const Color _mediumGray = Color(0xFF808080);
  static const Color _darkGray = Color(0xFF333333);
  static const Color _deepBlack = Color(0xFF1A1A1A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Grid background with darker shade
          CustomPaint(
            painter: GridPatternPainter(
              isDarkMode: true,
            ),
            size: Size.infinite,
          ),
          // Main content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Progress info text with enhanced typography
                Text(
                  '${(_progress * 100).toStringAsFixed(1)}%',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: _primaryWhite,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                ),
                const SizedBox(height: 40),

                // Linear progress bar with subtle gradient
                ProgressLoader(
                  progress: _progress,
                  strategy: LinearProgressStrategy(),
                  style: const ProgressStyle(
                    gradientColors: [
                      _softWhite,
                      _primaryWhite,
                    ],
                    height: 8, // Slightly thinner for elegance
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    backgroundColor: _mediumGray,
                  ),
                ),
                const SizedBox(height: 48),

                // Wave progress bar with refined animation
                ProgressLoader(
                  progress: _progress,
                  strategy: const DynamicWaveProgressStrategy(
                    waveDuration: Duration(milliseconds: 2500),
                    autoAnimate: true,
                    waveCurve: Curves.linear,
                  ),
                  style: ProgressStyle(
                    height: 130,
                    width: 130,
                    borderRadius: BorderRadius.circular(12),
                    primaryColor: _primaryWhite.withOpacity(0.85),
                    backgroundColor: _mediumGray,
                  ),
                ),
                const SizedBox(height: 48),

                // Circular progress bar with sophisticated look
                ProgressLoader(
                  progress: _progress,
                  strategy: CircularProgressStrategy(
                    strokeWidth: 10,
                  ),
                  style: const ProgressStyle(
                    width: 130,
                    gradientColors: [
                      _primaryWhite,
                      _primaryWhite,
                    ],
                    backgroundColor: _darkGray,
                  ),
                ),

                const SizedBox(height: 60),

                // Refined slider control
                Column(
                  children: [
                    Text(
                      'Adjust Progress',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: _softWhite.withOpacity(0.7),
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 12),
                    SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 3,
                        activeTrackColor: _primaryWhite,
                        inactiveTrackColor: _mediumGray,
                        thumbColor: _primaryWhite,
                        overlayColor: _primaryWhite.withOpacity(0.1),
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 7,
                          elevation: 2,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 18,
                        ),
                      ),
                      child: Slider(
                        value: _progress,
                        onChanged: (value) {
                          setState(() {
                            _progress = value;
                          });
                        },
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
