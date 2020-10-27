import 'package:flutter/material.dart';
import 'package:vm/Resources/Color.dart';

class TitleText extends StatelessWidget {
  final String text;
  final double fontSize;
  Color color= ColorsTheme.primaryColor;
  TitleText(
      {Key key,
      this.text,
      this.fontSize = 18,})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            fontSize: fontSize, fontWeight: FontWeight.w800, color: color,
        decoration: TextDecoration.none));
  }
}
