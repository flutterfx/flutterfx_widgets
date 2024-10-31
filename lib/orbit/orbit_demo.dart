import 'package:flutter/material.dart';
import 'package:fx_2_folder/orbit/widget/orbit_widget.dart';

class OrbitDemo extends StatelessWidget {
  const OrbitDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(), // Set the default theme to dark mode
      darkTheme: ThemeData.dark(), // Set the dark theme to ensure it stays dark
      themeMode: ThemeMode.dark,
      home: const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: OrbitingCircles(
            children: [
              Icon(Icons.star),
              Icon(Icons.favorite),
              Icon(Icons.music_note),
            ],
            orbitDuration: 15, // 15 seconds per orbit
            startDelay: 0, // 5 seconds before starting
            orbitRadius: 60, // Base radius of 60 logical pixels
            showOrbitPaths: true,
          ),
        ),
      ),
    );
  }
}
