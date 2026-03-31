import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════════════════
// OrbitStyle — all visual customization in one place
// ═══════════════════════════════════════════════════════════════════════════

/// Visual styling for [OrbitingIcons].
///
/// Pass a single [OrbitStyle] to control colors, blur, sizes, and the center
/// widget.  Use the named constructors for zero-effort theming:
///
/// ```dart
/// OrbitingIcons(style: OrbitStyle.dark())   // dark background
/// OrbitingIcons(style: OrbitStyle.light())  // light background
/// ```
///
/// Or build your own:
///
/// ```dart
/// OrbitingIcons(
///   style: OrbitStyle(
///     iconColor: Colors.purple,
///     iconContainerColor: Colors.purple.withValues(alpha: 0.15),
///     centerBlurSigma: 12,
///     centerColor: Colors.white.withValues(alpha: 0.2),
///     centerWidget: Icon(Icons.bolt, color: Colors.yellow),
///   ),
/// )
/// ```
class OrbitStyle {
  // ── Icon defaults (used when leftIcons / rightIcons are provided) ─────────

  /// Color of the icon inside the auto-generated icon container.
  final Color iconColor;

  /// Background fill of the auto-generated icon container circle.
  final Color iconContainerColor;

  /// Border color of the auto-generated icon container circle.
  final Color iconContainerBorderColor;

  /// Size of the icon inside the auto-generated container (logical pixels).
  final double iconSize;

  // ── Orbit path ────────────────────────────────────────────────────────────

  /// Color of the faint circular guide line drawn when [OrbitingIcons.showPaths]
  /// is `true`.
  final Color orbitPathColor;

  // ── Center frosted-glass circle ────────────────────────────────────────────

  /// Diameter of the frosted-glass circle at the center (logical pixels).
  final double centerSize;

  /// Blur sigma applied to the [BackdropFilter] behind the center circle.
  /// Higher values = more blur.
  final double centerBlurSigma;

  /// Tint color of the frosted-glass circle.
  final Color centerColor;

  /// Widget rendered inside the center circle.
  ///
  /// Defaults to `null`, which shows the built-in chevron indicator.
  /// Pass any widget to replace it — e.g. an [Icon], [Image], or [Text].
  final Widget? centerWidget;

  const OrbitStyle({
    this.iconColor = Colors.blue,
    this.iconContainerColor = const Color(0xFF424242), // Colors.grey[850]
    this.iconContainerBorderColor = const Color(0xFF616161), // Colors.grey[700]
    this.iconSize = 20,
    this.orbitPathColor = const Color(0x1AFFFFFF), // white 10 %
    this.centerSize = 70,
    this.centerBlurSigma = 5,
    this.centerColor = const Color(0x26808080), // grey 15 %
    this.centerWidget,
  });

  /// Preset for dark backgrounds (default look).
  const OrbitStyle.dark()
      : iconColor = Colors.blue,
        iconContainerColor = const Color(0xFF424242),
        iconContainerBorderColor = const Color(0xFF616161),
        iconSize = 20,
        orbitPathColor = const Color(0x1AFFFFFF),
        centerSize = 70,
        centerBlurSigma = 5,
        centerColor = const Color(0x26808080),
        centerWidget = null;

  /// Preset for light backgrounds.
  const OrbitStyle.light()
      : iconColor = Colors.indigo,
        iconContainerColor = const Color(0xFFF5F5F5),
        iconContainerBorderColor = const Color(0xFFE0E0E0),
        iconSize = 20,
        orbitPathColor = const Color(0x1A000000), // black 10 %
        centerSize = 70,
        centerBlurSigma = 5,
        centerColor = const Color(0x26000000), // black 15 %
        centerWidget = null;

  /// Returns a copy with the given fields replaced.
  OrbitStyle copyWith({
    Color? iconColor,
    Color? iconContainerColor,
    Color? iconContainerBorderColor,
    double? iconSize,
    Color? orbitPathColor,
    double? centerSize,
    double? centerBlurSigma,
    Color? centerColor,
    Widget? centerWidget,
  }) {
    return OrbitStyle(
      iconColor: iconColor ?? this.iconColor,
      iconContainerColor: iconContainerColor ?? this.iconContainerColor,
      iconContainerBorderColor:
          iconContainerBorderColor ?? this.iconContainerBorderColor,
      iconSize: iconSize ?? this.iconSize,
      orbitPathColor: orbitPathColor ?? this.orbitPathColor,
      centerSize: centerSize ?? this.centerSize,
      centerBlurSigma: centerBlurSigma ?? this.centerBlurSigma,
      centerColor: centerColor ?? this.centerColor,
      centerWidget: centerWidget ?? this.centerWidget,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// OrbitConfig — reactive behavioural settings
// ═══════════════════════════════════════════════════════════════════════════

/// Reactive configuration for [OrbitingIcons].
///
/// Implements [ChangeNotifier] so it can drive [AnimatedBuilder] or
/// [ListenableBuilder] directly.
///
/// ```dart
/// final config = OrbitConfig();
/// config.duration = 6.0;  // triggers rebuild automatically
/// ```
class OrbitConfig extends ChangeNotifier {
  bool _reverse;
  double _duration;
  bool _showPaths;

  OrbitConfig({
    bool reverse = true,
    double duration = 10.0,
    bool showPaths = true,
  })  : _reverse = reverse,
        _duration = duration,
        _showPaths = showPaths;

  bool get reverse => _reverse;
  double get duration => _duration;
  bool get showPaths => _showPaths;

  set reverse(bool value) {
    _reverse = value;
    notifyListeners();
  }

  set duration(double value) {
    _duration = value;
    notifyListeners();
  }

  set showPaths(bool value) {
    _showPaths = value;
    notifyListeners();
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// OrbitingIconsWithControls — convenience wrapper
// ═══════════════════════════════════════════════════════════════════════════

/// Owns an [OrbitConfig] internally and rebuilds [OrbitingIcons] whenever
/// any config property changes.
///
/// For programmatic control, create your own [OrbitConfig] and drive
/// [OrbitingIcons] yourself.
class OrbitingIconsWithControls extends StatelessWidget {
  final OrbitConfig config;

  /// Visual style.  Defaults to [OrbitStyle.dark].
  final OrbitStyle style;

  OrbitingIconsWithControls({
    super.key,
    OrbitStyle? style,
  })  : config = OrbitConfig(),
        style = style ?? const OrbitStyle.dark();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: config,
      builder: (context, child) {
        return OrbitingIcons(
          reverse: config.reverse,
          duration: config.duration,
          showPaths: config.showPaths,
          style: style,
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// OrbitingIcons — main widget
// ═══════════════════════════════════════════════════════════════════════════

/// Two orbiting icon rings with a frosted-glass blur circle at the center.
///
/// ### Zero-config (works out of the box)
/// ```dart
/// OrbitingIcons()
/// ```
///
/// ### Dark / light presets
/// ```dart
/// OrbitingIcons(style: OrbitStyle.dark())
/// OrbitingIcons(style: OrbitStyle.light())
/// ```
///
/// ### Full customization
/// ```dart
/// OrbitingIcons(
///   reverse: false,
///   duration: 6.0,
///   showPaths: false,
///   leftIcons:  [Icons.flutter_dash, Icons.bolt, Icons.star],
///   rightIcons: [Icons.rocket_launch, Icons.wifi, Icons.favorite],
///   style: OrbitStyle(
///     iconColor: Colors.amber,
///     iconContainerColor: Colors.amber.withValues(alpha: 0.15),
///     centerBlurSigma: 10,
///     centerColor: Colors.amber.withValues(alpha: 0.2),
///     centerWidget: Icon(Icons.bolt, color: Colors.amber, size: 28),
///   ),
/// )
/// ```
///
/// ### Custom widgets instead of icons
/// ```dart
/// OrbitingIcons(
///   leftWidgets: [
///     CircleAvatar(backgroundImage: NetworkImage(url)),
///     FlutterLogo(size: 24),
///   ],
///   rightWidgets: [
///     Text('🚀', style: TextStyle(fontSize: 20)),
///     Text('⭐', style: TextStyle(fontSize: 20)),
///   ],
/// )
/// ```
class OrbitingIcons extends StatelessWidget {
  /// When `true` the left ring goes counter-clockwise and the right clockwise.
  final bool reverse;

  /// Seconds per full orbit rotation.
  final double duration;

  /// Show faint circular guide lines for each orbit.
  final bool showPaths;

  /// Visual style — colors, blur, center widget, etc.
  final OrbitStyle style;

  // ── Icon / widget slots ──────────────────────────────────────────────────

  /// Custom widgets for the left ring.
  /// Takes priority over [leftIcons].  Rendered as-is (no container added).
  final List<Widget>? leftWidgets;

  /// Custom widgets for the right ring.
  /// Takes priority over [rightIcons].  Rendered as-is (no container added).
  final List<Widget>? rightWidgets;

  /// Icon data for the left ring, auto-wrapped in a styled circle.
  /// Ignored when [leftWidgets] is provided.
  /// Defaults to [Icons.star], [Icons.favorite], [Icons.ac_unit].
  final List<IconData>? leftIcons;

  /// Icon data for the right ring, auto-wrapped in a styled circle.
  /// Ignored when [rightWidgets] is provided.
  /// Defaults to [Icons.settings], [Icons.cloud], [Icons.engineering].
  final List<IconData>? rightIcons;

  const OrbitingIcons({
    super.key,
    this.reverse = true,
    this.duration = 10.0,
    this.showPaths = true,
    this.style = const OrbitStyle.dark(),
    this.leftWidgets,
    this.rightWidgets,
    this.leftIcons,
    this.rightIcons,
  });

  @override
  Widget build(BuildContext context) {
    // leftWidgets beats leftIcons beats defaults
    final left = leftWidgets ??
        (leftIcons ?? [Icons.star, Icons.favorite, Icons.ac_unit])
            .map(_buildIcon)
            .toList();

    final right = rightWidgets ??
        (rightIcons ?? [Icons.settings, Icons.cloud, Icons.engineering])
            .map(_buildIcon)
            .toList();

    // Whether to auto-wrap orbit items in a styled container
    final wrapLeft = leftWidgets == null;
    final wrapRight = rightWidgets == null;

    return SizedBox(
      width: 350,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Left orbit
          Positioned(
            left: 40,
            child: OrbitingCircle(
              duration: duration,
              radius: 60,
              showPath: showPaths,
              clockwise: !reverse,
              icons: left,
              style: style,
              wrapInContainer: wrapLeft,
            ),
          ),
          // Right orbit
          Positioned(
            right: 40,
            child: OrbitingCircle(
              duration: duration,
              radius: 60,
              showPath: showPaths,
              clockwise: reverse,
              icons: right,
              style: style,
              wrapInContainer: wrapRight,
            ),
          ),
          // Center frosted-glass circle
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: style.centerBlurSigma,
                      sigmaY: style.centerBlurSigma,
                    ),
                    child: Container(
                      width: style.centerSize,
                      height: style.centerSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: style.centerColor,
                      ),
                    ),
                  ),
                ),
                ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: style.centerBlurSigma,
                      sigmaY: style.centerBlurSigma,
                    ),
                    child: style.centerWidget != null
                        ? SizedBox(
                            width: style.centerSize * 0.5,
                            height: style.centerSize * 0.5,
                            child: Center(child: style.centerWidget),
                          )
                        : CustomPaint(
                            size: Size(style.centerSize * 0.5,
                                style.centerSize * 0.5),
                            painter: ChevronPainter(
                              color: style.iconColor.withValues(alpha: 0.6),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(IconData icon) {
    return Icon(icon, size: style.iconSize, color: style.iconColor);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// OrbitingCircle
// ═══════════════════════════════════════════════════════════════════════════

/// A ring of widgets that orbit around a center point.
class OrbitingCircle extends StatelessWidget {
  final double duration;
  final double radius;
  final bool showPath;
  final bool clockwise;
  final List<Widget> icons;
  final OrbitStyle style;

  /// When `true` each item is wrapped in a styled container circle.
  /// Set to `false` when items are fully custom widgets.
  final bool wrapInContainer;

  const OrbitingCircle({
    super.key,
    required this.duration,
    required this.radius,
    required this.showPath,
    required this.clockwise,
    required this.icons,
    this.style = const OrbitStyle.dark(),
    this.wrapInContainer = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: radius * 2,
      height: radius * 2,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (showPath) _buildPath(),
          ...icons.asMap().entries.map((entry) {
            return SingleOrbitingCircle(
              duration: duration,
              delay: duration / icons.length * entry.key,
              radius: radius,
              moveClockwise: clockwise,
              style: style,
              wrapInContainer: wrapInContainer,
              child: entry.value,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPath() {
    return Center(
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: style.orbitPathColor, width: 1),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SingleOrbitingCircle
// ═══════════════════════════════════════════════════════════════════════════

/// A single item continuously orbiting a center point.
class SingleOrbitingCircle extends StatefulWidget {
  final double duration;
  final double delay;
  final double radius;
  final bool moveClockwise;
  final OrbitStyle style;
  final bool wrapInContainer;
  final Widget? child;

  const SingleOrbitingCircle({
    super.key,
    required this.duration,
    required this.delay,
    required this.radius,
    required this.moveClockwise,
    this.style = const OrbitStyle.dark(),
    this.wrapInContainer = true,
    this.child,
  });

  @override
  State<SingleOrbitingCircle> createState() => _SingleOrbitingCircleState();
}

class _SingleOrbitingCircleState extends State<SingleOrbitingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: widget.duration.toInt()),
      vsync: this,
    );
    Future.delayed(Duration(milliseconds: (widget.delay * 1000).toInt()), () {
      if (mounted) _controller.repeat();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final angle = widget.moveClockwise
            ? -_controller.value * 2 * math.pi
            : _controller.value * 2 * math.pi;

        final positioned = Transform.translate(
          offset: Offset(
            widget.radius + (widget.radius * math.cos(angle)) - 18,
            widget.radius + (widget.radius * math.sin(angle)) - 18,
          ),
          child: widget.wrapInContainer
              ? Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.style.iconContainerColor,
                    border: Border.all(
                      color: widget.style.iconContainerBorderColor,
                      width: 1,
                    ),
                  ),
                  child: Center(child: widget.child),
                )
              : SizedBox(
                  width: 36,
                  height: 36,
                  child: Center(child: widget.child),
                ),
        );

        return positioned;
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ChevronPainter
// ═══════════════════════════════════════════════════════════════════════════

/// Paints a downward-pointing chevron inside the center circle.
class ChevronPainter extends CustomPainter {
  final Color color;

  const ChevronPainter({this.color = Colors.blue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.5);

    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.3, size.height * 0.4)
        ..lineTo(size.width * 0.5, size.height * 0.6)
        ..lineTo(size.width * 0.7, size.height * 0.4),
      paint,
    );
  }

  @override
  bool shouldRepaint(ChevronPainter oldDelegate) => oldDelegate.color != color;
}
