import 'package:flutter/material.dart';
import 'package:fx_2_folder/toast/toast.dart';

class ToastDemo extends StatelessWidget {
  const ToastDemo({super.key});

  @override
  Widget build(BuildContext context) {
    int count = 0;
    return MaterialApp(
      home: ToastOverlay(
        child: Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                count++;
                ToastService().show('Toast message : + ${count}');
              },
              child: const Text('Show Toast'),
            ),
          ),
        ),
      ),
    );
  }
}
