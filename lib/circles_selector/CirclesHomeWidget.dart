import 'package:flutter/material.dart';

class CirclesHomeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CircleHomeState();
}

class _CircleHomeState extends State<CirclesHomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollableCircleGrid(),
    );
  }
}

class ScrollableCircleGrid extends StatefulWidget {
  @override
  _ScrollableCircleGridState createState() => _ScrollableCircleGridState();
}

class _ScrollableCircleGridState extends State<ScrollableCircleGrid> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        bool isSelected = selectedIndex == index;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = isSelected ? null : index;
            });
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.all(isSelected ? 8 : 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Colors.white : Colors.grey,
            ),
            child: Center(
              child: Text('Friend $index'),
            ),
          ),
        );
      },
    );
  }
}
