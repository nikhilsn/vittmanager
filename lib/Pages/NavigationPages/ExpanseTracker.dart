import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vm/Pages/ExpansetrackerPages/CorectAccountPage.dart';
import 'package:vm/Pages/ExpansetrackerPages/ETGetStarted.dart';
import 'package:vm/Pages/ExpansetrackerPages/ExpanseAnalysis.dart';
import 'package:vm/Pages/ExpansetrackerPages/ExpanseSMSPermissionPage.dart';
import 'package:vm/Resources/Color.dart';
import 'package:vm/Resources/Strings.dart';
import 'package:vm/Services/bottom_navigation_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sms/sms.dart';
import 'package:vm/Services/expanse_tracker_services.dart';
import 'package:vm/sharedPrefrences/sharefPrefernces.dart';

class ExpanseTracker extends StatefulWidget {
  @override
  ExpanseTrackerState createState() => ExpanseTrackerState();
}

class ExpanseTrackerState extends State<ExpanseTracker> {
  int _pageindex = 1;
  List<String> listOfCredit = List();
  double creditAmount = 0.0;
  List<Widget> _listExpansePage = [
    ETGetStarted(),
    ExpanseSMSPermissionPage(),
    ExpanseAnalysis(),
    CorrectAccountPage()
  ];

  getDataFromPreferences() {
    SharedPref().getExpanseStarted().then((value) {
      final prov = Provider.of<ExpanseTrackerServices>(context, listen: false);
      if (value) {
        prov.updatePageNumber(ExpanseAnalysisState.pageNumber);
      } else {
        prov.updatePageNumber(ETGetStartedState.pageNummber);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    getDataFromPreferences();
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<BottomNavigationService>(context, listen: false);
    // final _page = Provider.of<ExpanseTrackerServices>(context, listen: true);
    return WillPopScope(
      onWillPop: () {
        prov.gotoHomePage();
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsTheme.primaryColor,
          title: Text(
            Strings.appName,
            textAlign: TextAlign.center,
            style: GoogleFonts.aBeeZee(color: Colors.white, fontSize: 22),
          ),
        ),
        body: Consumer<ExpanseTrackerServices>(
          builder: (context, ets, child) {
            return _listExpansePage[ets.getPageNumber()];
          },
        ),
      ),
    );
  }
}
