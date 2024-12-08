import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fx_2_folder/background-aurora/aurora_widget.dart';
import 'package:fx_2_folder/background-aurora/aurora_widget_demo.dart';
import 'package:fx_2_folder/background-beam/background_beam_demo.dart';
import 'package:fx_2_folder/background-exploding-beam/background_beam_explosion_demo.dart';
import 'package:fx_2_folder/background-flicker-grid/background_flicker_grid.dart';
import 'package:fx_2_folder/background-flickering-card/background_flickering_card.dart';
import 'package:fx_2_folder/background-grid-motion/background_grid_motion.dart';
import 'package:fx_2_folder/background-orbiral-star/background_orbital_star.dart';
import 'package:fx_2_folder/butterfly-interactive/butterfly_interactive_demo.dart';
import 'package:fx_2_folder/decoration-bulbs/decoration_bulbs_demo.dart';
import 'package:fx_2_folder/decoration-thread/decoration_thread.dart';
import 'package:fx_2_folder/decoration-thread/decoration_thread_demo_1.dart';
import 'package:fx_2_folder/filter-wave/wave_filter.dart';
import 'package:fx_2_folder/fractal-glass/fractal_glass.dart';
import 'package:fx_2_folder/fx_14_text_chaotic_spring/demo.dart';
import 'package:fx_2_folder/gemini-splash/gemini_splash_demo.dart';
import 'package:fx_2_folder/grid-animated/grid_animated.dart';
import 'package:fx_2_folder/infinite-scrolling/infinite_scrolling.dart';
import 'package:fx_2_folder/infinite-scrolling/infinite_scrolling_3d.dart';
import 'package:fx_2_folder/loader-avatars/loader_avatars_demo.dart';
import 'package:fx_2_folder/loader-avatars/loader_avatars_demo_2.dart';
import 'package:fx_2_folder/loader-square/loader_square_demo.dart';
import 'package:fx_2_folder/motion-blur/motion_blur_demo.dart';
import 'package:fx_2_folder/noise/noise.dart';
import 'package:fx_2_folder/noise/noise_demo.dart';
import 'package:fx_2_folder/orbit-blur/orbit_blur.dart';
import 'package:fx_2_folder/orbit-blur/orbit_blur_demo.dart';
import 'package:fx_2_folder/book-open/book_open_demo.dart';
import 'package:fx_2_folder/books/books.dart';
import 'package:fx_2_folder/bottom-sheet/bottom_sheet_demo.dart';
import 'package:fx_2_folder/butterfly/butterfly_demo.dart';
import 'package:fx_2_folder/button-shimmer/button_shimmer_demo.dart';
import 'package:fx_2_folder/celebrate/celebrate_demo.dart';
import 'package:fx_2_folder/circles_selector/CirclesHomeWidget.dart';
import 'package:fx_2_folder/confetti/confetti_demo.dart';
import 'package:fx_2_folder/dots/dots_demo.dart';
import 'package:fx_2_folder/folder_shape/folder_home.dart';
import 'package:fx_2_folder/frosty_card/frosty_card.dart';
import 'package:fx_2_folder/fx_10_hyper_text/hyper_text_demo.dart';
import 'package:fx_2_folder/fx_11_typing_animation/typing_anim_demo.dart';
import 'package:fx_2_folder/fx_12_rotating_text/text_rotate_demo.dart';
import 'package:fx_2_folder/fx_13_rotating_text_with_blur/text_rotate_blur_demo.dart';
import 'package:fx_2_folder/fx_14_text_reveal/text_reveal_demo.dart';
import 'package:fx_2_folder/fx_7_border_beam/border_beam.dart';
import 'package:fx_2_folder/fx_7_border_beam/border_beam_demo.dart';
import 'package:fx_2_folder/fx_8_meteor_border/meteors_demo.dart';
import 'package:fx_2_folder/fx_9_neon_card/neon_card_demo.dart';
import 'package:fx_2_folder/globe/3d_cloude_demo.dart';
import 'package:fx_2_folder/light_effect/light_effect_demo.dart';
import 'package:fx_2_folder/loader-sphere/loader_sphere_demo.dart';
import 'package:fx_2_folder/orbit/orbit_demo.dart';
import 'package:fx_2_folder/particles-github-spark/particles_github_spark_demo.dart';
import 'package:fx_2_folder/particles-spark-loader/particles_spark_loader_demo.dart';
import 'package:fx_2_folder/particles/particles_demo.dart';
import 'package:fx_2_folder/primitives/primitives_demo.dart';
import 'package:fx_2_folder/progress-bar/progress_bar_demo.dart';
import 'package:fx_2_folder/progress-bar/progress_bar_demo_2.dart';
import 'package:fx_2_folder/scroll-progress/scroll_progress_demo.dart';
import 'package:fx_2_folder/shader-learning/shader_1.dart';
import 'package:fx_2_folder/slider/slider.dart';
import 'package:fx_2_folder/slider/slider_demo.dart';
import 'package:fx_2_folder/smoke/smoke.dart';
import 'package:fx_2_folder/splash-reveal/sample_home_screen.dart';
import 'package:fx_2_folder/splash-reveal/splash_demo.dart';
import 'package:fx_2_folder/stacked-expand-cards/stacked_expand_card.dart';
import 'package:fx_2_folder/stacked-scroll/stacked_scroll_demo.dart';
import 'package:fx_2_folder/light-bulb-night-mode/light_bulb_demo.dart';
import 'package:fx_2_folder/text-3d-pop/text_3d_pop_demo.dart';
import 'package:fx_2_folder/text-on-path/text_on_path_demo.dart';
import 'package:fx_2_folder/stacked-cards/stacked_card.dart';
import 'package:fx_2_folder/thanos-snap/thanos_snap_demo.dart';
import 'package:fx_2_folder/ticker/ticker.dart';
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
        scaffoldBackgroundColor: Color.fromARGB(255, 0, 0, 0),
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
      title: 'FrostyCard[WIP]',
      builder: (context) => FrostyCardDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Border beam',
      builder: (context) => BorderBeamHomeWidget(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Meteors',
      builder: (context) => MeteorDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Neon Card',
      builder: (context) => NeonGradientCardDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Hyper Text',
      builder: (context) => HyperTextDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Typing animation',
      builder: (context) => TypingAnimationDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'RotatingText',
      builder: (context) => TextRotateDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'TextReveal',
      builder: (context) => AnimationDemoScreen(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Globe of Logos',
      builder: (context) => TechStackDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Celebrate',
      builder: (context) => CelebrateHomeWidget(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'LightEffect',
      builder: (context) => LightEffectWidgetDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Orbit',
      builder: (context) => OrbitDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Particles',
      builder: (context) => ParticlesDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Particles like GithubSpark',
      builder: (context) => const ParticlesGithubSparkDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'GithubSpark Loader',
      builder: (context) => ParticlesSparkLoaderDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'DotPattern',
      builder: (context) => DotPatternWidget(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Text On Path',
      builder: (context) => TextOnPathDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Background Beams',
      builder: (context) => BackgroundBeamDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Exploding Beams',
      builder: (context) => ExplodingBeamDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Motion Primitives[wip]',
      builder: (context) => MotionPrimitiveDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Work Life Slider',
      builder: (context) => SliderDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Stacked Scroll [WIP]',
      builder: (context) => StackedScrollDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Night Mode Bulb',
      builder: (context) => NightModeDemo(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
    AnimationExample(
      title: 'Stacked Cards',
      builder: (context) => StackedCardDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Stacked Expand Cards',
      builder: (context) => StackedExpandedCardDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Confetti [WIP]',
      builder: (context) => ConfettiDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Shimmer Button',
      builder: (context) => ButtonShimmerDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'BottomSheet',
      builder: (context) => BottomSheetDemo(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
    AnimationExample(
      title: 'ButterFly',
      builder: (context) => ButterflyDemo(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
    AnimationExample(
      title: 'BookOpen',
      builder: (context) => BookOpenDemo(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
    AnimationExample(
      title: 'RotatingBlurText [WIP]',
      builder: (context) => TextRotateBlurDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Scroll Progress',
      builder: (context) => ScrollProgressDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Sphere Loader',
      builder: (context) => LoaderSphereDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Text 3D Pop',
      builder: (context) => Text3dPopDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Aurora Background [WIP]',
      builder: (context) => AuroraDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Orbit with Blur',
      builder: (context) => OrbitExtendedDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Gemini Splash',
      builder: (context) => SparkleDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: 'Motion blur with Shader[wip]',
      builder: (context) => MotionStreakingDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: "Text Chaotic Spring",
      builder: (context) => TextChaoticSpringDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: "Interactive Butterfly",
      builder: (context) => ButterflyInteractiveDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: "ProgressBar",
      builder: (context) => ProgressBarDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: "Avatar Loader",
      builder: (context) => LoaderAvatarsDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: "ProgressBar - 2",
      builder: (context) => ProgressBarDemo2(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: "Avatar Loader - 2",
      builder: (context) => LoaderAvatarsDemo2(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: "Noise [WIP]",
      builder: (context) => PracticalNoiseShowcase(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: "Splash Circular Reveal",
      builder: (context) => LoadingApp1(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
    AnimationExample(
      title: "Oribtal Star",
      builder: (context) => BgOrbittalStarDemo(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
    AnimationExample(
      title: "Loader Square",
      builder: (context) => LoaderSquareDemo(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
    AnimationExample(
      title: "DecorationBulbsDemo",
      builder: (context) => DecorationBulbsDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: "DecorationThreadDemo",
      builder: (context) => GlowingThreadDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: "Grid Animation",
      builder: (context) => GridAnimatedDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: "Grid in Motion",
      builder: (context) => RetroGridDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: "Flickering Grid Demo",
      builder: (context) => FlickeringGridDemo(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
    AnimationExample(
      title: "Flickering Cards Demo",
      builder: (context) => ColorfulCardsDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: "[WIP] FractalGLass Effect",
      builder: (context) => FractalGlassDemo(),
      appBarColor: Colors.black,
    ),
    AnimationExample(
      title: "Moving Ticker Effect",
      builder: (context) => LayeredTickers(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
    AnimationExample(
      title: "Simple Shader",
      builder: (context) => SimpleShaderExample(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
    AnimationExample(
      title: "Infinite Scrolling",
      builder: (context) => MarqueeDemo(),
      appBarColor: Colors.black,
      isFullScreen: true,
    ),
    AnimationExample(
      title: "Infinite Scrolling 3D",
      builder: (context) => Marquee3D(),
      appBarColor: Colors.black,
      isFullScreen: true,
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
    // Automatically navigate to the first example on launch (e.g., "Folder").
    Future.microtask(() {
      if (examples.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DetailScreen(
                example: examples[examples.length - 1],
              ); // Automatically selecting the first example
            },
          ),
        );
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation Showcase'),
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
        itemCount: examples.length + 3,
        itemBuilder: (context, index) {
          if (index < examples.length) {
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
          } else {
            return SizedBox(
              height: MediaQuery.of(context)
                  .size
                  .height, // Adjust this value as needed
              child: Container(), // Empty container for spacing
            );
          }
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
