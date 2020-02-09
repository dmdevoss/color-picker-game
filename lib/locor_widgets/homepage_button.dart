import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomepageButton extends StatelessWidget {
  HomepageButton({@required this.onPressed, @required this.buttonText, @required this.altColor});

  final GestureTapCallback onPressed;
  final String buttonText;
  bool altColor;

  @override
  Widget build(BuildContext context) {
    altColor = altColor ?? false;
    return
      Container(
        width: 300,
        height: 80.0,
        padding: EdgeInsets.all(10.0),
        child: (
        RawMaterialButton(
          fillColor: altColor ? Colors.deepOrangeAccent : Colors.deepOrange,
          splashColor: altColor ? Colors.deepOrange : Colors.deepOrangeAccent,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  buttonText,
                  maxLines: 1,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          onPressed: onPressed,
          shape: const StadiumBorder(),
        )
      )
    );
  }
}