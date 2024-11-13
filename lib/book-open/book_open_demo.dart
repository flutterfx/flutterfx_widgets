import 'package:flutter/material.dart';

class BookOpenDemo extends StatefulWidget {
  const BookOpenDemo({Key? key}) : super(key: key);

  @override
  State<BookOpenDemo> createState() => _BookOpenState();
}

class _BookOpenState extends State<BookOpenDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: false,
        left: false,
        right: false,
        child: Text("BookOpen"),
      ),
    );
  }
}
