import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fx_2_folder/stacked-cards/stacked_card.dart';

//Future note: Support different animation like blur fade to make it look better for another day!

class TextMorph extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const TextMorph({
    super.key,
    required this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: _buildAnimatedCharacters(),
        ),
      ),
    );
  }

  List<Widget> _buildAnimatedCharacters() {
    final characters = text.split('');
    return characters.asMap().entries.map((entry) {
      final index = entry.key;
      final char = entry.value;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.5),
        child: MorphCharacter(
          key: ValueKey('${char}_$index'),
          character: index == 0 ? char.toUpperCase() : char.toLowerCase(),
          style: style,
        ),
      );
    }).toList();
  }
}

class MorphCharacter extends StatefulWidget {
  final String character;
  final TextStyle? style;

  const MorphCharacter({
    super.key,
    required this.character,
    this.style,
  });

  @override
  State<MorphCharacter> createState() => _MorphCharacterState();
}

class _MorphCharacterState extends State<MorphCharacter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600), // Increased duration
      vsync: this,
    );

    // Custom curve for more dynamic animation
    final customCurve = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut, // Bouncy effect
    );

    // Scale animation with elastic effect
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(customCurve);

    // Opacity animation with custom curve
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ));

    // Slide animation from bottom
    _slideAnimation = Tween<double>(
      begin: 10.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuad,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MorphCharacter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.character != widget.character) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: child,
            ),
          ),
        );
      },
      child: Text(
        widget.character,
        style: widget.style?.copyWith(
              fontSize: 44,
              fontWeight: FontWeight.w500,
            ) ??
            const TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}

class TextMorphButton extends StatefulWidget {
  const TextMorphButton({super.key});

  @override
  State<TextMorphButton> createState() => _TextMorphButtonState();
}

class _TextMorphButtonState extends State<TextMorphButton> {
  String text = 'Continue';

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 40,
      width: 120,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            text = text == 'Continue' ? 'Confirm' : 'Continue';
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isDarkMode ? Colors.white : Colors.black,
          foregroundColor: isDarkMode ? Colors.black : Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: TextMorph(text: text),
      ),
    );
  }
}

//-------

class TextMorphDemo extends StatelessWidget {
  const TextMorphDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: FullScreenTextMorph()),
      ),
    );
  }
}

class FullScreenTextMorph extends StatefulWidget {
  const FullScreenTextMorph({super.key});

  @override
  State<FullScreenTextMorph> createState() => _FullScreenTextMorphState();
}

class _FullScreenTextMorphState extends State<FullScreenTextMorph> {
  final List<String> words = [
    'Banter',
    'Bunty',
    'Bubbly',
    'Biscuit',
    'Circuit',
    'Bangle',
    'Banger',
  ];

  int currentIndex = 0;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 1200), (timer) {
      setState(() {
        currentIndex = (currentIndex + 1) % words.length;
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

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
          Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.centerLeft,
            child: TextMorph(
              text: words[currentIndex],
              style: const TextStyle(
                fontSize: 120,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: -1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Your existing TextMorph, MorphCharacter classes remain the same...
