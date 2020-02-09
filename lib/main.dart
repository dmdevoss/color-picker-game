import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:locor/locor_widgets/homepage_button.dart';

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
            Divider(),
            HomepageButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ColorPickerPage(difficulty: 1, title: "Normal Mode"), fullscreenDialog: true),
                  );
                },
                buttonText: 'NORMAL'
            ),
            HomepageButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ColorPickerPage(difficulty: 2, title: "Hard Mode"), fullscreenDialog: true),
                  );
                },
                buttonText: 'HARD'
            ),
            HomepageButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ColorPickerPage(difficulty: 3, title: "Impossible Mode"), fullscreenDialog: true),
                  );
                },
                buttonText: 'IMPOSSIBLE'
            ),
            Divider(),
            HomepageButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ColorPickerPage(difficulty: 0, title: "Time Attack"), fullscreenDialog: true),
                  );
                },
                buttonText: 'TIME ATTACK'
            ),
            HomepageButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FancyPickerPage()),
                  );
                },
                buttonText: 'ZEN MODE'
            ),
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

  // constants
  final int timerMax = 20;

  // Current Slider Values
  int _green = 0;
  int _blue = 0;
  int _red = 0;
  Color _creation = Color.fromRGBO(0, 0, 0, 1.0);

  // Game variables
  int _streak = 0;
  int _topStreak = 0;
  int _bestTime = 0;
  double _score = 0;
  double _topScore = 0;
  int _incorrectColorPoints = 0;
  int _difficulty = -1;
  int _sliderDivisions = 0;
  bool _winMode = false;
  bool _loseMode = false;
  bool _timeAttackMode = false;
  int _timeRemaining;
  Timer _countdown;
  Stopwatch _stopwatch = new Stopwatch();
  Timer _stopwatchTimer;
  Duration _timeElapsed;

  String _topText = "";
  String _scoreText = "Recreate the color below using the RGB sliders below.";
  String _scoreTextTitle = "Game Time";

  // Current randomly generated goal color
  int _goalGreen = 0;
  int _goalBlue = 0;
  int _goalRed = 0;
  Color _goalColor = Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0).withOpacity(1.0);


  void _checkColors() {
    setState(() {
      _incorrectColorPoints = (_goalGreen - _green).abs() + (_goalBlue - _blue).abs() + (_goalRed - _red).abs();

      _score = (1 - (_incorrectColorPoints / 750)) * 100;

      if(_score == 100) {
        _playerWin();
      } else {
        if(_timeAttackMode) {
          // Do nothing, the color is always being checked in time attack.
        } else {
          _playerLose();
        }
      }

    });
  }

  void _playerWin() {
    setState(() {
      _streak = _streak + 1;
      _stopwatch.stop();
      _topText = "Excellent!";

      if(_timeAttackMode) {
        _generateNewGoal();
      } else {
        var timeScore = _stopwatch.elapsed.inSeconds;
        _topScore = 100;

        if(timeScore < _bestTime || _bestTime == 0) {
          _bestTime = timeScore;
          _scoreTextTitle = "Personal Best!";
        } else {
          _scoreTextTitle = "You can do better! ";
        }
        _scoreText = 'You won in $timeScore seconds.';
        _winMode = true;
      }
    });
  }

  void _playerLose() {
    setState(() {
      _loseMode = true;
      if(_timeAttackMode) {
        if(_streak > _topStreak) {
          _topStreak = _streak;
          _scoreTextTitle = "Personal Best!";
          _scoreText = 'You were on a $_streak game hot streak.';
        } else {
          _scoreTextTitle = "You can do better! ";
          _scoreText = 'You were on a streak of $_streak.';
        }
      } else {
        if(_score > _topScore) {
          _topScore = _score;
          _scoreTextTitle = "Personal Best!";
        } else {
          _scoreTextTitle = "You can do better! ";
        }
        _scoreText = 'You got $_incorrectColorPoints points off, for a score of ' + _score.round().toString() + '%.';
      }
      _streak = 0;
    });
  }

  void _generateNewGoal() {

    _difficulty = widget.difficulty ?? 1;

    if(_score > 0) {
      _scoreText = "";
      _scoreTextTitle = "";
    } else {
      _scoreText = "Recreate the circle's top color using the RGB sliders.";
    }

    switch(_difficulty) {
      case 0:
        _timeAttackMode = true;
        _sliderDivisions = 5;
        _goalGreen = (math.Random().nextInt(250) / 50).round() * 50;
        _goalBlue = (math.Random().nextInt(250) / 50).round() * 50;
        _goalRed = (math.Random().nextInt(250) / 50).round() * 50;
        break;
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
    _winMode = false;
    _loseMode = false;

    if(_timeAttackMode) {
      _startNewTimer();
    } else {
      _startNewStopwatch();
    }
  }

  void _startNewStopwatch() {

    _stopwatch.reset();
    _stopwatch.start();

    if(_stopwatchTimer != null) _stopwatchTimer.cancel();

    _stopwatchTimer = Timer.periodic(
        Duration(seconds: 1),
            (timer) => setState(
                () {
              if(_loseMode || _winMode) {
                _stopwatchTimer.cancel();
                _stopwatch.stop();
              } else {
                _timeElapsed = _stopwatch.elapsed;
              }
            }
        )
    );
  }

  void _startNewTimer() {
    _timeRemaining = this.timerMax;
    if(_countdown != null) _countdown.cancel();
    _countdown = Timer.periodic(
        Duration(seconds: 1),
            (timer) => setState(
                () {
              _timeRemaining = _timeRemaining - 1;
              if(this.timerMax - _timeRemaining == 2) {
                _topText = "";
              }
              if(_timeRemaining < 1) {
                _countdownExpired();
              }
            }
        )
    );
  }

  void _countdownExpired() {
    _countdown.cancel();
    _playerLose();
  }

  void _doneButtonPressed() {
    if(_timeAttackMode || _winMode || _loseMode) {
      _generateNewGoal();
    } else {
      _checkColors();
    }
  }

  void _updateCreation()  {
    setState(() {
      _creation = Color.fromRGBO(_red, _green, _blue, 1.0);
      if(_timeAttackMode) {
        _checkColors();
      }
    });
  }

  String _getTitle() {
      if(_winMode) {
        return "You Win!";
      } else if (_loseMode) {
        return "Game Over.";
      } else if(_streak > 0) {
        return "Hot Streak: $_streak";
      } else {
        return widget.title ?? "Color Picker: The Game";
      }
  }

  String _getTimeDisplay(){
    if(_timeAttackMode) {
      return _timeRemaining.toString();
    } else {
      if(_timeElapsed == null) return "0";
      else return _timeElapsed.inSeconds.toString();
    }
  }
  String _getDoneButtonText(){
    if(_timeAttackMode) {
      return "Restart";
    } else {
      if(_winMode || _loseMode) {
        return "Try Again?";
      } else {
        return "Submit";
      }
    }
  }

  // Destroy the timers when you leave the page
  @override
  void dispose() {
    if(_countdown != null) _countdown.cancel();
    if(_stopwatchTimer != null) _stopwatchTimer.cancel();
    if(_stopwatch != null) {
      _stopwatch.stop();
      _stopwatch.reset();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(_difficulty == -1) {
      _generateNewGoal();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 70,
              child: Text(
                  _getTimeDisplay(),
                  style: TextStyle(
                    fontSize: 30,
                  )
              ),
            ),
            SizedBox(
              height: 30,
              child: Text(
                  "$_scoreTextTitle",
                  style: TextStyle(
                    fontSize: 20,
                  )
              ),
            ),
            SizedBox(
              height: 20,
              child: Text(
                  "$_scoreText",
                  style: TextStyle(
                    fontSize: 15,
                  )
              ),
            ),
            Divider(),
            Container(
                height: 150,
                width: 300,
                decoration: new BoxDecoration(
                    color: _goalColor,
                    borderRadius: new BorderRadius.only(
                        topLeft:  const  Radius.circular(150.0),
                        topRight: const  Radius.circular(150.0)
                    )
                ),
                child:  Center(
                  child: Text(
                    "$_topText",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(3.0, 3.0),
                          blurRadius: 3.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        Shadow(
                          offset: Offset(3.0, 3.0),
                          blurRadius: 8.0,
                          color: Color.fromARGB(125, 0, 0, 255),
                        ),
                      ],
                    ),
                ),
              ),
            ),
            Container(
                height: 150,
                width: 300,
                decoration: new BoxDecoration(
                    color: _creation,
                    borderRadius: new BorderRadius.only(
                        bottomLeft:  const  Radius.circular(150.0),
                        bottomRight: const  Radius.circular(150.0)
                    )
                ),
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
                    _updateCreation();
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
                    _updateCreation();
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
                    _updateCreation();
                  });
                }
            ),
            HomepageButton(
                onPressed: _doneButtonPressed,
                buttonText: _getDoneButtonText()
            ),
          ],
        ),
      ),
    );
  }
}

class FancyPickerPage extends StatefulWidget {
  FancyPickerPage({Key key}) : super(key: key);


  @override
  _FancyPickerPageState createState() => _FancyPickerPageState();
}

class _FancyPickerPageState extends State<FancyPickerPage> {

  Color _pickerColor = Color.fromRGBO(245, 72, 6, 1.0);

  void changeColor(Color color) {
    setState(() => _pickerColor = color);
  }

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
                      "“The soul becomes dyed with the color of its thoughts.” ~Marcus Aurelius.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15
                      )
                  ),
                  ColorPicker(
                    pickerColor: _pickerColor,
                    onColorChanged: changeColor,
                    enableLabel: true,
                    pickerAreaHeightPercent: 0.8,
                  ),
                ]
            )
        )
    );
  }
}

