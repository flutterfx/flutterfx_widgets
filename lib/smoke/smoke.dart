import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:fx_2_folder/smoke/animated_circles.dart';
import 'package:fx_2_folder/smoke/animation_sequence.dart';
import 'package:fx_2_folder/smoke/circle_data.dart';

const defaultColor = Color.fromRGBO(176, 176, 176, 1);

class SmokeHomeWidget extends StatefulWidget {
  const SmokeHomeWidget({Key? key}) : super(key: key);

  @override
  State<SmokeHomeWidget> createState() => _SmokeHomeWidgetState();
}

class _SmokeHomeWidgetState extends State<SmokeHomeWidget> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    enterFullScreen();
  }

  // @override
  // void dispose() {
  //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  //   super.dispose();
  // }

  void enterFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  void exitFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            print("Tapped!");
            exitFullScreen();
            Navigator.pop(context);
          },
          child: BlurredCircle(), // Your full-screen content goes here
        ),
      ),
    );
  }
}

class BlurredCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<_StartScreenState> _startScreenKey = GlobalKey();
    bool isDev = false;
    var manualSequence = AnimationSequence(
      sequences: [
        [
          CircleData(
            id: '1',
            normalizedPosition: const Offset(1, 1),
            radius: 0,
            color: isDev ? Colors.red : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '2',
            normalizedPosition: const Offset(1, 1),
            radius: 0,
            color: isDev ? Colors.blue : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '3',
            normalizedPosition: const Offset(1, 1),
            radius: 0,
            color: isDev ? Colors.green : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '4',
            normalizedPosition: const Offset(1, 1),
            radius: 0,
            color: isDev ? Colors.yellow : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '5',
            normalizedPosition: const Offset(1, 1),
            radius: 0,
            color: isDev ? Colors.orange : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '6',
            normalizedPosition: const Offset(1, 1),
            radius: 0,
            color: isDev ? Colors.purple : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '7',
            normalizedPosition: const Offset(1, 1),
            radius: 0,
            color: isDev ? Colors.cyan : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '8',
            normalizedPosition: const Offset(1, 1),
            radius: 0,
            color: isDev ? Colors.indigo : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
        ],
        [
          CircleData(
            id: '1',
            normalizedPosition: const Offset(.83, .93),
            radius: 80,
            color: isDev ? Colors.red : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '2',
            normalizedPosition: const Offset(.94, .80),
            radius: 70,
            color: isDev ? Colors.blue : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '3',
            normalizedPosition: const Offset(.6, .97),
            radius: 60,
            color: isDev ? Colors.green : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '4',
            normalizedPosition: const Offset(.94, .68),
            radius: 40,
            color: isDev ? Colors.yellow : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '5',
            normalizedPosition: const Offset(0.9, .6),
            radius: 30,
            color: isDev ? Colors.orange : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '6',
            normalizedPosition: const Offset(0.75, 0.70),
            radius: 40,
            color: isDev ? Colors.purple : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '7',
            normalizedPosition: const Offset(.4, .97),
            radius: 40,
            color: isDev ? Colors.cyan : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '8',
            normalizedPosition: const Offset(.3, .97),
            radius: 20,
            color: isDev ? Colors.indigo : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
        ],
        [
          CircleData(
            id: '1',
            normalizedPosition: const Offset(0.45, .47),
            radius: 30,
            color: isDev ? Colors.red : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '2',
            normalizedPosition: const Offset(.28, .56),
            radius: 30,
            color: isDev ? Colors.blue : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '3',
            normalizedPosition: const Offset(.17, .57),
            radius: 30,
            color: isDev ? Colors.green : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '4',
            normalizedPosition: const Offset(.6, .4),
            radius: 20,
            color: isDev ? Colors.yellow : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '5',
            normalizedPosition: const Offset(.07, .7),
            radius: 70,
            color: isDev ? Colors.orange : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '6',
            normalizedPosition: const Offset(0.35, 0.590),
            radius: 25,
            color: isDev ? Colors.purple : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '7',
            normalizedPosition: const Offset(.4, .55),
            radius: 20,
            color: isDev ? Colors.cyan : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '8',
            normalizedPosition: const Offset(.25, .6),
            radius: 20,
            color: isDev ? Colors.indigo : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
        ],
        [
          CircleData(
            id: '1',
            normalizedPosition: const Offset(0.45, .35),
            radius: 40,
            color: isDev ? Colors.red : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '2',
            normalizedPosition: const Offset(.36, .16),
            radius: 15,
            color: isDev ? Colors.blue : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '3',
            normalizedPosition: const Offset(.30, .4),
            radius: 10,
            color: isDev ? Colors.green : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '4',
            normalizedPosition: const Offset(.6, .4),
            radius: 20,
            color: isDev ? Colors.yellow : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '5',
            normalizedPosition: const Offset(.15, .075),
            radius: 90,
            color: isDev ? Colors.orange : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '6',
            normalizedPosition: const Offset(0.42, 0.2),
            radius: 25,
            color: isDev ? Colors.purple : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '7',
            normalizedPosition: const Offset(.15, .26),
            radius: 120,
            color: isDev ? Colors.cyan : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '8',
            normalizedPosition: const Offset(.48, .41),
            radius: 15,
            color: isDev ? Colors.indigo : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
        ],
        [
          CircleData(
            id: '1',
            normalizedPosition: const Offset(0.0, .0),
            radius: 20,
            color: isDev ? Colors.red : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '2',
            normalizedPosition: const Offset(.25, .10),
            radius: 25,
            color: isDev ? Colors.blue : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '3',
            normalizedPosition: const Offset(.45, .06),
            radius: 20,
            color: isDev ? Colors.green : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '4',
            normalizedPosition: const Offset(.025, .025),
            radius: 80,
            color: isDev ? Colors.yellow : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '5',
            normalizedPosition: const Offset(.15, .015),
            radius: 20,
            color: isDev ? Colors.orange : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '6',
            normalizedPosition: const Offset(0.25, 0.015),
            radius: 50,
            color: isDev ? Colors.purple : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '7',
            normalizedPosition: const Offset(.45, .0),
            radius: 30,
            color: isDev ? Colors.cyan : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '8',
            normalizedPosition: const Offset(.38, .0),
            radius: 35,
            color: isDev ? Colors.indigo : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
        ],
        [
          CircleData(
            id: '1',
            normalizedPosition: const Offset(1, .0),
            radius: 20,
            color: isDev ? Colors.red : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '2',
            normalizedPosition: const Offset(.955, .125),
            radius: 80,
            color: isDev ? Colors.blue : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '3',
            normalizedPosition: const Offset(.79, .080),
            radius: 15,
            color: isDev ? Colors.green : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '4',
            normalizedPosition: const Offset(.725, .025),
            radius: 20,
            color: isDev ? Colors.yellow : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '5',
            normalizedPosition: const Offset(.955, .015),
            radius: 80,
            color: isDev ? Colors.orange : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '6',
            normalizedPosition: const Offset(.725, .050),
            radius: 15,
            color: isDev ? Colors.purple : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '7',
            normalizedPosition: const Offset(.82, .10),
            radius: 10,
            color: isDev ? Colors.cyan : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '8',
            normalizedPosition: const Offset(.725, .080),
            radius: 15,
            color: isDev ? Colors.indigo : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
        ],
        [
          CircleData(
            id: '1',
            normalizedPosition: const Offset(1, .5),
            radius: 20,
            color: isDev ? Colors.red : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '2',
            normalizedPosition: const Offset(.955, .125),
            radius: 80,
            color: isDev ? Colors.blue : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '3',
            normalizedPosition: const Offset(1, .6),
            radius: 35,
            color: isDev ? Colors.green : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '4',
            normalizedPosition: const Offset(1, .30),
            radius: 80,
            color: isDev ? Colors.yellow : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '5',
            normalizedPosition: const Offset(1, .7),
            radius: 50,
            color: isDev ? Colors.orange : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '6',
            normalizedPosition: const Offset(1, .9),
            radius: 70,
            color: isDev ? Colors.purple : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '7',
            normalizedPosition: const Offset(1, .5),
            radius: 70,
            color: isDev ? Colors.cyan : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
              id: '8',
              normalizedPosition: const Offset(1, .40),
              radius: 20,
              color: isDev
                  ? Colors.indigo
                  : defaultColor), //Color.fromRGBO(176, 176, 176, 1)),
        ],
        [
          CircleData(
            id: '1',
            normalizedPosition: const Offset(1, 1),
            radius: 20,
            color: isDev ? Colors.red : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '2',
            normalizedPosition: const Offset(.8, .8),
            radius: 110,
            color: isDev ? Colors.blue : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '3',
            normalizedPosition: const Offset(1, .6),
            radius: 35,
            color: isDev ? Colors.green : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '4',
            normalizedPosition: const Offset(1, .30),
            radius: 80,
            color: isDev ? Colors.yellow : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '5',
            normalizedPosition: const Offset(.45, 1),
            radius: 50,
            color: isDev ? Colors.orange : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '6',
            normalizedPosition: const Offset(.8, .98),
            radius: 70,
            color: isDev ? Colors.purple : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '7',
            normalizedPosition: const Offset(1, .5),
            radius: 100,
            color: isDev ? Colors.cyan : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
          CircleData(
            id: '8',
            normalizedPosition: const Offset(1, .80),
            radius: 120,
            color: isDev ? Colors.indigo : defaultColor,
          ), //Color.fromRGBO(176, 176, 176, 1)),
        ],
      ],
      stepDuration: Duration(seconds: 3),
      onSequenceChange: (int index) {
        print("New sequence started: $index");
        // Perform any other actions you need here
        //switch from 0 to 7
        if (index == 0) {
          _startScreenKey.currentState
              ?.updateOpacities(logoOpacity: 0, textOpacity: 0);
        } else if (index == 1) {
          _startScreenKey.currentState
              ?.updateOpacities(logoOpacity: 1, textOpacity: 1);
        } else if (index == 2) {
          _startScreenKey.currentState
              ?.updateOpacities(logoOpacity: .7, textOpacity: .1);
        } else if (index == 3) {
          _startScreenKey.currentState
              ?.updateOpacities(logoOpacity: .1, textOpacity: .1);
        } else if (index == 4) {
          _startScreenKey.currentState
              ?.updateOpacities(logoOpacity: .1, textOpacity: .1);
        } else if (index == 5) {
          _startScreenKey.currentState
              ?.updateOpacities(logoOpacity: .6, textOpacity: .1);
        } else if (index == 6) {
          _startScreenKey.currentState
              ?.updateOpacities(logoOpacity: 1, textOpacity: 1);
        } else if (index == 7) {
          _startScreenKey.currentState
              ?.updateOpacities(logoOpacity: .2, textOpacity: .6);
        }
      },
    );

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: Stack(
        children: [
          AnimatedCircles(sequence: manualSequence), //sequence
          BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: 100,
              sigmaY: 100,
            ),
            child: Container(color: Colors.transparent),
          ),
          StartScreen(key: _startScreenKey)
        ],
      ),
    );
  }
}

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotateController;

  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();
    _rotateController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _logoController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _textController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _logoOpacity = Tween<double>(begin: 0, end: 0).animate(_logoController);
    _textOpacity = Tween<double>(begin: 0, end: 0).animate(_textController);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateOpacities(logoOpacity: 0, textOpacity: 0);
    });
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void updateOpacities(
      {required double logoOpacity, required double textOpacity}) {
    setState(() {
      _logoOpacity = Tween<double>(begin: _logoOpacity.value, end: logoOpacity)
          .animate(CurvedAnimation(
              parent: _logoController, curve: Curves.easeInOut));
      _textOpacity = Tween<double>(begin: _textOpacity.value, end: textOpacity)
          .animate(CurvedAnimation(
              parent: _textController, curve: Curves.easeInOut));

      // _logoOpacity = Tween<double>(begin: _logoOpacity.value, end: logoOpacity)
      //     .animate(_logoController);
      // _textOpacity = Tween<double>(begin: _textOpacity.value, end: textOpacity)
      //     .animate(_textController);
    });
    _logoController.forward(from: 0);
    _textController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Main centered logo
        Center(
          child: FadeTransition(
            opacity: _logoOpacity,
            child: Image.asset(
              'assets/images/smoke/main_logo.png',
              width: 32,
              height: 32,
            ),
          ),
        ),
        // Bottom aligned elements
        Positioned(
          left: 0,
          right: 0,
          bottom: 80,
          child: FadeTransition(
            opacity: _textOpacity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RotationTransition(
                  turns: _rotateController,
                  child: Image.asset(
                    'assets/images/smoke/bottom_logo.png',
                    width: 32,
                    height: 32,
                  ),
                ),
                SizedBox(height: 40),
                const Text(
                  'Tap to Enter',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
