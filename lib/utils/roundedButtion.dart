import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({this.textLabel, this.onpress});

  final String textLabel;
  final Function onpress;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      color: Colors.lightBlue,
      borderRadius: BorderRadius.circular(20.0),
      child: MaterialButton(
        onPressed: onpress,
        minWidth: 200.0,
        child: Text(textLabel),
      ),
    );
  }
}
