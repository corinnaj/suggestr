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

  Widget buildExportButton(Color color) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: RaisedButton(
        hoverColor: color.withOpacity(0.1),
        highlightColor: color.withOpacity(0.1),
        splashColor: color,
        color: Colors.white,
        textColor: Colors.black,
        onPressed: () => Clipboard.setData(ClipboardData(text: exportSuggestions())),
        child: Icon(Icons.content_copy),
      ),
    );
  }

  List<Widget> getDaysFor(List<int> indices) {
    return indices
        .map(
          (i) => Expanded(
            child: Day(
              i,
              selectedMeals[i],
              onSuggestionChanged,
              shouldShowBubble: shouldShowBubble(i),
            ),
          ),
        )
        .toList();
  }

  Widget buildOneRowLayout(Color color) {
    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: BoxConstraints.loose(Size.fromWidth(1500)),
        child: Row(
          children: [
            ...getDaysFor(List.generate(7, (index) => index)),
            Container(
              width: 70,
              height: double.infinity,
              child: buildExportButton(color),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTwoRowLayout(Color color) {
    return Column(
      children: [
        Expanded(child: Row(children: getDaysFor(List.generate(4, (index) => index)))),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...getDaysFor(List.generate(3, (index) => index + 4)),
              Expanded(
                child: buildExportButton(color),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    bool smallLayout = MediaQuery.of(context).size.width < 800;
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).primaryColor, Theme.of(context).accentColor],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: smallLayout
            ? buildTwoRowLayout(Theme.of(context).accentColor)
            : buildOneRowLayout(Theme.of(context).accentColor),
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

  Widget image() {
    if (hoveredSuggestion != null) return hoveredSuggestion.getImage();
    if (widget.suggestion != null) return widget.suggestion.getImage();
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

  Widget buildBubble() {
    double size = 6;
    return Positioned(
      top: -size,
      left: -size,
      width: 2 * size,
      height: 2 * size,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size),
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
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            child: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white.withOpacity(0.2),
                    ),
                    child: image(),
                    clipBehavior: Clip.antiAlias,
                  ),
                ),
                if (widget.suggestion != null)
                  Positioned.fill(
                    child: Text(
                      widget.suggestion.name,
                      style: TextStyle(color: Colors.white, fontSize: 20, shadows: [
                        Shadow(color: Colors.black, blurRadius: 4),
                        Shadow(color: Colors.black, blurRadius: 8)
                      ]),
                    ),
                    left: 8,
                    top: 4,
                  ),
                Positioned(
                  child: Text(
                    days[widget.dayIndex],
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, shadows: []),
                  ),
                  bottom: 4,
                  left: 8,
                ),
                if (widget.shouldShowBubble) buildBubble(),
              ],
            ),
          ),
        );
      },
    );
  }
}
