// avatar_circles.dart

import 'package:flutter/material.dart';
import 'package:fx_2_folder/stacked-cards/stacked_card.dart';
import 'package:url_launcher/url_launcher.dart';

// avatar_circles.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Represents an individual avatar with its image and profile URLs
class Avatar {
  final String imageUrl;
  final String profileUrl;

  const Avatar({
    required this.imageUrl,
    required this.profileUrl,
  });
}

/// A widget that displays a row of overlapping circular avatars with an optional
/// count indicator for additional people
class AvatarCircles extends StatelessWidget {
  /// List of avatars to display
  final List<Avatar> avatars;

  /// Number of additional people to show in the count indicator
  final int? additionalPeople;

  /// Size of each avatar circle
  final double size;

  /// Border width around each avatar
  final double borderWidth;

  /// Background color for the count indicator
  final Color? countBackgroundColor;

  /// Text color for the count indicator
  final Color? countTextColor;

  /// Border color for the avatars
  final Color? borderColor;

  /// Overlap amount between avatars (positive value)
  final double overlap;

  const AvatarCircles({
    Key? key,
    required this.avatars,
    this.additionalPeople,
    this.size = 40,
    this.borderWidth = 2,
    this.countBackgroundColor,
    this.countTextColor,
    this.borderColor,
    this.overlap = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Calculate total width needed
    final totalAvatars = avatars.length + (additionalPeople != null ? 1 : 0);
    final totalWidth = size + (totalAvatars - 1) * (size - overlap);

    return SizedBox(
      width: totalWidth,
      height: size,
      child: Stack(
        children: [
          // Render avatars
          ...avatars.asMap().entries.map((entry) {
            final index = entry.key;
            final avatar = entry.value;

            return Positioned(
              left: index * (size - overlap),
              child: GestureDetector(
                onTap: () async {
                  final url = Uri.parse(avatar.profileUrl);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: borderColor ??
                          (isDark
                              ? theme.colorScheme.surface
                              : theme.colorScheme.background),
                      width: borderWidth,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(size / 2),
                    child: Image.network(
                      avatar.imageUrl,
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );
          }),

          // Render additional people counter if needed
          if (additionalPeople != null && additionalPeople! > 0)
            Positioned(
              left: avatars.length * (size - overlap),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: countBackgroundColor ??
                      (isDark ? theme.colorScheme.surface : Colors.black),
                  border: Border.all(
                    color: borderColor ??
                        (isDark
                            ? theme.colorScheme.surface
                            : theme.colorScheme.background),
                    width: borderWidth,
                  ),
                ),
                child: Center(
                  child: Text(
                    '+${additionalPeople}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: countTextColor ??
                          (isDark
                              ? Colors.black
                              : theme.colorScheme.background),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class AvatarCirclesShowcase extends StatelessWidget {
  final List<Avatar> sampleAvatars = [
    const Avatar(
      imageUrl:
          'https://cdn.bsky.app/img/avatar/plain/did:plc:34qtss66g2so6rudozx7iri7/bafkreiay2zk2ivksxufahyoewrfnpk2ne4urcm4alkgy3zsum7qlgmnh6y@jpeg',
      profileUrl: 'https://bsky.app/profile/escamoteur.bsky.social',
    ),
    const Avatar(
      imageUrl:
          'https://cdn.bsky.app/img/avatar/plain/did:plc:vnq2ph2haugwbb4xbksqnvci/bafkreigzrqcabzfwpzmftrh3seitqr7djdd6jop35ltc4lxev5bsw5muxa@jpeg',
      profileUrl: 'https://bsky.app/profile/dariadroid.flutter.community',
    ),
    const Avatar(
      imageUrl:
          'https://cdn.bsky.app/img/avatar/plain/did:plc:yfqc4hzvri2nmaiifrnhs2y2/bafkreiasb3wslfq5nbwo6et5q3rrysoxj3qbpk6hdqrjsewyktcn2zpqwq@jpeg',
      profileUrl: 'https://bsky.app/profile/sethladd.com',
    ),
    const Avatar(
      imageUrl:
          'https://cdn.bsky.app/img/avatar/plain/did:plc:qibza37i7hkd7phfymqief2l/bafkreih6enfkkwl5ejcm27mzkri7kjfxpm2kxqskaep56nadztvgpait74@jpeg',
      profileUrl: 'https://bsky.app/profile/eseidel.com',
    ),
  ];

  AvatarCirclesShowcase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(
            painter: GridPatternPainter(isDarkMode: true),
            size: Size.infinite,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildShowcaseSection(
                    'Default Style',
                    AvatarCircles(
                      avatars: sampleAvatars.take(3).toList(),
                      additionalPeople: 5,
                    ),
                  ),
                  _buildShowcaseSection(
                    'Large Size with Custom Colors',
                    AvatarCircles(
                      avatars: sampleAvatars.take(2).toList(),
                      additionalPeople: 3,
                      size: 60,
                      borderWidth: 3,
                      overlap: 24,
                      borderColor: Colors.blue[300],
                      countBackgroundColor: Colors.blue,
                      countTextColor: Colors.white,
                    ),
                  ),
                  _buildShowcaseSection(
                    'Small Size with More Overlap',
                    AvatarCircles(
                      avatars: sampleAvatars,
                      size: 32,
                      overlap: 20,
                      borderWidth: 1.5,
                    ),
                  ),
                  _buildShowcaseSection(
                    'Custom Themed',
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.grey[900],
                      child: AvatarCircles(
                        avatars: sampleAvatars.take(4).toList(),
                        additionalPeople: 2,
                        borderColor: Colors.grey[800],
                        countBackgroundColor: Colors.purple,
                        countTextColor: Colors.white,
                      ),
                    ),
                  ),
                  _buildShowcaseSection(
                    'Minimal Overlap',
                    AvatarCircles(
                      avatars: sampleAvatars.take(4).toList(),
                      overlap: 8,
                      borderWidth: 2,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShowcaseSection(String title, Widget content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }
}
