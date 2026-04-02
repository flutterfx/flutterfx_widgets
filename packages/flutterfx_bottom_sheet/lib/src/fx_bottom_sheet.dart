import 'package:flutter/material.dart';

/// Immutable style configuration for [FxBottomSheet].
///
/// Use [FxBottomSheetStyle.light] or [FxBottomSheetStyle.dark] for presets,
/// or construct your own and use [copyWith] to tweak individual values.
///
/// ```dart
/// FxBottomSheet(
///   style: FxBottomSheetStyle.dark().copyWith(topBorderRadius: 24),
///   ...
/// )
/// ```
class FxBottomSheetStyle {
  /// Background color of the sheet panel.
  final Color backgroundColor;

  /// Color of the dimming barrier behind the sheet.
  final Color barrierColor;

  /// Color of the drag handle pill.
  final Color handleColor;

  /// Width of the drag handle pill.
  final double handleWidth;

  /// Height of the drag handle pill.
  final double handleHeight;

  /// Corner radius of the top edge of the sheet.
  final double topBorderRadius;

  /// Shadow applied to the sheet panel.
  final List<BoxShadow> boxShadow;

  /// How much the main content scales down when the sheet is fully open.
  /// 1.0 = no scale, 0.85 = scales to 85%.
  final double mainContentScale;

  /// How far (in logical pixels) the main content slides upward when the
  /// sheet is fully open.
  final double mainContentSlide;

  const FxBottomSheetStyle({
    required this.backgroundColor,
    required this.barrierColor,
    required this.handleColor,
    this.handleWidth = 40,
    this.handleHeight = 4,
    this.topBorderRadius = 16,
    required this.boxShadow,
    this.mainContentScale = 0.85,
    this.mainContentSlide = 24,
  });

  /// A light-themed preset — white sheet on a light surface.
  factory FxBottomSheetStyle.light() => FxBottomSheetStyle(
        backgroundColor: Colors.white,
        barrierColor: Colors.black.withValues(alpha: 0.54),
        handleColor: const Color(0xFFDDDDDD),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, -3),
          ),
        ],
      );

  /// A dark-themed preset — dark sheet on a dark surface.
  factory FxBottomSheetStyle.dark() => FxBottomSheetStyle(
        backgroundColor: const Color(0xFF1C1C1E),
        barrierColor: Colors.black.withValues(alpha: 0.7),
        handleColor: const Color(0xFF48484A),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.40),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, -4),
          ),
        ],
      );

  /// Returns a copy of this style with the given fields replaced.
  FxBottomSheetStyle copyWith({
    Color? backgroundColor,
    Color? barrierColor,
    Color? handleColor,
    double? handleWidth,
    double? handleHeight,
    double? topBorderRadius,
    List<BoxShadow>? boxShadow,
    double? mainContentScale,
    double? mainContentSlide,
  }) {
    return FxBottomSheetStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      barrierColor: barrierColor ?? this.barrierColor,
      handleColor: handleColor ?? this.handleColor,
      handleWidth: handleWidth ?? this.handleWidth,
      handleHeight: handleHeight ?? this.handleHeight,
      topBorderRadius: topBorderRadius ?? this.topBorderRadius,
      boxShadow: boxShadow ?? this.boxShadow,
      mainContentScale: mainContentScale ?? this.mainContentScale,
      mainContentSlide: mainContentSlide ?? this.mainContentSlide,
    );
  }
}

/// Programmatic controller for [FxBottomSheet].
///
/// Create one instance, pass it to [FxBottomSheet.controller], then call
/// [open], [close], or [toggle] from anywhere in your widget tree.
///
/// ```dart
/// final _sheetController = FxBottomSheetController();
///
/// // later…
/// ElevatedButton(
///   onPressed: _sheetController.toggle,
///   child: const Text('Toggle sheet'),
/// )
/// ```
///
/// Dispose the controller when its owner widget is disposed.
class FxBottomSheetController {
  AnimationController? _animationController;

  void _attach(AnimationController controller) {
    _animationController = controller;
  }

  /// Whether the sheet is currently fully open.
  bool get isOpen => _animationController?.value == 1.0;

  /// Slide the sheet fully open.
  void open() => _animationController?.forward();

  /// Slide the sheet fully closed.
  void close() => _animationController?.reverse();

  /// Toggle between open and closed.
  void toggle() => isOpen ? close() : open();

  /// Release internal references. Call this in your widget's [dispose].
  void dispose() {
    _animationController = null;
  }
}

/// A bottom sheet widget with smooth scale-and-slide entrance animation,
/// drag-to-dismiss support, and a fully customizable [FxBottomSheetStyle].
///
/// ## Basic usage
///
/// ```dart
/// final _controller = FxBottomSheetController();
///
/// @override
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: SafeArea(
///       bottom: false,
///       child: FxBottomSheet(
///         controller: _controller,
///         mainContent: YourMainScreen(),
///         drawerContent: YourSheetContent(),
///       ),
///     ),
///   );
/// }
/// ```
///
/// ## Custom style
///
/// ```dart
/// FxBottomSheet(
///   style: FxBottomSheetStyle.dark().copyWith(topBorderRadius: 28),
///   maxHeight: 0.75,
///   ...
/// )
/// ```
class FxBottomSheet extends StatefulWidget {
  /// The content rendered behind / under the sheet (your main screen).
  final Widget mainContent;

  /// The content rendered inside the sheet panel.
  final Widget drawerContent;

  /// Fractional height when fully closed (0.0 = hidden).
  final double minHeight;

  /// Fractional height when fully open (0.90 = 90% of parent height).
  final double maxHeight;

  /// Duration of the open/close animation.
  final Duration animationDuration;

  /// Visual style of the sheet. Defaults to [FxBottomSheetStyle.light].
  final FxBottomSheetStyle style;

  /// Optional external controller for programmatic open/close/toggle.
  final FxBottomSheetController? controller;

  const FxBottomSheet({
    super.key,
    required this.mainContent,
    required this.drawerContent,
    this.controller,
    this.minHeight = 0.0,
    this.maxHeight = 0.90,
    this.animationDuration = const Duration(milliseconds: 300),
    FxBottomSheetStyle? style,
  }) : style = style ?? const _LightStylePlaceholder();

  @override
  State<FxBottomSheet> createState() => _FxBottomSheetState();
}

// Internal workaround so `style` has a const default without calling a factory.
class _LightStylePlaceholder extends FxBottomSheetStyle {
  const _LightStylePlaceholder()
      : super(
          backgroundColor: Colors.white,
          barrierColor: const Color(0x8A000000),
          handleColor: const Color(0xFFDDDDDD),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 12,
              spreadRadius: 0,
              offset: Offset(0, -3),
            ),
          ],
        );
}

class _FxBottomSheetState extends State<FxBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _drawerAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;

  bool _isDragging = false;
  double _dragStartPoint = 0.0;
  double _dragStartValue = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    widget.controller?._attach(_controller);

    const curve = Curves.easeInOutCubic;

    _drawerAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: curve,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.style.mainContentScale,
    ).animate(CurvedAnimation(parent: _controller, curve: curve));

    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: widget.style.mainContentSlide,
    ).animate(CurvedAnimation(parent: _controller, curve: curve));
  }

  @override
  void didUpdateWidget(FxBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animationDuration != widget.animationDuration) {
      _controller.duration = widget.animationDuration;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final maxDrawerHeight = constraints.maxHeight * widget.maxHeight;
      final style = widget.style;

      return Stack(
        children: [
          // ── Main content (scales + slides up as sheet opens) ──────────
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Transform.translate(
                  offset: Offset(0, -_slideAnimation.value),
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(_drawerAnimation.value * 16.0),
                    ),
                    child: widget.mainContent,
                  ),
                ),
              );
            },
          ),

          // ── Dimming barrier ───────────────────────────────────────────
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              if (_controller.value == 0) return const SizedBox.shrink();
              return GestureDetector(
                onTap: _controller.reverse,
                child: Container(
                  color: style.barrierColor
                      .withValues(alpha: _controller.value * 0.7),
                ),
              );
            },
          ),

          // ── Sheet panel ───────────────────────────────────────────────
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: maxDrawerHeight,
                child: Transform.translate(
                  offset:
                      Offset(0, maxDrawerHeight * (1 - _drawerAnimation.value)),
                  child: GestureDetector(
                    onVerticalDragStart: _handleDragStart,
                    onVerticalDragUpdate: (d) =>
                        _handleDragUpdate(d, maxDrawerHeight),
                    onVerticalDragEnd: _handleDragEnd,
                    child: Container(
                      decoration: BoxDecoration(
                        color: style.backgroundColor,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(style.topBorderRadius),
                        ),
                        boxShadow: style.boxShadow,
                      ),
                      child: Column(
                        children: [
                          // Drag handle
                          SizedBox(
                            height: 28,
                            child: Center(
                              child: Container(
                                width: style.handleWidth,
                                height: style.handleHeight,
                                decoration: BoxDecoration(
                                  color: style.handleColor,
                                  borderRadius: BorderRadius.circular(
                                      style.handleHeight / 2),
                                ),
                              ),
                            ),
                          ),
                          // Sheet content
                          Expanded(child: widget.drawerContent),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      );
    });
  }

  void _handleDragStart(DragStartDetails details) {
    _isDragging = true;
    _dragStartPoint = details.globalPosition.dy;
    _dragStartValue = _controller.value;
  }

  void _handleDragUpdate(DragUpdateDetails details, double maxDrawerHeight) {
    if (!_isDragging) return;
    final delta = _dragStartPoint - details.globalPosition.dy;
    _controller.value =
        (_dragStartValue + delta / maxDrawerHeight).clamp(0.0, 1.0);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_isDragging) return;
    _isDragging = false;

    final velocity = details.primaryVelocity ?? 0;
    if (velocity > 200) {
      _controller.reverse();
    } else if (velocity < -200) {
      _controller.forward();
    } else {
      _controller.value > 0.5 ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    widget.controller?.dispose();
    _controller.dispose();
    super.dispose();
  }
}
