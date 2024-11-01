// particles_demo.dart
import 'package:flutter/material.dart';
import 'package:fx_2_folder/particles-github-spark/particles_github_spark.dart';
import 'package:fx_2_folder/particles/particles_widget.dart';

class ParticlesGithubSparkDemo extends StatefulWidget {
  const ParticlesGithubSparkDemo({Key? key}) : super(key: key);

  @override
  State<ParticlesGithubSparkDemo> createState() => _ParticlesDemoState();
}

class _ParticlesDemoState extends State<ParticlesGithubSparkDemo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: double.infinity,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: const Stack(
          children: [
            Positioned.fill(
                child: RisingParticles(
              quantity: 20,
              colors: [Colors.blue, Colors.purple, Colors.pink],
              maxSize: 8,
              minSize: 5,
            )),
          ],
        ),
      ),
    );
  }
}
