import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vm/Services/bottom_navigation_service.dart';
import 'package:google_fonts/google_fonts.dart';

class CorrectAccountPage extends StatefulWidget {
  @override
  CorrectAccountPageState createState() => CorrectAccountPageState();
}

class CorrectAccountPageState extends State<CorrectAccountPage> {
  static final pageNumber = 3;

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<BottomNavigationService>(context, listen: false);

    return WillPopScope(
      onWillPop: () {
        prov.gotoHomePage();
        return;
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Please confirm your bank and balances",
                textAlign: TextAlign.center,
                style: GoogleFonts.aBeeZee(fontSize: 18),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
