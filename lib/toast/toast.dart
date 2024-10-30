// toast_service.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fx_2_folder/toast/animated_stack_widget.dart';

class Toast {
  final String message;
  final Duration duration;
  final DateTime createdAt;
  final String id;
  Timer? _timer;

  Toast({
    required this.message,
    this.duration = const Duration(milliseconds: 4000),
  })  : createdAt = DateTime.now(),
        id = DateTime.now().microsecondsSinceEpoch.toString();
}

class ToastService extends ChangeNotifier {
  static final ToastService _instance = ToastService._internal();
  factory ToastService() => _instance;
  ToastService._internal();

  final List<Toast> _toasts = [];
  List<Toast> get toasts => _toasts;

  void show(String message, {Duration? duration}) {
    final toast = Toast(
      message: message,
      duration: duration ?? const Duration(milliseconds: 4000),
    );

    // Add new toast at the beginning of the list
    _toasts.insert(0, toast);
    notifyListeners();

    // If we have more than 3 toasts, remove the oldest one
    if (_toasts.length > 3) {
      final oldestToast = _toasts.removeLast();
      notifyListeners();
    }

    // Set up timer for auto-dismissal
    toast._timer = Timer(toast.duration, () {
      _toasts.remove(toast);
      notifyListeners();
    });
  }

  void dismiss(Toast toast) {
    toast._timer?.cancel();
    _toasts.remove(toast);
    notifyListeners();
  }
}

// toast_overlay.dart

class ToastOverlay extends StatelessWidget {
  const ToastOverlay({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        const ToastContainer(),
      ],
    );
  }
}

// toast_container.dart
class ToastContainer extends StatelessWidget {
  const ToastContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ToastService(),
      builder: (context, _) {
        final toasts = ToastService().toasts;
        const maxToasts = 3;
        final visibleToasts = toasts.take(maxToasts).toList();

        return Positioned(
          bottom: 32,
          right: 32,
          child: SizedBox(
            width: 356,
            height: 200,
            child: AnimatedStack(
              fit: StackFit.expand,
              clipBehavior: Clip.none,
              children: [
                // Render toasts in reverse order so newer toasts appear on top
                for (var i = visibleToasts.length - 1; i >= 0; i--)
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    key: ValueKey(visibleToasts[i].id),
                    child: Material(
                      color: Colors.transparent,
                      child: ToastItem(
                        toast: visibleToasts[i],
                        index: i,
                        total: visibleToasts.length,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// toast_item.dart
class ToastItem extends StatelessWidget {
  const ToastItem({
    super.key,
    required this.toast,
    required this.index,
    required this.total,
  });

  final Toast toast;
  final int index;
  final int total;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        // Scale and offset calculations remain the same
        // but now index 0 is the newest toast (front)
        final scale = 1.0 - (index * 0.15);
        final double top = -index * 10;
        final opacity = 1.0; //value * (1.0 - (index * 0.2));
        final z = -index * 100.0;

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // perspective
            ..translate(0.0, top, z)
            ..scale(scale),
          alignment: Alignment.topCenter,
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: Dismissible(
        key: Key(toast.id),
        direction: DismissDirection.horizontal,
        onDismissed: (_) => ToastService().dismiss(toast),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 16,
                offset: const Offset(0, 4),
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Text(
                  toast.message,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => ToastService().dismiss(toast),
                child: Icon(
                  Icons.close,
                  size: 16,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
