import 'package:flutter/material.dart';

class LayeredTickers extends StatelessWidget {
  const LayeredTickers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background tickers with different angles and positions
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: ScrollingTickerWidget(
              text: "BLACK FRIDAY '24",
              backgroundColor: Colors.purple.shade800,
              transform: -0.2,
              height: 45,
            ),
          ),
          Positioned(
            top: 130,
            left: 0,
            right: 0,
            child: ScrollingTickerWidget(
              text: "HEADPHONE ZONE",
              backgroundColor: Colors.purple.shade600,
              transform: -0.15,
              speed: 45,
              height: 45,
            ),
          ),
          Positioned(
            top: 160,
            left: 0,
            right: 0,
            child: ScrollingTickerWidget(
              text: "BIG DEALS",
              backgroundColor: Colors.purple.shade400,
              transform: -0.1,
              speed: 40,
              height: 45,
            ),
          ),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                const Text(
                  'BLACK',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  color: Colors.purple,
                  child: const Text(
                    'FRIDAY',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'SALE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ScrollingTickerWidget extends StatefulWidget {
  final String text;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final double height;
  final double speed;
  final TextStyle? textStyle;
  final double iconSize;
  final double transform; // Added transform parameter for skew angle

  const ScrollingTickerWidget({
    Key? key,
    required this.text,
    this.icon = Icons.headphones,
    this.backgroundColor = Colors.purple,
    this.textColor = Colors.white,
    this.iconColor = Colors.white,
    this.height = 50.0,
    this.speed = 50.0,
    this.textStyle,
    this.iconSize = 24.0,
    this.transform = -0.2, // Default transform angle
  }) : super(key: key);

  @override
  State<ScrollingTickerWidget> createState() => _ScrollingTickerWidgetState();
}

class _ScrollingTickerWidgetState extends State<ScrollingTickerWidget>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startScrolling();
    });
  }

  void _startScrolling() {
    double screenWidth = MediaQuery.of(context).size.width;
    final duration =
        Duration(milliseconds: ((screenWidth) / widget.speed * 4000).toInt());

    Future.delayed(const Duration(milliseconds: 50), () {
      if (_scrollController.hasClients) {
        _scrollController
            .animateTo(
          _scrollController.position.maxScrollExtent,
          duration: duration,
          curve: Curves.linear,
        )
            .then((_) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(0);
            _startScrolling();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildTickerItem() {
    return Row(
      children: [
        Icon(
          widget.icon,
          color: widget.iconColor,
          size: widget.iconSize,
        ),
        const SizedBox(width: 8),
        Text(
          widget.text,
          style: widget.textStyle?.copyWith(color: widget.textColor) ??
              TextStyle(
                color: widget.textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(width: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.skewY(widget.transform),
      child: Container(
        height: widget.height,
        color: widget.backgroundColor,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          physics: const NeverScrollableScrollPhysics(),
          child: Row(
            children: [
              ...List.generate(20, (index) => _buildTickerItem()),
              SizedBox(width: MediaQuery.of(context).size.width),
            ],
          ),
        ),
      ),
    );
  }
}
