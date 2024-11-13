import 'package:flutter/material.dart';

class CustomDrawerController {
  AnimationController? _animationController;
  bool _isInitialized = false;

  void attach(AnimationController controller) {
    _animationController = controller;
    _isInitialized = true;
  }

  bool get isOpen => _animationController?.value == 1.0;

  void open() {
    if (_isInitialized) {
      _animationController?.forward();
    }
  }

  void close() {
    if (_isInitialized) {
      _animationController?.reverse();
    }
  }

  void toggle() {
    if (_isInitialized) {
      if (isOpen) {
        close();
      } else {
        open();
      }
    }
  }

  void dispose() {
    _animationController = null;
    _isInitialized = false;
  }
}

class CustomDrawer extends StatefulWidget {
  final Widget mainContent;
  final Widget drawerContent;
  final double minHeight;
  final double maxHeight;
  final Duration animationDuration;
  final Color backgroundColor;
  final Color barrierColor;
  final CustomDrawerController? controller;

  const CustomDrawer({
    super.key,
    required this.mainContent,
    required this.drawerContent,
    this.controller,
    this.minHeight = 0.0,
    this.maxHeight = 0.90,
    this.animationDuration =
        const Duration(milliseconds: 300), // Faster animation
    this.backgroundColor = Colors.white,
    this.barrierColor = Colors.black54,
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer>
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

    widget.controller?.attach(_controller);

    // Enhanced easing curve for smoother animation
    const Curve curve = Curves.easeInOutCubic;

    _drawerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: curve));

    // Increased scale effect for better depth perception
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.85, // More pronounced scale effect
    ).animate(CurvedAnimation(parent: _controller, curve: curve));

    // Enhanced slide effect
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 24.0, // More pronounced slide
    ).animate(CurvedAnimation(parent: _controller, curve: curve));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // Calculate maxDrawerHeight based on parent width
      final maxDrawerHeight = constraints.maxHeight * widget.maxHeight;

      return Stack(
        children: [
          // Main content with enhanced scale, slide and border radius animations
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Transform.translate(
                  offset: Offset(0, -_slideAnimation.value),
                  child: ClipRRect(
                    // Animate border radius based on drawer animation
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(_drawerAnimation.value * 16.0),
                    ),
                    child: widget.mainContent,
                  ),
                ),
              );
            },
          ),

          // Enhanced barrier with fade animation
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Visibility(
                visible: _controller.value > 0,
                child: GestureDetector(
                  onTap: () => _controller.reverse(),
                  child: Container(
                    color: widget.barrierColor
                        .withOpacity(_controller.value * 0.7),
                  ),
                ),
              );
            },
          ),

          // Enhanced drawer with improved handle and shadow
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: maxDrawerHeight,
                child: Transform.translate(
                  offset: Offset(
                      0.0, maxDrawerHeight * (1 - _drawerAnimation.value)),
                  child: GestureDetector(
                    onVerticalDragStart: _handleDragStart,
                    onVerticalDragUpdate: (details) =>
                        _handleDragUpdate(details, maxDrawerHeight),
                    onVerticalDragEnd: _handleDragEnd,
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.backgroundColor,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16), // Increased radius
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 0,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Enhanced drag handle
                          Container(
                            height: 24, // Reduced height
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            alignment: Alignment.center,
                            child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          // Drawer content
                          Expanded(
                            child: widget.drawerContent,
                          ),
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

  // Drag handlers remain the same as in your original code
  void _handleDragStart(DragStartDetails details) {
    _isDragging = true;
    _dragStartPoint = details.globalPosition.dy;
    _dragStartValue = _controller.value;
  }

  void _handleDragUpdate(DragUpdateDetails details, double maxDrawerHeight) {
    if (!_isDragging) return;

    final dragDistance = _dragStartPoint - details.globalPosition.dy;
    // Use maxDrawerHeight instead of screen height for calculations
    final newValue =
        (_dragStartValue + dragDistance / maxDrawerHeight).clamp(0.0, 1.0);
    _controller.value = newValue;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_isDragging) return;

    _isDragging = false;
    final velocity = details.primaryVelocity ?? 0;

    if (velocity > 0) {
      // Dragging down
      _controller.reverse();
    } else if (velocity < 0) {
      // Dragging up
      _controller.forward();
    } else {
      // No velocity - snap to nearest end
      if (_controller.value > 0.5) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    widget.controller?.dispose();
    _controller.dispose();
    super.dispose();
  }
}
