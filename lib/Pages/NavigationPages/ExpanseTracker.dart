import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vm/Resources/Color.dart';
import 'package:vm/Resources/Strings.dart';
import 'package:vm/Services/bottom_navigation_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sms/sms.dart';

class ExpanseTracker extends StatefulWidget {
  @override
  ExpanseTrackerState createState() => ExpanseTrackerState();
}

class ExpanseTrackerState extends State<ExpanseTracker> {
  int _pageindex = 1;

  getSmsFuntion() async {
    SmsQuery query = SmsQuery();
    List<SmsMessage> msgs = await query.querySms(kinds: [SmsQueryKind.Inbox]);
    for (var m in msgs) {
      print(m.body);
    }
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
        appBar: AppBar(
          backgroundColor: ColorsTheme.primaryColor,
          // leading: GestureDetector(
          //   onTap: () {
          //     _key.currentState.openDrawer();
          //   },
          //   child: Icon(
          //     Icons.menu,
          //     color: Colors.white,
          //   ),
          // ),
          title: Text(
            Strings.appName,
            textAlign: TextAlign.center,
            style: GoogleFonts.aBeeZee(color: Colors.white, fontSize: 22),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            getSmsFuntion();
          },
          child: Container(
            decoration: BoxDecoration(color: Colors.red),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text("Get sms"),
            ),
          ),
        ),
      ),
    );
  }
}
