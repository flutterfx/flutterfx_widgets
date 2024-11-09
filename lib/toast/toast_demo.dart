import 'package:flutter/material.dart';
import './widget_theme.dart';

class ToastDemo extends StatefulWidget {
  const ToastDemo({super.key});

  @override
  State<ToastDemo> createState() => _ToastDemoState();
}

class _ToastDemoState extends State<ToastDemo> {
  final List<CardModel> cards = [];
  int nextCardNumber = 1;

  // Enhanced position configurations
  static const entryPosition = CardPosition(x: 0, y: 70, z: -75);
  static const exitPosition = CardPosition(x: 0, y: 0, z: 225);

  // Define your positions
  final List<CardPosition> positions = [
    const CardPosition(x: 0.0, y: 0.0, z: 0.0),
    const CardPosition(x: 0.0, y: -20.0, z: 90.0),
    const CardPosition(x: 0.0, y: -40.0, z: 180.0),
  ];

  void addNewCard() {
    setState(() {
      // Add new card
      final newCard = CardModel(
        content: 'Card $nextCardNumber',
        id: nextCardNumber,
      );
      cards.insert(0, newCard);
      nextCardNumber++;

      if (cards.length > positions.length) {
        // Handle removal of last card with exit animation
        Future.delayed(const Duration(milliseconds: 300), () {
          setState(() {
            cards.removeLast();
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: Container(
        decoration: const BoxDecoration(
          color: AppTheme.backgroundStartColor,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8F8F8),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              // Background Pattern
              Positioned.fill(
                child: CustomPaint(
                  painter: GridPatternPainter(),
                ),
              ),
              // Main content with cards
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ...cards
                        .asMap()
                        .entries
                        .map((entry) {
                          final index = entry.key;
                          final card = entry.value;

                          CardPosition position;

                          bool isEntering =
                              index == 0 && card.id == nextCardNumber - 1;

                          if (index >= positions.length) {
                            //Exit animation
                            position = exitPosition;
                          } else if (isEntering) {
                            //Entry animation
                            position = entryPosition;
                          } else {
                            position = positions[index];
                          }

                          return AnimatedCardWidget(
                            key: ValueKey(
                                card.id), // Important for proper animation
                            card: card,
                            position: position,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            isEntering: isEntering,
                            onAnimationComplete: index >= positions.length
                                ? () {
                                    setState(() {
                                      cards.remove(card);
                                    });
                                  }
                                : null,
                          );
                        })
                        .toList()
                        .reversed,
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              // Add button
              Positioned(
                right: 16,
                bottom: 16,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: addNewCard,
                    borderRadius: BorderRadius.circular(28),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: AppTheme.accentGradient,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: AppTheme.cardShadows,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom painter for the background grid pattern
class GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.patternColor
      ..strokeWidth = 1;

    const spacing = 20.0;

    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }

    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SimpleCard extends StatelessWidget {
  final String title;

  const SimpleCard({
    Key? key,
    this.title = 'Simple Card Title',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppTheme.cardMargin),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
        gradient: AppTheme.cardGradient,
        boxShadow: AppTheme.cardShadows,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.cardPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.titleStyle,
              ),
              const SizedBox(height: 8),
              Text(
                'This is a card with equal shadows on all sides.',
                style: AppTheme.descriptionStyle,
              ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                height: AppTheme.accentBarHeight,
                width: AppTheme.accentBarWidth,
                decoration: BoxDecoration(
                  gradient: AppTheme.accentGradient,
                  borderRadius: BorderRadius.circular(AppTheme.accentBarRadius),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// all files together
class CardModel {
  final String content;
  final int id;

  const CardModel({
    required this.content,
    required this.id,
  });
}

// A custom position class for better type safety and clarity
class CardPosition {
  final double x;
  final double y;
  final double z;

  const CardPosition({
    this.x = 0.0,
    this.y = 0.0,
    this.z = 0.0,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardPosition &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y &&
          z == other.z;

  @override
  int get hashCode => Object.hash(x, y, z);
}

// The main animated card widget with a clean API
class AnimatedCardWidget extends StatefulWidget {
  final CardModel card;
  final CardPosition position;
  final Duration duration;
  final Curve curve;
  final VoidCallback? onAnimationComplete;
  final bool exitAnimation;
  final bool isEntering;

  const AnimatedCardWidget({
    required this.card,
    required this.position,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOutQuart,
    this.onAnimationComplete,
    this.exitAnimation = false,
    this.isEntering = false,
    Key? key,
  }) : super(key: key);

  @override
  State<AnimatedCardWidget> createState() => _AnimatedCardWidgetState();
}

class _AnimatedCardWidgetState extends State<AnimatedCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _xAnimation;
  late Animation<double> _yAnimation;
  late Animation<double> _zAnimation;
  late Animation<double> _opacityAnimation;

  CardPosition? _oldPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _setupAnimations();
  }

  void _setupAnimations() {
    // Auto-start animation for entering cards
    if (widget.isEntering) {
      _controller.forward();
    }

    final begin =
        widget.isEntering ? widget.position : (_oldPosition ?? widget.position);
    final end = widget.isEntering
        ? const CardPosition(x: 0.0, y: 0.0, z: 0.0)
        : widget.position;

    _xAnimation = Tween<double>(
      begin: begin.x,
      end: end.x,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _yAnimation = Tween<double>(
      begin: begin.y,
      end: end.y,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _zAnimation = Tween<double>(
      begin: begin.z,
      end: end.z,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _opacityAnimation = Tween<double>(
      begin: widget.isEntering ? 0.0 : 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuart,
    ));

    _controller.addStatusListener(_handleAnimationStatus);
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onAnimationComplete?.call();
    }
  }

  @override
  void didUpdateWidget(AnimatedCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.position != widget.position ||
        oldWidget.duration != widget.duration ||
        oldWidget.curve != widget.curve) {
      _oldPosition = CardPosition(
        x: _xAnimation.value,
        y: _yAnimation.value,
        z: _zAnimation.value,
      );

      _controller.duration = widget.duration;
      _setupAnimations();
      _controller.forward(from: 0);
    }
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
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..translate(
                  _xAnimation.value, _yAnimation.value, _zAnimation.value),
            alignment: FractionalOffset.center,
            child: child,
          ),
        );
      },
      child: SimpleCard(title: widget.card.content),
    );
  }
}
