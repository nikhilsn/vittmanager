import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpanseTracker extends StatefulWidget{
  @override
  ExpanseTrackerState createState() =>ExpanseTrackerState();

}

class ExpanseTrackerState extends State<ExpanseTracker>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: SingleChildScrollView(
      child:Column(
        children: [
          Text("Expanse Tracker")
        ],
      ),
    )),
    );
  }

}