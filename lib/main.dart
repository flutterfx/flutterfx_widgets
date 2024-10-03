import 'package:flutter/material.dart';
import 'package:fx_2_folder/books/books.dart';
import 'package:fx_2_folder/folder_shape/folder_home.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(AnimationShowcaseApp());

class AnimationShowcaseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fx-widget Showcase',
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF1E1E1E),
        scaffoldBackgroundColor: Color(0xFF121212),
        cardColor: Color(0xFF2C2C2C),
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

  AnimationExample({required this.title, required this.builder});
}

class HomeScreen extends StatelessWidget {
  final List<AnimationExample> examples = [
    AnimationExample(
      title: 'Folder',
      builder: (context) => const FolderHomeWidget(
          curve: Curves.easeInOutBack, title: 'EaseInOutBack'),
    ),
    AnimationExample(
      title: 'Books',
      builder: (context) =>
          const BookShelfPage(title: 'Flutter Demo Home Page'),
    ),
    // AnimationExample(
    //   title: 'Smoke',
    //   builder: (context) => const FolderHomeWidget(
    //       curve: Curves.easeInOutBack, title: 'EaseInOutBack'),
    // ),
    // Add more examples here
  ];

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
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DetailScreen(example: examples[index]),
                  ),
                ),
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
      ),
      body: Hero(
        tag: 'example_${example.title}',
        child: example.builder(context),
      ),
    );
  }
}
