// import 'package:flutter/material.dart';
// import 'dart:ui' as ui;

// import 'package:flutter_shaders/flutter_shaders.dart';

// class ThanosSnapEffect extends StatefulWidget {
//   final Widget child;
//   final VoidCallback? onComplete;
//   final Duration duration;

//   const ThanosSnapEffect({
//     Key? key,
//     required this.child,
//     this.onComplete,
//     this.duration = const Duration(milliseconds: 1000),
//   }) : super(key: key);

//   @override
//   _ThanosSnapEffectState createState() => _ThanosSnapEffectState();
// }

// class _ThanosSnapEffectState extends State<ThanosSnapEffect>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   ui.Image? _capturedImage;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: widget.duration,
//       vsync: this,
//     )..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           widget.onComplete?.call();
//         }
//       });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Future<void> _captureWidget() async {
//     final boundary = context.findRenderObject() as RenderRepaintBoundary;
//     final image = await boundary.toImage();
//     setState(() {
//       _capturedImage = image;
//     });
//   }

//   void snap() async {
//     await _captureWidget();
//     _controller.forward();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return RepaintBoundary(
//       child: _capturedImage == null
//           ? widget.child
//           : ShaderBuilder(
//               assetKey: 'shaders/thanos_effect.frag',
//               (context, shader, child) {
//                 return AnimatedBuilder(
//                   animation: _controller,
//                   builder: (context, child) {
//                     shader
//                       ..setFloat('iTime', _controller.value)
//                       ..setFloat('dissolveScale', _controller.value * 2.0)
//                       ..setFloat(
//                           'iResolution', MediaQuery.of(context).size.width)
//                       ..setFloat(
//                           'iResolution', MediaQuery.of(context).size.height)
//                       ..setImageSampler('iImage', _capturedImage!);

//                     return CustomPaint(
//                       painter: ShaderPainter(shader),
//                       size: MediaQuery.of(context).size,
//                     );
//                   },
//                 );
//               },
//             ),
//     );
//   }
// }

// class ShaderPainter extends CustomPainter {
//   final ui.FragmentShader shader;

//   ShaderPainter(this.shader);

//   @override
//   void paint(Canvas canvas, Size size) {
//     canvas.drawRect(
//       Rect.fromLTWH(0, 0, size.width, size.height),
//       Paint()..shader = shader,
//     );
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }
