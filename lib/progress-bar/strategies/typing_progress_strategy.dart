import 'package:flutter/material.dart';
import 'package:fx_2_folder/progress-bar/progress_bar.dart';

class TypingProgressStrategy implements ProgressAnimationStrategy {
  @override
  Widget buildProgressWidget({
    required double progress,
    required Animation<double> animation,
    required BuildContext context,
    required ProgressStyle style,
  }) {
    return _TypingProgressWidget(
      progress: progress,
      animation: animation,
      style: style,
    );
  }
}

class _TypingProgressWidget extends StatefulWidget {
  final double progress;
  final Animation<double> animation;
  final ProgressStyle style;

  const _TypingProgressWidget({
    Key? key,
    required this.progress,
    required this.animation,
    required this.style,
  }) : super(key: key);

  @override
  State<_TypingProgressWidget> createState() => _TypingProgressWidgetState();
}

class _TypingProgressWidgetState extends State<_TypingProgressWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _cursorController;
  late String _currentText = '';
  late int _visibleChars = 0;

  @override
  void initState() {
    super.initState();

    // Setup cursor blink animation
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    // Add listener to animation
    widget.animation.addListener(_onAnimationUpdate);
  }

  void _onAnimationUpdate() {
    if (!mounted) return;

    setState(() {
      _currentText = _getProgressText(widget.animation.value);
      _visibleChars = _currentText.length;
    });
  }

  String _getProgressText(double progress) {
    return '${(progress * 100).toInt()}%';
  }

  @override
  void dispose() {
    widget.animation.removeListener(_onAnimationUpdate);
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.style.width,
      height: widget.style.height,
      padding: widget.style.padding,
      decoration: BoxDecoration(
        color: widget.style.backgroundColor,
        borderRadius: widget.style.borderRadius,
      ),
      child: Stack(
        children: [
          // Background progress
          FractionallySizedBox(
            widthFactor: widget.animation.value,
            child: Container(
              decoration: BoxDecoration(
                color: widget.style.primaryColor.withOpacity(0.2),
                borderRadius: widget.style.borderRadius,
              ),
            ),
          ),

          // Typing text
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _currentText,
                  style: TextStyle(
                    color: widget.style.primaryColor,
                    fontSize: widget.style.height * 0.5,
                    fontFamily: 'Courier',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Blinking cursor
                AnimatedBuilder(
                  animation: _cursorController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _cursorController.value,
                      child: Text(
                        '|',
                        style: TextStyle(
                          color: widget.style.primaryColor,
                          fontSize: widget.style.height * 0.5,
                          fontFamily: 'Courier',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
