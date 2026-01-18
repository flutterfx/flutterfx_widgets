import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextSwitcher extends StatefulWidget {
  final List<String> texts; // Accepting a list of texts

  TextSwitcher({Key? key, required this.texts}) : super(key: key);

  @override
  _TextSwitcherState createState() => _TextSwitcherState();
}

class _TextSwitcherState extends State<TextSwitcher> {
  int _currentIndex = 0;

  void _switchText() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % widget.texts.length; // Use widget.texts
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 34, 34, 34), // Background color
      alignment: Alignment.center, // Center the text in the container
      child: GestureDetector(
        onTap: _switchText,
        child: AnimatedSwitcher(
          duration: Duration(seconds: 1),
          transitionBuilder: (Widget child, Animation<double> animation) {
            final offsetAnimation = Tween<Offset>(
              begin: Offset(1.0, 0.0),
              end: Offset(0.0, 0.0),
            ).animate(animation);
            return SlideTransition(position: offsetAnimation, child: child);
          },
          child: Text(
            widget.texts[_currentIndex], // Accessing the texts from widget
            key: ValueKey<int>(_currentIndex),
            style: GoogleFonts.acme(fontSize: 32.0, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

