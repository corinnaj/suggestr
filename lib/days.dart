import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:suggestr/constants.dart';
import 'package:suggestr/data.dart';

class Days extends StatelessWidget {
  final List<Suggestion> selectedMeals;
  final Function onSuggestionChanged;
  final Function shouldShowBubble;
  Days(this.selectedMeals, this.onSuggestionChanged, this.shouldShowBubble);

  String exportSuggestions() {
    String result = '';
    for (int i = 0; i < 7; i++) {
      if (selectedMeals[i] != null || shouldShowBubble(i)) {
        result += days[i];
        result += ':\n';
        if (shouldShowBubble(i)) {
          result += 'Prepare ' + selectedMeals[i + 1].name + '!!';
          result += '\n';
        }
        if (selectedMeals[i] != null) {
          result += selectedMeals[i].name;
          result += '\n';
          result += selectedMeals[i].description;
        }
        result += '\n\n';
      }
    }
    return result;
  }

  Widget build(BuildContext context) {
    Color c = Theme.of(context).accentColor;
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).primaryColor, Theme.of(context).accentColor],
        ),
      ),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(top: 6.0, bottom: 12.0, right: 18.0, left: 18.0),
        child: Row(
          children: [
            ...List.generate(7, (index) => index).map(
              (i) => Expanded(
                child: Day(
                  i,
                  selectedMeals[i],
                  onSuggestionChanged,
                  shouldShowBubble: shouldShowBubble(i),
                ),
              ),
            ),
            Container(
              width: 60,
              height: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 6.0, top: 20.0, bottom: 14.0),
                child: RaisedButton(
                  hoverColor: c.withOpacity(0.1),
                  highlightColor: c.withOpacity(0.1),
                  splashColor: c,
                  color: Colors.white,
                  textColor: Colors.black,
                  onPressed: () => Clipboard.setData(ClipboardData(text: exportSuggestions())),
                  child: Icon(Icons.content_copy),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Day extends StatefulWidget {
  final int dayIndex;
  final bool shouldShowBubble;
  final Suggestion suggestion;
  final Function onSuggestionChanged;
  Day(this.dayIndex, this.suggestion, this.onSuggestionChanged, {this.shouldShowBubble = false});

  @override
  _DayState createState() => _DayState();
}

class _DayState extends State<Day> {
  Suggestion hoveredSuggestion;
  TextEditingController controller = TextEditingController();
  final double heigth = 150;

  Widget image() {
    if (hoveredSuggestion != null) return hoveredSuggestion.getImage(height: heigth);
    if (widget.suggestion != null) return widget.suggestion.getImage(height: heigth);
    return Container();
  }

  showNameDialog() {
    showDialog(
      context: context,
      builder: (context) {
        void onSubmit() {
          setState(() {
            Suggestion old = widget.suggestion;
            widget.onSuggestionChanged(widget.dayIndex, Suggestion(controller.text, old.pictureUrl, old.description));
            Navigator.of(context).pop();
          });
        }

        return AlertDialog(
          content: TextField(
            autofocus: true,
            onSubmitted: (s) => onSubmit(),
            controller: controller,
            decoration: InputDecoration(labelText: 'What do you want to cook?'),
          ),
          actions: [
            RaisedButton(
              child: Text('Confirm'),
              onPressed: () => onSubmit(),
            )
          ],
        );
      },
    );
  }

  Widget buildBubble(double size) {
    return Positioned(
      width: 2 * size,
      height: 2 * size,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(size)),
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<Suggestion>(
      onAccept: (s) {
        setState(() {
          hoveredSuggestion = null;
        });
        widget.onSuggestionChanged(widget.dayIndex, s);
        if (s.name == 'Something New') {
          showNameDialog();
        }
      },
      onWillAccept: (s) {
        setState(() {
          hoveredSuggestion = s;
        });
        return true;
      },
      onLeave: (s) => setState(() {
        hoveredSuggestion = null;
      }),
      builder: (context, candidate, rejected) {
        const double bubbleSize = 6;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8 - bubbleSize),
          child: Container(
            height: heigth + bubbleSize,
            child: Stack(children: <Widget>[
              Positioned.fill(
                top: bubbleSize,
                left: bubbleSize,
                child: Container(
                  color: Colors.white.withOpacity(0.2),
                  height: heigth,
                  child: image(),
                ),
              ),
              if (widget.suggestion != null)
                Positioned(
                  child: Text(
                    widget.suggestion.name,
                    style: TextStyle(color: Colors.white, fontSize: 20, shadows: [
                      Shadow(color: Colors.black, blurRadius: 4),
                      Shadow(color: Colors.black, blurRadius: 8)
                    ]),
                  ),
                  width: 200,
                  left: 8 + bubbleSize,
                  top: 4 + bubbleSize,
                ),
              Positioned(
                child: Text(
                  days[widget.dayIndex],
                  style: TextStyle(color: Colors.white, fontSize: 40, shadows: [
                    Shadow(color: Colors.black, blurRadius: 4),
                    Shadow(color: Colors.black, blurRadius: 8)
                  ]),
                ),
                bottom: 4,
                left: 8 + bubbleSize,
              ),
              if (widget.shouldShowBubble) buildBubble(bubbleSize),
            ]),
          ),
        );
      },
    );
  }
}
