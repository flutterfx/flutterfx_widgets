import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fx_2_folder/books/books.dart';
import 'package:fx_2_folder/circles_selector/CirclesHomeWidget.dart';
import 'package:fx_2_folder/folder_shape/folder_home.dart';
import 'package:fx_2_folder/frosty_card/frosty_card.dart';
import 'package:fx_2_folder/fx_7_border_beam/border_beam.dart';
import 'package:fx_2_folder/fx_7_border_beam/border_beam_demo.dart';
import 'package:fx_2_folder/fx_8_shine_border/meteors_demo.dart';
import 'package:fx_2_folder/fx_9_neon_card/neon_card_demo.dart';
import 'package:fx_2_folder/smoke/smoke.dart';
import 'package:fx_2_folder/vinyl/vinyl.dart';
import 'package:fx_2_folder/visibility/blur_fade.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const AnimationShowcaseApp());

class AnimationShowcaseApp extends StatelessWidget {
  const AnimationShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'fx-widget Showcase',
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF1E1E1E),
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF2C2C2C),
        textTheme: GoogleFonts.robotoMonoTextTheme(
          Theme.of(context).textTheme,
        ).apply(bodyColor: Colors.white),
      ),
      home: HomeScreen(),
    );
  }
}

class AnimationExample {
  final String title;
  final Widget Function(BuildContext) builder;
  final Color? appBarColor;
  final bool isFullScreen;

  AnimationExample({
    required this.title,
    required this.builder,
    this.appBarColor,
    this.isFullScreen = false,
  });
}

class HomeScreen extends StatelessWidget {
  final List<AnimationExample> examples = [
    AnimationExample(
      title: 'Folder',
      builder: (context) => const FolderHomeWidget(
          curve: Curves.easeInOutBack, title: 'EaseInOutBack'),
    ),
    AnimationExample(
      title: 'Smoke',
      builder: (context) => const SmokeHomeWidget(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
    AnimationExample(
      title: 'Books',
      builder: (context) =>
          const BookShelfPage(title: 'Flutter Demo Home Page'),
    ),
    AnimationExample(
      title: 'CircleSelector',
      builder: (context) => const CirclesHomeWidget(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: '3D Vinyl',
      builder: (context) => const VinylHomeWidget(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'BlurFade',
      builder: (context) => BlurFadeExample(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'FrostyCard',
      builder: (context) => FrostyCardDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Border beam',
      builder: (context) => BorderBeamHomeWidget(),
    ),
    AnimationExample(
      title: 'Meteors',
      builder: (context) => MeteorDemo(),
    ),
    AnimationExample(
      title: 'Neon Card',
      builder: (context) => NeonGradientCardDemo(),
    ),
  ];

  HomeScreen({super.key});

  void enterFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  void exitFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animation Showcase'),
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: examples.length,
        itemBuilder: (context, index) {
          return Hero(
            tag: 'example_${examples[index].title}',
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        if (examples[index].isFullScreen) {
                          return FullScreen(
                              key: UniqueKey(), example: examples[index]);
                        } else {
                          return DetailScreen(
                              key: UniqueKey(), example: examples[index]);
                        }
                      },
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.animation,
                        size: 48, color: Colors.white70),
                    const SizedBox(height: 8),
                    Text(
                      examples[index].title,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final AnimationExample example;

  const DetailScreen({super.key, required this.example});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(example.title),
        elevation: 0,
        backgroundColor: example.appBarColor ?? Theme.of(context).primaryColor,
      ),
      body: Hero(
        tag: 'example_${example.title}',
        child: example.builder(context),
      ),
    );
  }
}

class FullScreen extends StatelessWidget {
  final AnimationExample example;

  const FullScreen({super.key, required this.example});

  @override
  Widget build(BuildContext context) {
    return example.builder(context);
  }
}
