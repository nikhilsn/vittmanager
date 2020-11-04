import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeadText extends StatelessWidget{
  String text;
  Color color;
  HeadText({this.text, this.color});
  @override
  Widget build(BuildContext context) {
   return Text(text,
   style: GoogleFonts.aBeeZee(color: color),);
  }

}