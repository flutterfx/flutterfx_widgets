import 'package:flutter/material.dart';
import 'package:getchereta/measure/consts.dart';
import 'package:getchereta/screens/eg2.dart';
import 'package:google_fonts/google_fonts.dart';

class TextSwitcherExample extends StatefulWidget {
  @override
  _TextSwitcherExampleState createState() => _TextSwitcherExampleState();
}

class _TextSwitcherExampleState extends State<TextSwitcherExample> {

  @override
  Widget build(BuildContext context) {
        AppSizes.init(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 34, 34),
      appBar: AppBar(title: Center(
        child: Text("Text Switcher Example", style: GoogleFonts.acme(
          color: Colors.white,
          fontSize: AppSizes.secondaryFontSize,
          fontWeight: FontWeight.bold
        ),),
      ), backgroundColor: Color.fromARGB(255, 34, 34, 34), automaticallyImplyLeading: false,),
      body: Center(
        child: TextSwitcher(texts: ["Hello", "World", "Flutter", "Animations", "Open Source."])
      ),
    );
  }
}

