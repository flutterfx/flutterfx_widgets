import 'package:flutter/material.dart';
import 'package:fx_2_folder/folder_shape/gradient_shadow.dart';

class FolderHomeWidget extends StatefulWidget {
  final String title;
  final Curve curve;
  const FolderHomeWidget({super.key, required this.title, required this.curve});

  @override
  State<FolderHomeWidget> createState() => _FolderHomeWidgetState();
}

class _FolderHomeWidgetState extends State<FolderHomeWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final Duration animationDuration = Duration(milliseconds: 800);
  final Duration delayDuration = Duration(milliseconds: 2000);
  late AnimationController _shawdowAnimationController;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: animationDuration,
    );

    _shawdowAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: widget.curve),
    );

    _shadowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shawdowAnimationController, curve: widget.curve),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(widget.title,
                style: Theme.of(context).textTheme.titleMedium),
          ),
          Expanded(
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _animation,
              ]),
              builder: (context, child) {
                return GestureDetector(
                  onTap: () {
                    print("Widget tapped!");
                    if (isOpen) {
                      _animationController.reverse().orCancel;
                      _shawdowAnimationController.reverse();
                    } else {
                      _animationController.forward().orCancel;
                      Future.delayed(Duration(milliseconds: 300), () {
                        _shawdowAnimationController.forward().orCancel;
                      });
                    }
                    isOpen = !isOpen;
                  },
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Positioned(
                          top: 40, // Adjust this value to move shadow up/down
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black, // Color of the border
                                width: 2, // Width of the border
                              ),
                              borderRadius: BorderRadius.circular(
                                  10), // Optional: rounded corners
                            ),
                            child: CustomPaint(
                              size: const Size(
                                  150, 120), // Adjust height as needed
                              painter: SVGPathPainter(),
                            ),
                          )),
                      Positioned(
                        bottom: 40,
                        child: Image.asset(
                          'assets/images/folder_backcover.png',
                          width: 150,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 40, // Adjust this value to move shadow up/down
                        child: CustomPaint(
                          size: const Size(150, 120), // Adjust height as needed
                          painter:
                              FolderBackCoverGradientPainter(_shadowAnimation),
                        ),
                      ),
                      Positioned(
                        bottom: 40,
                        child: getFolderFrontCover(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Transform getFolderFrontCover() {
    var transform = Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.003)
        ..rotateX(1.3 * _animation.value),
      alignment: FractionalOffset.bottomCenter,
      child: SizedBox(
        width: 150,
        height: 100,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset(
              'assets/images/folder_frontcover.png',
              width: 150,
              height: 100,
              fit: BoxFit.cover,
            ),
            // ReflectionWidget(_animation, _shadowAnimation),
            ClipPath(
              clipper: LightningClipper(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Background color of the clipped area
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.8), // Shadow color
                      spreadRadius: 5, // Spread radius of the shadow
                      blurRadius: 7, // Blur radius of the shadow
                      offset: Offset(0, 3), // Offset for the shadow
                    ),
                  ],
                ),
                child: ReflectionWidget(_animation, _shadowAnimation),
              ),
            ),
          ],
        ),
      ),
    );
    return transform;
  }
}
