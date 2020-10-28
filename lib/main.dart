import 'package:flutter/material.dart';
import 'package:vm/Resources/Color.dart';

import 'UserCheck.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vitt Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: ColorsTheme.primaryColor,
        accentColor: ColorsTheme.secondryColor,
        primaryColorDark: ColorsTheme.primaryDark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SafeArea(
        child: UserCheck(),
      ),
    );
  }
}
