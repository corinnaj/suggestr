import 'package:flutter/material.dart';
import 'package:suggestr/constants.dart';
import 'package:suggestr/data.dart';
import 'package:suggestr/days.dart';
import 'package:suggestr/suggestions.dart';

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

  bool shouldShowBubble(int index) {
    return index < days.length - 1 && selectedMeals[index + 1] != null && selectedMeals[index + 1].prepareInAdvance;
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
          Days(selectedMeals, onSuggestionChanged, shouldShowBubble),
          Suggestions(currentSuggestions),
        ],
      ),
    );
  }
}
