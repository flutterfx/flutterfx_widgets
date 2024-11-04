import 'package:flutter/material.dart';
import 'package:fx_2_folder/orbit/widget/orbit_widget.dart';
import 'package:fx_2_folder/text-on-path/text_on_path.dart';
import 'package:fx_2_folder/text-on-path/text_on_path_editor.dart';

class TextOnPathDemo extends StatelessWidget {
  const TextOnPathDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(), // Set the default theme to dark mode
      darkTheme: ThemeData.dark(), // Set the dark theme to ensure it stays dark
      themeMode: ThemeMode.dark,
      home: const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: TextOnPathEditor()),
      ),
    );
  }
}
