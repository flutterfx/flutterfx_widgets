import 'package:flutter/material.dart';

import 'widget_theme.dart';

class StackedExpandedCardDemo extends StatefulWidget {
  const StackedExpandedCardDemo({super.key});

  @override
  State<StackedExpandedCardDemo> createState() =>
      _StackedExpandedCardDemoState();
}

class _StackedExpandedCardDemoState extends State<StackedExpandedCardDemo> {
  final List<CardModel> cards = [];
  int nextCardNumber = 1;
  bool isDarkMode = false;

  bool isExpanded = false;
  bool isTransitioning = false;
  bool isCollapsing = false;

  static const entryPosition = CardPosition(x: 0, y: 70, z: -75);
  static const exitPosition = CardPosition(x: 0, y: 0, z: 225);

  final List<CardPosition> positions = [
    const CardPosition(x: 0.0, y: 0.0, z: 0.0),
    const CardPosition(x: 0.0, y: -20.0, z: 90.0),
    const CardPosition(x: 0.0, y: -40.0, z: 180.0),
  ];

  void toggleExpanded() {
    if (isTransitioning) return;
    setState(() {
      isTransitioning = true;
      isExpanded = !isExpanded;
      isCollapsing = isExpanded == false;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          isTransitioning = false;
          isCollapsing = false;
        });
      }
    });
  }

  void toggleTheme() {
    setState(
      () {
        isDarkMode = !isDarkMode;
      },
    );
  }

  void addNewCard() {
    if (isExpanded) {
      setState(() {
        isExpanded = false;
        isTransitioning = true;
      });

      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          isTransitioning = false;
          final newCard = CardModel(
            content: 'Card $nextCardNumber',
            id: nextCardNumber,
            hasCompletedEntryAnimation: false,
          );
          cards.insert(0, newCard);
          nextCardNumber++;

          if (cards.length > positions.length) {
            Future.delayed(const Duration(milliseconds: 300), () {
              setState(() {
                cards.removeLast();
              });
            });
          }
        });
      });
    } else {
      setState(() {
        final newCard = CardModel(
          content: 'Card $nextCardNumber',
          id: nextCardNumber,
          hasCompletedEntryAnimation: false,
        );
        cards.insert(0, newCard);
        nextCardNumber++;

        if (cards.length > positions.length) {
          Future.delayed(const Duration(milliseconds: 300), () {
            setState(() {
              cards.removeLast();
            });
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppTheme.getBackgroundGradient(isDarkMode),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: GridPatternPainter(isDarkMode: isDarkMode),
                ),
              ),
              Positioned(
                bottom: 72,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: toggleExpanded,
                  child: Center(
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

                              if (isExpanded) {
                                position = CardPosition(
                                  x: 0,
                                  y: -index *
                                      (AppTheme.cardHeight +
                                          AppTheme.cardMargin * 2),
                                  z: 0,
                                );
                              } else {
                                bool isEntering = !isTransitioning &&
                                    index == 0 &&
                                    !card.hasCompletedEntryAnimation &&
                                    card.id == nextCardNumber - 1;

                                if (index >= positions.length) {
                                  position = exitPosition;
                                } else if (isEntering) {
                                  position = entryPosition;
                                } else {
                                  position = positions[index];
                                }
                              }

                              return AnimatedCardWidget(
                                key: ValueKey(card.id),
                                card: card,
                                position: position,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                isEntering: !card.hasCompletedEntryAnimation &&
                                    !isTransitioning,
                                onEntryAnimationComplete: () {
                                  setState(() {
                                    final cardIndex = cards
                                        .indexWhere((c) => c.id == card.id);
                                    if (cardIndex != -1) {
                                      cards[cardIndex]
                                          .hasCompletedEntryAnimation = true;
                                    }
                                  });
                                },
                                onAnimationComplete: index >= positions.length
                                    ? () {
                                        setState(() {
                                          cards.remove(card);
                                        });
                                      }
                                    : null,
                                isDarkMode: isDarkMode,
                              );
                            })
                            .toList()
                            .reversed,
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                bottom: 16,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: toggleTheme,
                    borderRadius: BorderRadius.circular(28),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: AppTheme.getAccentGradient(isDarkMode),
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: AppTheme.cardShadows,
                      ),
                      child: Icon(
                        isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        color: isDarkMode ? Colors.black : Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
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
                        gradient: LinearGradient(
                          colors: AppTheme.getAccentGradient(isDarkMode),
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: AppTheme.cardShadows,
                      ),
                      child: Icon(
                        Icons.add,
                        color: isDarkMode ? Colors.black : Colors.white,
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

class GridPatternPainter extends CustomPainter {
  final bool isDarkMode;

  GridPatternPainter({required this.isDarkMode});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.getPatternColor(isDarkMode)
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
  final bool isDarkMode;

  const SimpleCard({
    Key? key,
    this.title = 'Simple Card Title',
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppTheme.cardMargin),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppTheme.getCardGradient(isDarkMode),
        ),
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
                '$title : A toast message.',
                style: AppTheme.getDescriptionStyle(isDarkMode),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardModel {
  final String content;
  final int id;
  bool hasCompletedEntryAnimation;

  CardModel({
    required this.content,
    required this.id,
    this.hasCompletedEntryAnimation = false,
  });
}

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

class AnimatedCardWidget extends StatefulWidget {
  final CardModel card;
  final CardPosition position;
  final Duration duration;
  final Curve curve;
  final VoidCallback? onAnimationComplete;
  final bool exitAnimation;
  final bool isEntering;
  final bool isDarkMode;
  final VoidCallback? onEntryAnimationComplete;

  const AnimatedCardWidget({
    required this.card,
    required this.position,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOutQuart,
    this.onAnimationComplete,
    this.exitAnimation = false,
    this.isEntering = false,
    required this.isDarkMode,
    this.onEntryAnimationComplete,
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
      if (widget.isEntering) {
        widget.onEntryAnimationComplete?.call();
      }
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
      child: SimpleCard(
        title: widget.card.content,
        isDarkMode: widget.isDarkMode,
      ),
    );
  }
}
