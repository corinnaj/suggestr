import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:suggestr/data.dart';

const List<String> days = ['Thu', 'Fri', 'Sat', 'Sun', 'Mon', 'Tue', 'Wed'];

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Suggestr(),
    );
  }
}

class Suggestr extends StatefulWidget {
  @override
  _SuggestrState createState() => _SuggestrState();
}

class _SuggestrState extends State<Suggestr> {
  List<Suggestion> currentSuggestions;
  List<Suggestion> selectedMeals = List.generate(7, (index) => null);

  @override
  void initState() {
    super.initState();
    currentSuggestions = getNewSuggestions();
  }

  List<Suggestion> getNewSuggestions() {
    suggestions.shuffle();
    List<Suggestion> temp = suggestions.getRange(0, 12).toList();
    temp[0] = somethingNew;
    return temp;
  }

  String exportSuggestions() {
    String result = '';
    for (int i = 0; i < 7; i++) {
      if (selectedMeals[i] != null) {
        result += days[i];
        result += ':\n';
        result += selectedMeals[i].name;
        result += '\n';
        result += selectedMeals[i].description;
        result += '\n\n';
      }
    }
    return result;
  }

  void onSuggestionChanged(int index, Suggestion newSuggestion) {
    setState(() {
      selectedMeals[index] = newSuggestion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () => setState(() => currentSuggestions = getNewSuggestions()),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...days
                    .asMap()
                    .entries
                    .map((entry) => Day(entry.key, selectedMeals[entry.key], onSuggestionChanged))
                    .toList(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: exportSuggestions()));
                    },
                    child: Icon(Icons.content_copy),
                  ),
                )
              ],
            ),
          ),
          Suggestions(currentSuggestions),
        ],
      ),
    );
  }
}

class Day extends StatefulWidget {
  final int dayIndex;
  final Suggestion suggestion;
  final Function onSuggestionChanged;
  Day(this.dayIndex, this.suggestion, this.onSuggestionChanged);

  @override
  _DayState createState() => _DayState();
}

class _DayState extends State<Day> {
  Suggestion hoveredSuggestion;
  TextEditingController controller = TextEditingController();

  Widget image() {
    if (hoveredSuggestion != null) return hoveredSuggestion.getImage(150, 200);
    if (widget.suggestion != null) return widget.suggestion.getImage(150, 200);
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
      builder: (context, candidate, rejected) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
        child: Stack(children: <Widget>[
          Container(
            height: 150,
            width: 200,
            color: Colors.grey,
            child: image(),
          ),
          if (widget.suggestion != null)
            Positioned(
              child: Text(
                widget.suggestion.name,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    shadows: [Shadow(color: Colors.black, blurRadius: 4), Shadow(color: Colors.black, blurRadius: 8)]),
              ),
              width: 200,
              left: 8,
              top: 4,
            ),
          Positioned(
            child: Text(
              days[widget.dayIndex],
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  shadows: [Shadow(color: Colors.black, blurRadius: 4), Shadow(color: Colors.black, blurRadius: 8)]),
            ),
            bottom: 4,
            left: 8,
          ),
        ]),
      ),
    );
  }
}

class Suggestions extends StatelessWidget {
  final List<Suggestion> suggestions;
  Suggestions(this.suggestions);

  final double width = 400;
  final double height = 250;

  Widget buildChild(Suggestion suggestion, {bool dragging = false}) {
    return Container(
      width: width,
      height: height,
      child: Stack(children: <Widget>[
        suggestion.getImage(width, height),
        if (dragging)
          Container(
            color: Colors.black54,
            width: width,
            height: height,
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
                  fontSize: 30,
                  shadows: [Shadow(color: Colors.black, blurRadius: 4), Shadow(color: Colors.black, blurRadius: 8)]),
            ),
          ),
        ),
      ]),
    );
  }

  Widget buildSuggestion(int index, Suggestion suggestion) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Draggable<Suggestion>(
        feedback: Opacity(
          opacity: 0.5,
          child: suggestion.getImage(200, 150),
        ),
        childWhenDragging: buildChild(suggestion, dragging: true),
        data: suggestion,
        child: buildChild(suggestion),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
          children: suggestions
              .asMap()
              .map((int index, Suggestion suggestion) => MapEntry(index, buildSuggestion(index, suggestion)))
              .values
              .toList()),
    );
  }
}