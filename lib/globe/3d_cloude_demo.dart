// lib/widgets/tech_stack_cloud.dart
import 'package:flutter/material.dart';
import 'package:fx_2_folder/globe/globe.dart';
import 'package:fx_2_folder/globe/icon_helper.dart';

class TechStackCloud extends StatelessWidget {
  final List<String> slugs = [
    "typescript",
    "javascript",
    "dart",
    "java",
    "react",
    "flutter",
    "android",
    "html5",
    "css3",
    "nodedotjs",
    "express",
    "nextdotjs",
    "prisma",
    "amazonaws",
    "postgresql",
    "firebase",
    "nginx",
    "vercel",
    "testinglibrary",
    "jest",
    "cypress",
    "docker",
    "git",
    "jira",
    "github",
    "gitlab",
    "visualstudiocode",
    "androidstudio",
    "sonarqube",
    "figma",
  ];

  TechStackCloud({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get icons using the helper
    final icons = TechStackIcons.getIconsFromSlugs(slugs);

    return Center(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(16),
        ),
        child: GlobeOfLogos(
          icons: icons,
          radius: 120,
          defaultIconColor: Colors.white70,
        ),
      ),
    );
  }
}

// Example page using the TechStackCloud
class TechStackDemo extends StatelessWidget {
  const TechStackDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: TechStackCloud(),
    );
  }
}
