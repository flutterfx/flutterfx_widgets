import 'package:flutter/material.dart';
import 'package:fx_2_folder/book-open/book_open.dart';
import 'package:fx_2_folder/book-open/design/book_cover.dart';
import 'package:fx_2_folder/book-open/grid.dart';

class BookOpenDemo extends StatefulWidget {
  const BookOpenDemo({Key? key}) : super(key: key);

  @override
  State<BookOpenDemo> createState() => _BookOpenState();
}

class _BookOpenState extends State<BookOpenDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: GridPatternPainter(isDarkMode: true),
            ),
          ),
          const AnimatedBook(
            coverChild: MinimalistBookCover(
              title: 'The Subtle Art\nof Not Giving\na F*ck',
              author: 'Mark Manson',
              backgroundColor: Color(0xFFFF6B6B),
              textColor: Colors.white,
            ),
            pageChild: Text('Book content ..'),
            width: 100, // customize size
            height: 150,
            maxOpenAngle: 89, // adjust opening angle if needed
          ),
        ],
      ),
    );
  }
}
