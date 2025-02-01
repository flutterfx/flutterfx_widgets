import 'package:flutter/material.dart';

class MarqueeWidget extends StatefulWidget {
  final List<Widget> children;
  final bool reverse;
  final bool pauseOnHover;
  final bool vertical;
  final int repeat;
  final Duration duration;
  final double gap;

  const MarqueeWidget({
    Key? key,
    required this.children,
    this.reverse = false,
    this.pauseOnHover = false,
    this.vertical = false,
    this.repeat = 4,
    this.duration = const Duration(seconds: 40),
    this.gap = 16.0,
  }) : super(key: key);

  @override
  State<MarqueeWidget> createState() => _MarqueeWidgetState();
}

class _MarqueeWidgetState extends State<MarqueeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovered = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    if (!widget.pauseOnHover) {
      _controller.repeat();
    } else {
      _startAnimation();
    }
  }

  void _startAnimation() {
    if (!_isHovered) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        if (widget.pauseOnHover) {
          setState(() => _isHovered = true);
          _controller.stop();
        }
      },
      onExit: (_) {
        if (widget.pauseOnHover) {
          setState(() => _isHovered = false);
          _controller.repeat();
        }
      },
      child: SizedBox(
        height: widget.vertical
            ? null
            : 200, // Fixed height for horizontal scrolling
        width:
            widget.vertical ? 200 : null, // Fixed width for vertical scrolling
        child: SingleChildScrollView(
          scrollDirection: widget.vertical ? Axis.vertical : Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          controller: _scrollController,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: widget.vertical
                    ? Offset(
                        0,
                        _controller.value *
                            -(widget.children.length * (200 + widget.gap)) *
                            (widget.reverse ? -1 : 1),
                      )
                    : Offset(
                        _controller.value *
                            -(widget.children.length * (200 + widget.gap)) *
                            (widget.reverse ? -1 : 1),
                        0,
                      ),
                child: Wrap(
                  direction: widget.vertical ? Axis.vertical : Axis.horizontal,
                  spacing: widget.gap,
                  runSpacing: widget.gap,
                  children: [
                    for (int i = 0; i < widget.repeat; i++) ...widget.children,
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// review_card.dart
class ReviewCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String username;
  final String body;

  const ReviewCard({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.username,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      constraints: const BoxConstraints(maxHeight: 150),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black.withOpacity(0.1)
              : Colors.white.withOpacity(0.1),
        ),
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.black.withOpacity(0.01)
            : Colors.white.withOpacity(0.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(imageUrl),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                      ),
                      softWrap: true,
                    ),
                    Text(
                      username,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black.withOpacity(0.4)
                            : Colors.white.withOpacity(0.4),
                      ),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              body,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black.withOpacity(0.8)
                    : Colors.white.withOpacity(0.8),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}

// example_usage.dart
class MarqueeDemo extends StatelessWidget {
  MarqueeDemo({Key? key}) : super(key: key);

  final List<Map<String, String>> reviews = [
    {
      'name': 'Jack',
      'username': '@jack',
      'body': "I've never seen anything like this before. It's amazing.",
      'imageUrl': 'https://avatar.vercel.sh/jack',
    },
    {
      'name': 'Jill',
      'username': '@jill',
      'body': "I don't know what to say. I'm speechless. This is amazing.",
      'imageUrl': 'https://avatar.vercel.sh/jill',
    },
    // Add more reviews as needed
  ];

  @override
  Widget build(BuildContext context) {
    final firstRow = reviews.sublist(0, reviews.length ~/ 2);
    final secondRow = reviews.sublist(reviews.length ~/ 2);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MarqueeWidget(
                  duration: const Duration(milliseconds: 1000),
                  pauseOnHover: true,
                  children: firstRow
                      .map((review) => ReviewCard(
                            imageUrl: review['imageUrl']!,
                            name: review['name']!,
                            username: review['username']!,
                            body: review['body']!,
                          ))
                      .toList(),
                ),
                MarqueeWidget(
                  duration: const Duration(milliseconds: 1200),
                  pauseOnHover: true,
                  reverse: false,
                  children: secondRow
                      .map((review) => ReviewCard(
                            imageUrl: review['imageUrl']!,
                            name: review['name']!,
                            username: review['username']!,
                            body: review['body']!,
                          ))
                      .toList(),
                ),
                MarqueeWidget(
                  duration: const Duration(milliseconds: 1000),
                  pauseOnHover: true,
                  reverse: false,
                  children: secondRow
                      .map((review) => ReviewCard(
                            imageUrl: review['imageUrl']!,
                            name: review['name']!,
                            username: review['username']!,
                            body: review['body']!,
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          // Gradient overlays
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: MediaQuery.of(context).size.width / 3,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor,
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: MediaQuery.of(context).size.width / 3,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor,
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
