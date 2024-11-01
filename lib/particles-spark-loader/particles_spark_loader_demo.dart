// particles_demo.dart
import 'package:flutter/material.dart';
import 'package:fx_2_folder/particles-github-spark/particles_github_spark.dart';
import 'package:fx_2_folder/particles-spark-loader/particles_spark_loader.dart';
import 'package:fx_2_folder/particles/particles_widget.dart';

class ParticlesSparkLoaderDemo extends StatefulWidget {
  const ParticlesSparkLoaderDemo({Key? key}) : super(key: key);

  @override
  State<ParticlesSparkLoaderDemo> createState() => _ParticlesDemoState();
}

class _ParticlesDemoState extends State<ParticlesSparkLoaderDemo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: double.infinity,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: const Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 25,
                  height: 25,
                  child: StepRotatingShape(
                    size: 25,
                    rotationDuration: const Duration(
                        milliseconds: 600), // Duration of each 45° rotation
                    pauseDuration: const Duration(
                        milliseconds: 300), // Pause duration between rotations
                    color: Color(0xFF8157E8),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Compiling creative thoughts..',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Positioned.fill(
              child: RisingParticles(
                quantity: 20,
                maxSize: 8,
                minSize: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
