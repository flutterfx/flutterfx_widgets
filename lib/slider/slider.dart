// work_life_slider.dart
import 'package:flutter/material.dart';

/// A custom slider widget that visualizes work-life balance percentage
class WorkLifeSlider extends StatefulWidget {
  final double value;
  final ValueChanged<double>? onChanged;

  const WorkLifeSlider({
    super.key,
    this.value = 50.0,
    this.onChanged,
  });

  @override
  State<WorkLifeSlider> createState() => _WorkLifeSliderState();
}

/// Styles for the Work-Life Slider
class _SliderStyles {
  static const backgroundColor = Color(0xFF0A0A0A);
  static const workColor = Color.fromARGB(255, 0, 123, 255);
  static const lifeColor = Color.fromARGB(255, 132, 255, 0);
  static const activeIndicatorColor = Color(0xFFF8F8FF);
  static const inactiveIndicatorColor = Color(0xFFA7A7A7);

  static const textStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'monospace',
  );

  static const sliderHeight = 120.0;
  static const indicatorWidth = 6.0;
  static const borderRadius = 4.0;
  static const horizontalPadding = 16.0;

  static const expandedTrackHeight = 90.0;
  static const collapsedTrackHeight = 60.0;
  static const tooltipHeight = 40.0;

  static const animationDuration = Duration(milliseconds: 300);
  static const animationCurve = Curves.easeOut;
}

class _WorkLifeSliderState extends State<WorkLifeSlider> {
  late double _value;
  bool _isDragging = false;

  bool get _isBalanced => _value > 38 && _value < 67;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  void _updateValue(double newValue) {
    final clampedValue = newValue.clamp(0.0, 100.0);
    setState(() => _value = clampedValue);
    widget.onChanged?.call(clampedValue);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Center(
        child: Container(
          color: _SliderStyles.backgroundColor,
          child: SizedBox(
            width: constraints.maxWidth,
            height: _SliderStyles.sliderHeight,
            child: Stack(
              children: [
                _buildTooltip(),
                _buildTrackAndIndicator(constraints.maxWidth),
                _buildTouchArea(constraints.maxWidth),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTooltip() {
    return AnimatedPositioned(
      duration: _SliderStyles.animationDuration,
      curve: _SliderStyles.animationCurve,
      top: _isBalanced ? 60 : 0,
      left: 0,
      right: 0,
      child: SizedBox(
        height: _SliderStyles.tooltipHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildPercentageLabel(
              'WORK',
              _value.round(),
              _SliderStyles.workColor,
              padding:
                  const EdgeInsets.only(left: _SliderStyles.horizontalPadding),
            ),
            _buildPercentageLabel(
              'LIFE',
              (100 - _value).round(),
              _SliderStyles.lifeColor,
              padding:
                  const EdgeInsets.only(right: _SliderStyles.horizontalPadding),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPercentageLabel(
    String label,
    int percentage,
    Color color, {
    EdgeInsets padding = EdgeInsets.zero,
  }) {
    return Padding(
      padding: padding,
      child: Text(
        '$label $percentage%',
        style: _SliderStyles.textStyle.copyWith(color: color),
      ),
    );
  }

  Widget _buildTrackAndIndicator(double width) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: _SliderStyles.animationDuration,
        curve: _SliderStyles.animationCurve,
        height: _isBalanced
            ? _SliderStyles.expandedTrackHeight
            : _SliderStyles.collapsedTrackHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _buildTrackSection(
              left: 0,
              width: (width * _value / 100) - 8,
              color: _SliderStyles.workColor.withOpacity(0.25),
            ),
            _buildTrackSection(
              right: 0,
              width: (width * (100 - _value) / 100) - 8,
              color: _SliderStyles.lifeColor.withOpacity(0.37),
            ),
            _buildSliderIndicator(width),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackSection({
    double? left,
    double? right,
    required double width,
    required Color color,
  }) {
    return Positioned(
      left: left,
      right: right,
      top: 0,
      bottom: 0,
      width: width,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(_SliderStyles.borderRadius),
        ),
      ),
    );
  }

  Widget _buildSliderIndicator(double width) {
    return Positioned(
      left: (width * _value / 100) - 3,
      top: 5,
      bottom: 5,
      child: GestureDetector(
        onHorizontalDragStart: (_) => setState(() => _isDragging = true),
        onHorizontalDragEnd: (_) => setState(() => _isDragging = false),
        onHorizontalDragUpdate: (details) {
          _updateValue(_value + (details.delta.dx / width * 100));
        },
        child: Container(
          width: _SliderStyles.indicatorWidth,
          decoration: BoxDecoration(
            color: _isDragging
                ? _SliderStyles.activeIndicatorColor
                : _SliderStyles.inactiveIndicatorColor,
            borderRadius: BorderRadius.circular(_SliderStyles.borderRadius),
          ),
        ),
      ),
    );
  }

  Widget _buildTouchArea(double width) {
    return Positioned.fill(
      child: GestureDetector(
        onTapUp: (details) {
          _updateValue(details.localPosition.dx / width * 100);
        },
        onHorizontalDragStart: (_) => setState(() => _isDragging = true),
        onHorizontalDragEnd: (_) => setState(() => _isDragging = false),
        onHorizontalDragUpdate: (details) {
          _updateValue(_value + (details.delta.dx / width * 100));
        },
      ),
    );
  }
}
