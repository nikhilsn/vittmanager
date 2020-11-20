import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vm/Pages/ExpansetrackerPages/ExpanseAnalysis.dart';
import 'package:vm/Pages/ExpansetrackerPages/ExpanseSMSPermissionPage.dart';
import 'package:vm/Resources/Color.dart';
import 'package:vm/Services/bottom_navigation_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vm/Services/expanse_tracker_services.dart';
import 'package:permission_handler/permission_handler.dart';

class ETGetStarted extends StatefulWidget {
  @override
  ETGetStartedState createState() => ETGetStartedState();
}

class ETGetStartedState extends State<ETGetStarted> {
  static final pageNummber = 0;

  int getPageNumber() {
    final ets = Provider.of<ExpanseTrackerServices>(context, listen: false);

    Permission.sms.status.isGranted.then((value) {
      if (value) {
        ets.updatePageNumber(ExpanseAnalysisState.pageNumber);
      } else {
        ets.updatePageNumber(ExpanseSMSPermissionPageState.pageNumber);
      }
    });
  }

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
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                textAlign: TextAlign.center,
                style: GoogleFonts.aBeeZee(),
              ),
            ),
            GestureDetector(
              onTap: () {
                getPageNumber();
              },
              child: Container(
                decoration: BoxDecoration(
                    color: ColorsTheme.primaryDark,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1, 1),
                          blurRadius: 6)
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Get Started",
                    style: GoogleFonts.aBeeZee(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
