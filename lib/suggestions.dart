import 'package:flutter/material.dart';
import 'package:suggestr/data.dart';

class Suggestions extends StatelessWidget {
  final List<Suggestion> suggestions;
  Suggestions(this.suggestions);

  final double width = 400;
  final double height = 240;

  double getFontSize(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width > 1500)
      return 30;
    else if (width > 1000)
      return 26;
    else if (width > 500) return 22;
    return 18;
  }

  Widget buildChild(BuildContext context, Suggestion suggestion, {bool dragging = false}) {
    return Container(
      width: width,
      height: height,
      child: Stack(children: <Widget>[
        Positioned.fill(child: suggestion.getImage()),
        if (dragging)
          Positioned.fill(
            child: Container(
              color: Colors.black54,
            ),
          ),
        Positioned(
          width: width,
          bottom: 0,
          left: 4,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              suggestion.name,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: getFontSize(context),
                  shadows: [Shadow(color: Colors.black, blurRadius: 4), Shadow(color: Colors.black, blurRadius: 8)]),
            ),
          ),
        ),
      ]),
    );
  }

  Widget buildSuggestion(BuildContext context, int index, Suggestion suggestion) {
    return Container(
      width: width,
      height: height,
      child: Draggable<Suggestion>(
        feedback: Opacity(
          opacity: 0.5,
          child: suggestion.getImage(width: 100, height: 60),
        ),
        childWhenDragging: buildChild(context, suggestion, dragging: true),
        data: suggestion,
        child: buildChild(context, suggestion),
      ),
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
          childAspectRatio: (width / height),
          children: suggestions
              .asMap()
              .map((int index, Suggestion suggestion) => MapEntry(index, buildSuggestion(context, index, suggestion)))
              .values
              .toList()),
    );
  }
}
