import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OptionPage extends StatefulWidget {
  @override
  OptionPageState createState() => OptionPageState();

}

class OptionPageState extends State<OptionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: SingleChildScrollView(child: Column(
        children: [
          Text("option page")
        ],
      ),)),
    );
  }

}