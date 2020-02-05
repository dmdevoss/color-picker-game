import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(Locor());

class Locor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'loCor',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: LevelSelectPage(title: 'Color Picker: The Game'),
    );
  }
}



class LevelSelectPage extends StatefulWidget {
  LevelSelectPage({Key key, this.title}) : super(key: key);

  final String title;


  @override
  _LevelSelectPageState createState() => _LevelSelectPageState();
}

class _LevelSelectPageState extends State<LevelSelectPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Difficulty Select",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20
              )
            ),
            RaisedButton(
              child: Text('No'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FancyPickerPage()),
                );
              },
            ),
            RaisedButton(
              child: Text('Normal'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ColorPickerPage(difficulty: 1, title: "Normal Mode")),
                );
              },
            ),
            RaisedButton(
              child: Text('Hard'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ColorPickerPage(difficulty: 2, title: "Hard Mode")),
                );
              },
            ),
            RaisedButton(
              child: Text('Impossible'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ColorPickerPage(difficulty: 3, title: "Impossible Mode")),
                );
              },
            )
          ]
        )
      )
    );
  }
}

class ColorPickerPage extends StatefulWidget {
  ColorPickerPage({Key key, this.difficulty, this.title}) : super(key: key);

  final int difficulty;
  final String title;


  @override
  _ColorPickerPageState createState() => _ColorPickerPageState();
}



class _ColorPickerPageState extends State<ColorPickerPage> {
  int _green = 0;
  int _blue = 0;
  int _red = 0;
  double _score = 0;
  int _incorrectColorPoints = 0;
  int _difficulty = 0;
  int _sliderDivisions = 0;
  Color _creation = Color.fromRGBO(0, 0, 0, 1.0);

  // Generate a random Color
  int _goalGreen = 0;
  int _goalBlue = 0;
  int _goalRed = 0;
  String _scoreText = "";
  Color _goalColor = Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0).withOpacity(1.0);

  void _checkColors() {
    setState(() {
      _incorrectColorPoints = (_goalGreen - _green).abs() + (_goalBlue - _blue).abs() + (_goalRed - _red).abs();

      _score = (1 - (_incorrectColorPoints / 750)) * 100;

      if(_score == 100) {
        _scoreText = "BOOM! You win.";
      } else {
        _scoreText = 'Nice try! You got $_incorrectColorPoints points off, for a score of ' + _score.round().toString() + '%.';
        _generateNewGoal();
      }

    });
  }

  void _generateNewGoal() {

    _difficulty = widget.difficulty ?? 1;

    switch(_difficulty) {
      case 1:
        _sliderDivisions = 10;
        _goalGreen = (math.Random().nextInt(250) / 25).round() * 25;
        _goalBlue = (math.Random().nextInt(250) / 25).round() * 25;
        _goalRed = (math.Random().nextInt(250) / 25).round() * 25;
        break;
      case 2:
        _sliderDivisions = 25;
        _goalGreen = (math.Random().nextInt(250) / 10).round() * 10;
        _goalBlue = (math.Random().nextInt(250) / 10).round() * 10;
        _goalRed = (math.Random().nextInt(250) / 10).round() * 10;
        break;
      case 3:
        _sliderDivisions = 250;
        _goalGreen = math.Random().nextInt(250);
        _goalBlue = math.Random().nextInt(250);
        _goalRed = math.Random().nextInt(250);
        break;

    }
    // Generate a new random Color
    _goalColor = Color.fromRGBO(_goalRed, _goalGreen, _goalBlue, 1.0);
  }

  @override
  Widget build(BuildContext context) {

    if(_difficulty == 0) {
      _generateNewGoal();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ??  "Color Picker: The Game"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Recreate the color below using the RGB sliders below.'
            ),
            Container(height: 150, color: _goalColor),
            Container(height: 150, color: _creation),
            Text(
              _scoreText,
            ),
            Slider(
                value: _red.toDouble(),
                min: 0,
                max: 250,
                divisions: _sliderDivisions,
                activeColor: Colors.red,
                inactiveColor: Colors.black,
                label: 'Red $_red reporting.',
                onChanged: (double newValue) {
                  setState(() {
                    _red = newValue.round();
                    _creation = Color.fromRGBO(_red, _green, _blue, 1.0);
                  });
                }
            ),
            Slider(
                value: _blue.toDouble(),
                min: 0,
                max: 250,
                divisions: _sliderDivisions,
                activeColor: Colors.blue,
                inactiveColor: Colors.black,
                label: 'Blue $_blue on your six.',
                onChanged: (double newValue) {
                  setState(() {
                    _blue = newValue.round();
                    _creation = Color.fromRGBO(_red, _green, _blue, 1.0);
                  });
                }
            ),
            Slider(
                value: _green.toDouble(),
                min: 0,
                max: 250,
                divisions: _sliderDivisions,
                activeColor: Colors.green,
                inactiveColor: Colors.black,
                label: 'Green $_green reading you five by five.',
                onChanged: (double newValue) {
                  setState(() {
                    _green = newValue.round();
                    _creation = Color.fromRGBO(_red, _green, _blue, 1.0);
                  });
                }
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _checkColors,
        tooltip: 'Done',
        child: Icon(Icons.done),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class FancyPickerPage extends StatefulWidget {
  FancyPickerPage({Key key}) : super(key: key);


  @override
  _FancyPickerPageState createState() => _FancyPickerPageState();
}

class _FancyPickerPageState extends State<FancyPickerPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text("Color Picker"),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                      "Fine...",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20
                      )
                  )
                ]
            )
        )
    );
  }
}

