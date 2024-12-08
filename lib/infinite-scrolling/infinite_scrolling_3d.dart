import 'package:flutter/material.dart';
import 'dart:math' as math;

class Marquee3D extends StatelessWidget {
  Marquee3D({Key? key}) : super(key: key);

  final List<Map<String, String>> logos = [
    {
      "name": "Microsoft",
      "img": "https://picsum.photos/id/1/200/300",
    },
    {
      "name": "Apple",
      "img": "https://picsum.photos/id/2/200/300",
    },
    {
      "name": "Google",
      "img": "https://picsum.photos/id/3/200/300",
    },
    {
      "name": "Facebook",
      "img": "https://picsum.photos/id/4/200/300",
    },
    {
      "name": "LinkedIn",
      "img": "https://picsum.photos/id/5/200/300",
    },
    {
      "name": "Twitter",
      "img": "https://picsum.photos/id/6/200/300",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Left Column
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(0)
                ..rotateY(-20 * math.pi / 180)
                ..rotateZ(10 * math.pi / 180)
                ..translate(0.0, 0.0, -50.0)
                ..scale(1.2),
              alignment: Alignment.center,
              child: SizedBox(
                height: double.infinity,
                child: Marquee3DContent(
                  logos: logos,
                  durationInSeconds: 10, // Faster speed
                ),
              ),
            ),
          ),
          //add spacing of 6 pixels

          // Center Column
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(0)
                ..rotateY(-20 * math.pi / 180)
                ..rotateZ(10 * math.pi / 180)
                ..translate(0.0, 0.0, -50.0)
                ..scale(1.2),
              alignment: Alignment.center,
              child: SizedBox(
                height: double.infinity,
                child: Marquee3DContent(
                  logos: logos,
                  durationInSeconds: 20, // Original speed
                ),
              ),
            ),
          ),

          // Right Column
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(0)
                ..rotateY(-20 * math.pi / 180)
                ..rotateZ(10 * math.pi / 180)
                ..translate(0.0, 0.0, -50.0)
                ..scale(1.2),
              alignment: Alignment.center,
              child: SizedBox(
                height: double.infinity,
                child: Marquee3DContent(
                  logos: logos,
                  durationInSeconds: 30, // Slower speed
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Marquee3DContent extends StatefulWidget {
  final List<Map<String, String>> logos;
  final int durationInSeconds;

  const Marquee3DContent({
    Key? key,
    required this.logos,
    required this.durationInSeconds,
  }) : super(key: key);

  @override
  State<Marquee3DContent> createState() => _Marquee3DContentState();
}

class _Marquee3DContentState extends State<Marquee3DContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.durationInSeconds),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _scrollController,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              0,
              -_controller.value * widget.logos.length * 300,
            ),
            child: Column(
              children: [
                for (int i = 0; i < 4; i++)
                  ...widget.logos.map((logo) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LogoCard(
                          imageUrl: logo['img']!,
                          name: logo['name']!,
                        ),
                      )),
              ],
            ),
          );
        },
      ),
    );
  }
}

class LogoCard extends StatefulWidget {
  final String imageUrl;
  final String name;

  const LogoCard({
    Key? key,
    required this.imageUrl,
    required this.name,
  }) : super(key: key);

  @override
  State<LogoCard> createState() => _LogoCardState();
}

class _LogoCardState extends State<LogoCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 150,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).dividerColor,
          ),
          boxShadow: isHovered
              ? [
                  BoxShadow(
                    color: Theme.of(context).dividerColor.withOpacity(0.5),
                    blurRadius: 4,
                    spreadRadius: 2,
                  )
                ]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            widget.imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
