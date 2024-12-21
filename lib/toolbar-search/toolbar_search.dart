// toolbar_dynamic.dart

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fx_2_folder/stacked-cards/stacked_card.dart';
// toolbar_dynamic.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// toolbar_dynamic.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ToolbarDynamic extends StatefulWidget {
  const ToolbarDynamic({Key? key}) : super(key: key);

  @override
  State<ToolbarDynamic> createState() => _ToolbarDynamicState();
}

class _ToolbarDynamicState extends State<ToolbarDynamic>
    with SingleTickerProviderStateMixin {
  bool isOpen = false;
  final FocusNode _focusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _widthAnimation;

  // For slide animation
  final Tween<Offset> _slideTween = Tween<Offset>(
    begin: const Offset(0, 0),
    end: const Offset(1, 0),
  );

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _widthAnimation = Tween<double>(
      begin: 98.0,
      end: 400.0, // Increased width for search bar
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const SpringCurve(mass: 1.0, stiffness: 500.0, damping: 20.0),
      ),
    );

    // Handle click outside
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && isOpen) {
        _closeToolbar();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _openToolbar() {
    setState(() {
      isOpen = true;
    });
    _animationController.forward();
    _focusNode.requestFocus();
  }

  void _closeToolbar() {
    setState(() {
      isOpen = false;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      // Wrap with Stack
      children: [
        Positioned(
          bottom: 32,
          left: 16, // Added left padding
          child: AnimatedBuilder(
            animation: _widthAnimation,
            builder: (context, child) {
              return Container(
                width: _widthAnimation.value,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      // Collapsed content with slide animation
                      SlideTransition(
                        position: _slideTween.animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: Curves.easeInOut,
                          ),
                        ),
                        child: Opacity(
                          opacity: isOpen ? 0.0 : 1.0,
                          child: _buildCollapsedContent(),
                        ),
                      ),
                      // Expanded content with reverse slide animation
                      SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(-1, 0),
                          end: const Offset(0, 0),
                        ).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: Curves.easeInOut,
                          ),
                        ),
                        child: Opacity(
                          opacity: isOpen ? 1.0 : 0.0,
                          child: _buildExpandedContent(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCollapsedContent() {
    return Row(
      children: [
        CustomIconButton(
          icon: Icons.person_outline,
          onPressed: null,
          ariaLabel: 'User profile',
        ),
        const SizedBox(width: 8),
        CustomIconButton(
          icon: Icons.search,
          onPressed: _openToolbar,
          ariaLabel: 'Search notes',
        ),
      ],
    );
  }

  Widget _buildExpandedContent() {
    return Row(
      children: [
        CustomIconButton(
          icon: Icons.arrow_back,
          onPressed: _closeToolbar,
          ariaLabel: 'Back',
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: 'Search notes',
              hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String ariaLabel;

  const CustomIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    required this.ariaLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: ariaLabel,
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: onPressed == null
                  ? Colors.black.withOpacity(0.3)
                  : Colors.black.withOpacity(0.6),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom Spring Curve for more natural animation
class SpringCurve extends Curve {
  final double mass;
  final double stiffness;
  final double damping;

  const SpringCurve({
    required this.mass,
    required this.stiffness,
    required this.damping,
  });

  @override
  double transform(double t) {
    final omega = sqrt(stiffness / mass);
    final zeta = damping / (2 * sqrt(stiffness * mass));
    final omega_d = omega * sqrt(1.0 - zeta * zeta);

    return 1.0 -
        exp(-zeta * omega * t) *
            (cos(omega_d * t) + (zeta * omega / omega_d) * sin(omega_d * t));
  }
}

//Demo
class ToolbarSearchDemo extends StatefulWidget {
  const ToolbarSearchDemo({Key? key}) : super(key: key);

  @override
  State<ToolbarSearchDemo> createState() => _ToolbarSearchDemoState();
}

class _ToolbarSearchDemoState extends State<ToolbarSearchDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent, // Make scaffold background transparent
      body: Stack(
        fit: StackFit.expand, // Make stack fill the available space
        children: [
          // Grid background
          CustomPaint(
            painter: GridPatternPainter(isDarkMode: false),
            size: Size.infinite,
          ),
          // Centered demo widget
          Center(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 120,
                maxHeight: 120,
              ),
              child: const ToolbarDynamic(),
            ),
          ),
        ],
      ),
    );
  }
}
