import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomepageButton extends StatelessWidget {
  HomepageButton({@required this.onPressed, @required this.buttonText});

  final GestureTapCallback onPressed;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return
      Container(
        width: 300,
        height: 80.0,
        padding: EdgeInsets.all(10.0),
        child: (
        RawMaterialButton(
          fillColor: Colors.deepOrange,
          splashColor: Colors.deepOrangeAccent,
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