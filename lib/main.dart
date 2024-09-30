import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(curve: Curves.easeInOutBack, title: 'EaseInOutBack'),
    );
  }
}

// class InterpolationShowcase extends StatelessWidget {
//   const InterpolationShowcase({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Interpolation Nightmare')),
//       body: GridView.count(
//         crossAxisCount: 2,
//         mainAxisSpacing: 10,
//         crossAxisSpacing: 10,
//         children: [
//           MyHomePage(curve: Curves.linear, title: 'Linear'),
//           MyHomePage(curve: Curves.easeInOut, title: 'EaseInOut'),
//           MyHomePage(curve: Curves.bounceOut, title: 'BounceOut'),
//           MyHomePage(curve: Curves.easeInOutQuint, title: 'EaseInOutQuint'),
//           MyHomePage(curve: Curves.easeInOutBack, title: 'EaseInOutBack'),
//           MyHomePage(curve: Curves.elasticIn, title: 'ElasticIn'),
//         ],
//       ),
//     );
//   }
// }

class MyHomePage extends StatefulWidget {
  final String title;
  final Curve curve;
  const MyHomePage({super.key, required this.title, required this.curve});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final Duration animationDuration = Duration(seconds: 1);
  final Duration delayDuration = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: animationDuration,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: widget.curve),
    );

    _startAnimation();
    // _animationController.repeat(reverse: true);
  }

  void _startAnimation() async {
    while (true) {
      await _animationController.forward().orCancel;
      await Future.delayed(delayDuration);
      await _animationController.reverse().orCancel;
      _animationController.reset(); // Reset to start for next iteration
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
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
                return Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      width: 100,
                      height: 75,
                      margin: const EdgeInsets.only(bottom: 40),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                    ),
                    Positioned(
                      bottom: 40, // Aligns the bottom with the parent Stack
                      child: Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.005)
                          ..rotateX(1.3 * _animation.value),
                        // ..rotateX(_isExpanded ? angle * _animation.value : 0),
                        alignment: FractionalOffset.bottomCenter,
                        child: Container(
                          width: 100,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
