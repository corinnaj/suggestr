import 'dart:math';

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
    List<Color> colors = Colors.primaries.getRange(0, 16).toList();
    int i = Random().nextInt(colors.length);
    return MaterialApp(
      title: 'Suggestr',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: colors[i],
        accentColor: colors[(i + 2) % 15],
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white70),
        ),
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
  List<Meal> currentSuggestedMeals;
  List<Meal> selectedMeals = List.generate(7, (index) => null);
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentSuggestedMeals = getNewMeals();
  }

  List<Meal> getNewMeals() {
    meals.shuffle();
    List<Meal> temp = meals.sublist(0, 12);
    temp[0] = somethingNew;
    return temp;
  }

  List<Meal> getMealsFor(String filterString) {
    List<Meal> filtered = meals.where((s) => s.name.toLowerCase().contains(filterString.toLowerCase())).toList();
    int maxAmount = min(11, filtered.length);
    filtered = filtered.sublist(0, maxAmount);
    filtered.insert(0, somethingNew);
    return filtered;
  }

  bool shouldShowBubble(int index) {
    return index < days.length - 1 && selectedMeals[index + 1] != null && selectedMeals[index + 1].prepareInAdvance;
  }

  void onSuggestedMealChanged(int index, Meal newMeal) {
    setState(() {
      selectedMeals[index] = newMeal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () => setState(() => currentSuggestedMeals = getNewMeals()),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Days(selectedMeals, onSuggestedMealChanged, shouldShowBubble),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 8.0),
                  child: SizedBox(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (input) => (setState(() => currentSuggestedMeals = getMealsFor(input))),
                      style: TextStyle(color: Colors.white, decorationColor: Colors.white),
                    ),
                    width: 200,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    if (_searchController.text != "") {
                      _searchController.clear();
                      setState(() => currentSuggestedMeals = getNewMeals());
                    }
                  },
                ),
              ],
            ),
            Expanded(child: Suggestions(currentSuggestedMeals)),
          ],
        ),
      ),
    );
  }
}
