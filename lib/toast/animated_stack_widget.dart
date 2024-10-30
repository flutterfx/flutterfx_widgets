import 'package:flutter/material.dart';

class AnimatedStack extends StatefulWidget {
  final List<Widget> children;
  final Duration enterDuration;
  final Duration exitDuration;
  final Curve enterCurve;
  final Curve exitCurve;
  final StackFit fit;
  final Clip clipBehavior;

  const AnimatedStack({
    super.key,
    required this.children,
    this.enterDuration = const Duration(milliseconds: 200),
    this.exitDuration = const Duration(milliseconds: 150),
    this.enterCurve = Curves.easeOut,
    this.exitCurve = Curves.easeIn,
    this.fit = StackFit.loose,
    this.clipBehavior = Clip.hardEdge,
  });

  @override
  State<AnimatedStack> createState() => _AnimatedStackState();
}

class _AnimatedStackState extends State<AnimatedStack>
    with TickerProviderStateMixin {
  final List<_AnimatedStackChild> _entries = [];
  final Map<Key, _AnimatedStackChild> _entriesByKey = {};

  @override
  void initState() {
    super.initState();
    _updateChildren();
  }

  @override
  void didUpdateWidget(AnimatedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateChildren();
  }

  void _updateChildren() {
    final Set<Key> visitedKeys = {};
    final List<_AnimatedStackChild> newEntries = [];

    // Process new/existing children
    for (int i = 0; i < widget.children.length; i++) {
      final Widget child = widget.children[i];
      final Key? key = child.key;

      if (key == null) {
        throw FlutterError(
            'All children of AnimatedStack must have unique keys');
      }

      visitedKeys.add(key);

      if (_entriesByKey.containsKey(key)) {
        final _AnimatedStackChild existing = _entriesByKey[key]!;
        existing.widget = child;
        existing.targetOpacity = 1.0;
        newEntries.add(existing);
      } else {
        final entry = _AnimatedStackChild(
          key: key,
          widget: child,
          targetOpacity: 1.0,
          controller: AnimationController(
            duration: widget.enterDuration,
            vsync: this,
          )..forward(),
        );
        newEntries.add(entry);
        _entriesByKey[key] = entry;
      }
    }

    // Handle removed children
    for (final entry in _entries) {
      if (!visitedKeys.contains(entry.key)) {
        entry.targetOpacity = 0.0;
        entry.controller.duration = widget.exitDuration;
        entry.controller.reverse().then((_) {
          setState(() {
            _entriesByKey.remove(entry.key);
            newEntries.remove(entry);
          });
        });
      }
    }

    setState(() {
      _entries.clear();
      _entries.addAll(newEntries);
    });
  }

  @override
  void dispose() {
    for (final child in _entries) {
      child.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: widget.fit,
      clipBehavior: widget.clipBehavior,
      children: _entries.map((entry) {
        return AnimatedBuilder(
          animation: entry.controller,
          builder: (context, child) {
            final progress = entry.controller.value;
            final opacity = entry.targetOpacity == 1.0
                ? widget.enterCurve.transform(progress)
                : widget.exitCurve.transform(progress);

            return Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - progress)),
                child: child,
              ),
            );
          },
          child: entry.widget,
        );
      }).toList(),
    );
  }
}

class _AnimatedStackChild {
  final Key key;
  Widget widget;
  double targetOpacity;
  final AnimationController controller;

  _AnimatedStackChild({
    required this.key,
    required this.widget,
    required this.targetOpacity,
    required this.controller,
  });
}
