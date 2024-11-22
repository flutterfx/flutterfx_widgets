// import 'package:flutter/material.dart';
// import 'package:fx_2_folder/thanos-snap/thanos_snap.dart';

// class ThanosSnapDemo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final GlobalKey<_ThanosSnapEffectState> snapKey = GlobalKey();

//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ThanosSnapEffect(
//               key: snapKey,
//               duration: Duration(milliseconds: 1000),
//               onComplete: () {
//                 print('Snap effect completed!');
//               },
//               child: Container(
//                 width: 200,
//                 height: 200,
//                 decoration: BoxDecoration(
//                   color: Colors.blue,
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Center(
//                   child: Text('Snap Me!'),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 snapKey.currentState?.snap();
//               },
//               child: Text('Trigger Snap Effect'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
