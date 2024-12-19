import 'package:flutter/material.dart';
import 'package:fx_2_folder/stacked-cards/stacked_card.dart';

class DisclosureConfig {
  final Duration expandDuration;
  final Duration collapseDuration;
  final Curve expandCurve;
  final Curve collapseCurve;

  const DisclosureConfig({
    this.expandDuration = const Duration(milliseconds: 200),
    this.collapseDuration = const Duration(milliseconds: 200),
    this.expandCurve = Curves.easeOut,
    this.collapseCurve = Curves.easeIn,
  });
}

class DisclosureState extends InheritedWidget {
  final bool isExpanded;
  final VoidCallback toggleExpansion;

  const DisclosureState({
    super.key,
    required this.isExpanded,
    required this.toggleExpansion,
    required super.child,
  });

  static DisclosureState? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DisclosureState>();
  }

  @override
  bool updateShouldNotify(DisclosureState oldWidget) {
    return isExpanded != oldWidget.isExpanded;
  }
}

/// Main Disclosure widget that manages state and animations
class Disclosure extends StatefulWidget {
  final Widget? trigger;
  final Widget content;
  final bool initiallyExpanded;
  final ValueChanged<bool>? onExpandedChanged;
  final DisclosureConfig? config;
  final BoxDecoration? decoration;
  final EdgeInsetsGeometry padding;

  const Disclosure({
    super.key,
    this.trigger,
    required this.content,
    this.initiallyExpanded = false,
    this.onExpandedChanged,
    this.config,
    this.decoration,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  State<Disclosure> createState() => _DisclosureState();
}

class _DisclosureState extends State<Disclosure>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _heightFactor;
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration:
          widget.config?.expandDuration ?? const Duration(milliseconds: 200),
      reverseDuration:
          widget.config?.collapseDuration ?? const Duration(milliseconds: 200),
      vsync: this,
    );
    _heightFactor = _controller.drive(CurveTween(
      curve: _isExpanded
          ? (widget.config?.expandCurve ?? Curves.easeOut)
          : (widget.config?.collapseCurve ?? Curves.easeIn),
    ));

    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      widget.onExpandedChanged?.call(_isExpanded);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DisclosureState(
      isExpanded: _isExpanded,
      toggleExpansion: _handleTap,
      child: Container(
        decoration: widget.decoration ??
            BoxDecoration(
              border: Border.all(color: theme.dividerColor),
              borderRadius: BorderRadius.circular(8),
            ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.trigger != null)
              InkWell(
                onTap: _handleTap,
                child: Padding(
                  padding: widget.padding,
                  child: Row(
                    children: [
                      Expanded(child: widget.trigger!),
                      AnimatedRotation(
                        turns: _isExpanded ? 0.5 : 0,
                        duration: _isExpanded
                            ? (widget.config?.expandDuration ??
                                const Duration(milliseconds: 200))
                            : (widget.config?.collapseDuration ??
                                const Duration(milliseconds: 200)),
                        child: const Icon(Icons.keyboard_arrow_down),
                      ),
                    ],
                  ),
                ),
              ),
            ClipRect(
              child: AnimatedBuilder(
                animation: _controller.view,
                builder: (context, child) {
                  return Align(
                    heightFactor: _heightFactor.value,
                    child: child,
                  );
                },
                child: Padding(
                  padding: widget.padding,
                  child: widget.content,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DisclosureTrigger extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const DisclosureTrigger({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final state = DisclosureState.of(context);
    if (state == null) {
      throw FlutterError(
        'DisclosureTrigger must be used within a Disclosure widget.',
      );
    }

    return InkWell(
      onTap: state.toggleExpansion,
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            Expanded(child: child),
            AnimatedRotation(
              turns: state.isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(Icons.keyboard_arrow_down),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpandableWidgetDemo extends StatefulWidget {
  const ExpandableWidgetDemo({Key? key}) : super(key: key);

  @override
  State<ExpandableWidgetDemo> createState() => _ExpandableWidgetDemoState();
}

class _ExpandableWidgetDemoState extends State<ExpandableWidgetDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Grid background
          CustomPaint(
            painter: GridPatternPainter(isDarkMode: true),
            size: Size.infinite,
          ),
          // Content at the top
          Column(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Disclosure(
                    trigger: const Text(
                      'Show more',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    config: const DisclosureConfig(
                      expandDuration: Duration(milliseconds: 200),
                      collapseDuration: Duration(milliseconds: 200),
                      expandCurve: Curves.easeOut,
                      collapseCurve: Curves.easeIn,
                    ),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'This example demonstrates how you can use the Disclosure component.',
                          style: TextStyle(fontSize: 14),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '''
void main() {
  runApp(
    Disclosure(
      trigger: Text('Show more'),
      content: Text('Content here'),
    ),
  );
}''',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
