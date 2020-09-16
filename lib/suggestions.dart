import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:suggestr/data.dart';
import 'package:url_launcher/url_launcher.dart';

class Suggestion extends StatefulWidget {
  @override
  _SuggestionState createState() => _SuggestionState();
  final int index;
  final Meal meal;
  Suggestion(this.index, this.meal);
}

class _SuggestionState extends State<Suggestion> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _frontScale;
  Animation<double> _backScale;

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _frontScale = new Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(new CurvedAnimation(
      parent: _animationController,
      curve: new Interval(0.0, 0.5, curve: Curves.easeIn),
    ));
    _backScale = new CurvedAnimation(
      parent: _animationController,
      curve: new Interval(0.5, 1.0, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Draggable<DraggedMeal>(
      dragAnchor: DragAnchor.pointer,
      feedback: Opacity(
        opacity: 0.5,
        child: widget.meal.getImage(width: 100, height: 60),
      ),
      childWhenDragging: buildChild(widget.meal, dragging: true),
      data: DraggedMeal(widget.meal),
      child: Stack(
        children: [
          AnimatedBuilder(
              child: buildChild(widget.meal),
              animation: _frontScale,
              builder: (BuildContext context, Widget child) {
                final Matrix4 transform = new Matrix4.identity()..scale(1.0, _frontScale.value, 1.0);
                return new Transform(
                  transform: transform,
                  alignment: FractionalOffset.center,
                  child: child,
                );
              }),
          AnimatedBuilder(
              animation: _backScale,
              child: buildDescriptionChild(widget.meal),
              builder: (BuildContext context, Widget child) {
                final Matrix4 transform = new Matrix4.identity()..scale(1.0, _backScale.value, 1.0);
                return new Transform(
                  transform: transform,
                  alignment: FractionalOffset.center,
                  child: child,
                );
              }),
        ],
      ),
    );
  }

  Widget backGroundImage(Meal meal) {
    return Positioned.fill(
      child: Container(
        child: meal.getImage(),
      ),
    );
  }

  Widget flipButton() {
    return Positioned(
      right: 0,
      child: IconButton(
        iconSize: 48.0,
        icon: Icon(
          Icons.help,
        ),
        color: Colors.white70,
        onPressed: () => setState(() {
          if (_animationController.isCompleted)
            _animationController.reverse();
          else
            _animationController.forward();
        }),
      ),
    );
  }

  Widget gradient() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.black, Colors.black.withOpacity(0.3), Colors.transparent, Colors.transparent],
              stops: [0, 0.4, 0.9, 1],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter),
        ),
      ),
    );
  }

  Widget greyOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black54,
      ),
    );
  }

  Widget mealTitle(Meal meal) {
    return Positioned(
      bottom: 4,
      left: 8,
      right: 8,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Container(
          width: 120,
          child: Text(
            meal.name,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildChild(Meal meal, {bool dragging = false}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: <Widget>[
          backGroundImage(meal),
          gradient(),
          if (dragging) greyOverlay(),
          mealTitle(meal),
          flipButton(),
        ],
      ),
    );
  }

  Widget buildDescriptionChild(Meal meal) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: <Widget>[
          backGroundImage(meal),
          Positioned.fill(
            child: Container(
              color: Colors.white60,
            ),
          ),
          Positioned(
            left: 8.0,
            child: Text(meal.name, style: TextStyle(color: Colors.black, fontSize: 40)),
          ),
          Positioned(
            bottom: 8.0,
            left: 8.0,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Container(
                width: 550,
                child: buildDescriptionText(meal.description),
              ),
            ),
          ),
          flipButton(),
        ],
      ),
    );
  }

  Widget buildDescriptionText(String text) {
    TextStyle defaultStyle = TextStyle(color: Colors.black, fontSize: 30.0);
    TextStyle linkStyle = TextStyle(color: Colors.blue[800], fontSize: 30.0);

    List<String> parts = text.split(' ');
    RegExp urlMatcher = RegExp(r'[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)');

    return RichText(
      text: TextSpan(
        style: defaultStyle,
        children: parts
            .map((String part) => urlMatcher.hasMatch(part)
                ? TextSpan(
                    text: part + ' ',
                    style: linkStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        if (await canLaunch(part)) {
                          await launch(
                            part,
                            forceSafariVC: false,
                            forceWebView: false,
                            headers: <String, String>{'my_header_key': 'my_header_value'},
                          );
                        } else {
                          throw 'Could not launch $part';
                        }
                      })
                : TextSpan(text: part + ' '))
            .toList(),
      ),
    );
  }
}

class Suggestions extends StatelessWidget {
  final List<Meal> meals;
  Suggestions(this.meals);

  @override
  Widget build(BuildContext context) {
    bool horizontal = MediaQuery.of(context).size.height > MediaQuery.of(context).size.width;
    double padding = 16;
    return FittedBox(
      alignment: Alignment.topCenter,
      fit: BoxFit.contain,
      child: Container(
        width: horizontal ? 3.0 * (600 + padding) : 4.0 * (600 + padding),
        height: (horizontal ? 4.0 * (400 + padding) : 3.0 * (400 + padding)) + padding,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: GridView.count(
              shrinkWrap: true,
              primary: false,
              crossAxisCount: horizontal ? 3 : 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: (3 / 2),
              children: meals
                  .asMap()
                  .map((int index, Meal meal) => MapEntry(index, Suggestion(index, meal)))
                  .values
                  .toList()),
        ),
      ),
    );
  }
}
