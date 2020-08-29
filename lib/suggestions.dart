import 'package:flutter/material.dart';
import 'package:suggestr/data.dart';

class Suggestions extends StatelessWidget {
  final List<Suggestion> suggestions;
  Suggestions(this.suggestions);

  Widget buildChild(BuildContext context, Suggestion suggestion, {bool dragging = false}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              child: suggestion.getImage(),
            ),
          ),
          if (dragging)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
              ),
            ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.black, Colors.black.withOpacity(0.3), Colors.transparent, Colors.transparent],
                    stops: [0, 0.4, 0.9, 1],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter),
              ),
            ),
          ),
          Positioned(
            bottom: 4,
            left: 8,
            right: 8,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Container(
                width: 120,
                child: Text(
                  suggestion.name,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSuggestion(BuildContext context, int index, Suggestion suggestion) {
    return Draggable<Suggestion>(
      dragAnchor: DragAnchor.pointer,
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
    bool horizontal = MediaQuery.of(context).size.height > MediaQuery.of(context).size.width;
    double padding = 16;
    return FittedBox(
      alignment: Alignment.topCenter,
      fit: BoxFit.contain,
      child: Container(
        width: horizontal ? 3.0 * (600 + padding) : 4.0 * (600 + padding),
        height: horizontal ? 4.0 * (400 + padding) : 3.0 * (400 + padding),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: GridView.count(
              shrinkWrap: true,
              primary: false,
              crossAxisCount: horizontal ? 3 : 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: (3 / 2),
              children: suggestions
                  .asMap()
                  .map((int index, Suggestion suggestion) =>
                      MapEntry(index, buildSuggestion(context, index, suggestion)))
                  .values
                  .toList()),
        ),
      ),
    );
  }
}
