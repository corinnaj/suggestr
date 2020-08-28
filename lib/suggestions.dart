import 'dart:html';

import 'package:flutter/material.dart';
import 'package:suggestr/data.dart';

enum Size { VerySmall, Small, Medium, Large }

class Suggestions extends StatelessWidget {
  final List<Suggestion> suggestions;
  Suggestions(this.suggestions);

  Size getSize(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width > 1500)
      return Size.Large;
    else if (width > 1000)
      return Size.Medium;
    else if (width > 500) return Size.Small;
    return Size.VerySmall;
  }

  // ignore: missing_return
  double getFontSize(Size size) {
    switch (size) {
      case Size.VerySmall:
        return 18;
      case Size.Small:
        return 22;
      case Size.Medium:
        return 26;
      case Size.Large:
        return 30;
    }
  }

  // ignore: missing_return
  double getGradientHeight(Size size) {
    switch (size) {
      case Size.VerySmall:
        return 50;
      case Size.Small:
        return 75;
      case Size.Medium:
        return 100;
      case Size.Large:
        return 120;
    }
  }

  Widget buildChild(BuildContext context, Suggestion suggestion, {bool dragging = false}) {
    Size size = getSize(context);
    return Stack(children: <Widget>[
      Positioned.fill(child: suggestion.getImage()),
      if (dragging)
        Positioned.fill(
          child: Container(
            color: Colors.black54,
          ),
        ),
      Positioned(
        bottom: 0,
        height: getGradientHeight(size),
        left: 0,
        right: 0,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black, Colors.black.withOpacity(0.3), Colors.transparent],
                //stops: [0.5, 0.9],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter),
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        left: 4,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            suggestion.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: getFontSize(size),
              //shadows: [Shadow(color: Colors.black, blurRadius: 4), Shadow(color: Colors.black, blurRadius: 8)],
            ),
          ),
        ),
      ),
    ]);
  }

  Widget buildSuggestion(BuildContext context, int index, Suggestion suggestion) {
    return Draggable<Suggestion>(
      feedback: Opacity(
        opacity: 0.5,
        child: suggestion.getImage(width: 100, height: 60),
      ),
      childWhenDragging: buildChild(context, suggestion, dragging: true),
      data: suggestion,
      child: buildChild(context, suggestion),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 4,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: (3 / 2),
          children: suggestions
              .asMap()
              .map((int index, Suggestion suggestion) => MapEntry(index, buildSuggestion(context, index, suggestion)))
              .values
              .toList()),
    );
  }
}
