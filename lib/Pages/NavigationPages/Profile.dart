import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget{
  @override
  ProfilePageState createState() =>ProfilePageState();

}

class ProfilePageState extends State<ProfilePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: SingleChildScrollView(
      child:Column(
        children: [
          Text("Profile Page")
        ],
      ),
    )),
    );
  }

}