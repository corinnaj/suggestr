import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:suggestr/constants.dart';
import 'package:suggestr/data.dart';

class Days extends StatelessWidget {
  final List<Meal> selectedMeals;
  final Function onSuggestedMealChanged;
  final Function shouldShowBubble;
  Days(this.selectedMeals, this.onSuggestedMealChanged, this.shouldShowBubble);

  String exportMealPlan() {
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

  Widget buildExportButton(BuildContext context, Color color) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: RaisedButton(
        hoverColor: color.withOpacity(0.1),
        highlightColor: color.withOpacity(0.1),
        splashColor: color,
        color: Colors.white,
        textColor: Colors.black,
        onPressed: () {
          Clipboard.setData(ClipboardData(text: exportMealPlan()));
          SnackBar snackBar = SnackBar(
              content: Text('Plan copied to clip board'),
              action: SnackBarAction(label: 'Dismiss', onPressed: () => Scaffold.of(context).hideCurrentSnackBar()));
          Scaffold.of(context).showSnackBar(snackBar);
        },
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
              onSuggestedMealChanged,
              shouldShowBubble: shouldShowBubble(i),
            ),
          ),
        )
        .toList();
  }

  Widget buildOneRowLayout(BuildContext context, Color color) {
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
              child: buildExportButton(context, color),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTwoRowLayout(BuildContext context, Color color) {
    return Column(
      children: [
        Expanded(child: Row(children: getDaysFor(List.generate(4, (index) => index)))),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...getDaysFor(List.generate(3, (index) => index + 4)),
              Expanded(
                child: buildExportButton(context, color),
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
            ? buildTwoRowLayout(context, Theme.of(context).accentColor)
            : buildOneRowLayout(context, Theme.of(context).accentColor),
      ),
    );
  }
}

class NameDialog extends StatefulWidget {
  final Function onSubmit;

  NameDialog(this.onSubmit);

  @override
  _NameDialogState createState() => _NameDialogState();
}

class _NameDialogState extends State<NameDialog> {
  TextEditingController controller = TextEditingController();
  bool prepareInAdvance = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            autofocus: true,
            onSubmitted: (s) => widget.onSubmit(controller.text, prepareInAdvance),
            controller: controller,
            decoration: InputDecoration(
              labelText: 'What do you want to cook?',
            ),
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Checkbox(
                activeColor: Theme.of(context).primaryColor,
                onChanged: (bool value) => setState(() => prepareInAdvance = value),
                value: prepareInAdvance,
              ),
              Text('Needs to be prepared in advance'),
            ],
          )
        ],
      ),
      actions: [
        RaisedButton(
          color: Theme.of(context).primaryColor,
          child: Text('Confirm'),
          onPressed: () => widget.onSubmit(controller.text, prepareInAdvance),
        )
      ],
    );
  }
}

class Day extends StatefulWidget {
  final int dayIndex;
  final bool shouldShowBubble;
  final Meal meal;
  final Function onSuggestedMealChanged;
  Day(this.dayIndex, this.meal, this.onSuggestedMealChanged, {this.shouldShowBubble = false});

  @override
  _DayState createState() => _DayState();
}

class _DayState extends State<Day> {
  Meal hoveredMeal;

  void onSubmit(String text, bool prepareInAdvance) {
    setState(() {
      Meal old = widget.meal;
      widget.onSuggestedMealChanged(
          widget.dayIndex,
          Meal(
            text,
            old.pictureUrl,
            old.description,
            prepareInAdvance: prepareInAdvance,
          ));
      Navigator.of(context).pop();
    });
  }

  Widget image() {
    if (hoveredMeal != null) return hoveredMeal.getImage();
    if (widget.meal != null) return widget.meal.getImage();
    return Container();
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
    return DragTarget<DraggedMeal>(
      onAccept: (s) {
        setState(() {
          hoveredMeal = null;
        });
        widget.onSuggestedMealChanged(widget.dayIndex, s.meal);
        if (s.swapIndex != null) {
          widget.onSuggestedMealChanged(s.swapIndex, widget.meal);
        }
        if (s.meal.name == 'Something New') {
          showDialog(context: context, builder: (context) => NameDialog(onSubmit));
        }
      },
      onWillAccept: (s) {
        setState(() {
          hoveredMeal = s.meal;
        });
        return true;
      },
      onLeave: (s) => setState(() {
        hoveredMeal = null;
      }),
      builder: (context, candidate, rejected) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            child: Draggable<DraggedMeal>(
              data: DraggedMeal(widget.meal, swapIndex: widget.dayIndex),
              dragAnchor: DragAnchor.pointer,
              feedback: Opacity(
                opacity: 0.5,
                child: widget.meal != null ? widget.meal.getImage(width: 100, height: 60) : Container(),
              ),
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
                  if (widget.meal != null)
                    Positioned.fill(
                      child: Text(
                        widget.meal.name,
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
          ),
        );
      },
    );
  }
}
