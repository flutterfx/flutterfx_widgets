import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fx_2_folder/background-flicker-grid/background_flicker_grid.dart';

class FancyCard extends StatelessWidget {
  const FancyCard({
    Key? key,
    this.width = 400,
    this.height = 250,
    required this.title,
    required this.subtitle,
    this.icon,
    this.onTap,
    required this.colorScheme,
  }) : super(key: key);

  final double width;
  final double height;
  final String title;
  final String subtitle;
  final IconData? icon;
  final VoidCallback? onTap;
  final CardColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: colorScheme.borderColor,
                width: 1.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  // Flickering Grid Background
                  Positioned.fill(
                    child: FlickeringGrid(
                      squareSize: 6, // Increased from 4
                      gridGap: 8, // Increased from 6
                      color: colorScheme.gridColor,
                      maxOpacity: 0.6, // Increased from 0.4
                      flickerChance: 0.08, // Increased from 0.05
                    ),
                  ),

                  // Primary Gradient Overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: colorScheme.gradientColors,
                        ),
                      ),
                    ),
                  ),

                  // Glass Effect
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                          sigmaX: 2, sigmaY: 2), // Reduced from 3
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorScheme.glassColor,
                        ),
                      ),
                    ),
                  ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (icon != null) ...[
                          Icon(
                            icon,
                            size: 40,
                            color: colorScheme.iconColor,
                          ),
                          const SizedBox(height: 16),
                        ],
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.titleColor,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 16,
                            color: colorScheme.subtitleColor,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Accent Glow
                  Positioned(
                    right: -100,
                    top: -100,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            colorScheme.accentGlowColor,
                            colorScheme.accentGlowColor.withOpacity(0),
                          ],
                        ),
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

class CardColorScheme {
  final Color gridColor;
  final Color borderColor;
  final List<Color> gradientColors;
  final Color glassColor;
  final Color iconColor;
  final Color titleColor;
  final Color subtitleColor;
  final Color accentGlowColor;

  const CardColorScheme({
    required this.gridColor,
    required this.borderColor,
    required this.gradientColors,
    required this.glassColor,
    required this.iconColor,
    required this.titleColor,
    required this.subtitleColor,
    required this.accentGlowColor,
  });
}

// Predefined color schemes
// class CardThemes {
//   // Cyberpunk Neon
//   static final cyberpunk = CardColorScheme(
//     gridColor: const Color(0xFF00FF9C),
//     borderColor: const Color(0xFF00FF9C).withOpacity(0.3),
//     gradientColors: [
//       const Color(0xFF2E1460).withOpacity(0.8),
//       const Color(0xFF6B1C8C).withOpacity(0.6),
//       const Color(0xFF530083).withOpacity(0.4),
//     ],
//     glassColor: const Color(0xFF2A0F4D).withOpacity(0.2),
//     iconColor: const Color(0xFF00FFB2),
//     titleColor: const Color(0xFF00FFB2),
//     subtitleColor: const Color(0xFFB4FFE3),
//     accentGlowColor: const Color(0xFF00FF9C).withOpacity(0.2),
//   );

//   // Aurora Borealis
//   static final aurora = CardColorScheme(
//     gridColor: const Color(0xFF7AF5FF),
//     borderColor: const Color(0xFF7AF5FF).withOpacity(0.3),
//     gradientColors: [
//       const Color(0xFF134E5E).withOpacity(0.8),
//       const Color(0xFF1FA88C).withOpacity(0.6),
//       const Color(0xFF16A085).withOpacity(0.4),
//     ],
//     glassColor: const Color(0xFF134E5E).withOpacity(0.2),
//     iconColor: const Color(0xFF7AF5FF),
//     titleColor: const Color(0xFF7AF5FF),
//     subtitleColor: const Color(0xFFB4F8FF),
//     accentGlowColor: const Color(0xFF7AF5FF).withOpacity(0.2),
//   );

//   // Sunset Fusion
//   static final sunset = CardColorScheme(
//     gridColor: const Color(0xFFFFB347),
//     borderColor: const Color(0xFFFFB347).withOpacity(0.3),
//     gradientColors: [
//       const Color(0xFFCB2D3E).withOpacity(0.8),
//       const Color(0xFFEF473A).withOpacity(0.6),
//       const Color(0xFFDE6262).withOpacity(0.4),
//     ],
//     glassColor: const Color(0xFFCB2D3E).withOpacity(0.2),
//     iconColor: const Color(0xFFFFB347),
//     titleColor: const Color(0xFFFFB347),
//     subtitleColor: const Color(0xFFFFD7A8),
//     accentGlowColor: const Color(0xFFFFB347).withOpacity(0.2),
//   );
// }
class CardThemes {
  // Cyberpunk Neon
  static final cyberpunk = CardColorScheme(
    gridColor: const Color(0xFF00FF9C), // Kept bright neon green
    borderColor: const Color(0xFF00FF9C).withOpacity(0.3),
    gradientColors: [
      const Color(0xFF2E1460).withOpacity(0.6), // Reduced opacity from 0.8
      const Color(0xFF6B1C8C).withOpacity(0.4), // Reduced opacity from 0.6
      const Color(0xFF530083).withOpacity(0.2), // Reduced opacity from 0.4
    ],
    glassColor: const Color(0xFF2A0F4D).withOpacity(0.1), // Reduced from 0.2
    iconColor: const Color(0xFF00FFB2),
    titleColor: const Color(0xFF00FFB2),
    subtitleColor: const Color(0xFFB4FFE3),
    accentGlowColor: const Color(0xFF00FF9C).withOpacity(0.2),
  );

  // Aurora Borealis
  static final aurora = CardColorScheme(
    gridColor: const Color(0xFF7AF5FF),
    borderColor: const Color(0xFF7AF5FF).withOpacity(0.3),
    gradientColors: [
      const Color(0xFF134E5E).withOpacity(0.6), // Reduced opacity
      const Color(0xFF1FA88C).withOpacity(0.4), // Reduced opacity
      const Color(0xFF16A085).withOpacity(0.2), // Reduced opacity
    ],
    glassColor: const Color(0xFF134E5E).withOpacity(0.1), // Reduced opacity
    iconColor: const Color(0xFF7AF5FF),
    titleColor: const Color(0xFF7AF5FF),
    subtitleColor: const Color(0xFFB4F8FF),
    accentGlowColor: const Color(0xFF7AF5FF).withOpacity(0.2),
  );

  // Sunset Fusion
  static final sunset = CardColorScheme(
    gridColor: const Color(0xFFFFB347),
    borderColor: const Color(0xFFFFB347).withOpacity(0.3),
    gradientColors: [
      const Color(0xFFCB2D3E).withOpacity(0.6), // Reduced opacity
      const Color(0xFFEF473A).withOpacity(0.4), // Reduced opacity
      const Color(0xFFDE6262).withOpacity(0.2), // Reduced opacity
    ],
    glassColor: const Color(0xFFCB2D3E).withOpacity(0.1), // Reduced opacity
    iconColor: const Color(0xFFFFB347),
    titleColor: const Color(0xFFFFB347),
    subtitleColor: const Color(0xFFFFD7A8),
    accentGlowColor: const Color(0xFFFFB347).withOpacity(0.2),
  );
}

// Demo Usage
class ColorfulCardsDemo extends StatelessWidget {
  const ColorfulCardsDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A), // Deep dark background
      body: Center(
        child: SingleChildScrollView(
          child: Wrap(
            spacing: 24,
            runSpacing: 24,
            children: [
              // Cyberpunk Theme Card
              FancyCard(
                title: 'Neural Nexus',
                subtitle: 'Advanced AI Neural Networks',
                icon: Icons.psychology,
                colorScheme: CardThemes.cyberpunk,
                onTap: () => print('Cyberpunk card tapped'),
              ),

              // Aurora Theme Card
              FancyCard(
                title: 'Quantum Flux',
                subtitle: 'Quantum Computing Systems',
                icon: Icons.memory,
                colorScheme: CardThemes.aurora,
                onTap: () => print('Aurora card tapped'),
              ),

              // Sunset Theme Card
              FancyCard(
                title: 'Data Fusion',
                subtitle: 'Real-time Data Processing',
                icon: Icons.analytics,
                colorScheme: CardThemes.sunset,
                onTap: () => print('Sunset card tapped'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
