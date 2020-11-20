import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vm/Pages/ExpansetrackerPages/CorectAccountPage.dart';
import 'package:vm/Pages/ExpansetrackerPages/ETGetStarted.dart';
import 'package:vm/Resources/Color.dart';
import 'package:vm/Services/bottom_navigation_service.dart';
import 'package:vm/Services/expanse_tracker_services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms/sms.dart';
import 'ExpanseSMSPermissionPage.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:csv/csv.dart';

class ExpanseAnalysis extends StatefulWidget {
  @override
  ExpanseAnalysisState createState() => ExpanseAnalysisState();
}

class ExpanseAnalysisState extends State<ExpanseAnalysis> {
  static final pageNumber = 2;

  getPageNumber() {
    final prov = Provider.of<ExpanseTrackerServices>(context, listen: false);

    Permission.sms.status.isDenied.then((value) {
      value
          ? prov.updatePageNumber(ExpanseSMSPermissionPageState.pageNumber)
          : null;
    });
    Permission.sms.status.isPermanentlyDenied.then((value) {
      value
          ? prov.updatePageNumber(ExpanseSMSPermissionPageState.pageNumber)
          : null;
    });
    Permission.sms.status.isRestricted.then((value) {
      value
          ? prov.updatePageNumber(ExpanseSMSPermissionPageState.pageNumber)
          : null;
    });
    Permission.sms.status.isUndetermined.then((value) {
      value
          ? prov.updatePageNumber(ExpanseSMSPermissionPageState.pageNumber)
          : null;
    });
  }

  calPercent(int total, int current) {
    final prov = Provider.of<ExpanseTrackerServices>(context, listen: false);
    double percent = (current / total) * 100;
    prov.updatePercentage(percent.roundToDouble());
  }

  getSmsFuntion() async {
    SmsQuery query = SmsQuery();
    List<SmsMessage> msgs = await query.querySms(kinds: [SmsQueryKind.Inbox]);
    for (var i = 0; i < msgs.length; i++) {
      SmsMessage m = msgs[i];

      calPercent(msgs.length, i);

      // if (m.body.contains("Credited")) {
      //   if (m.body.contains("INR")) {
      //     print(m.date);
      //     var sl = m.body.split("INR");
      //     var sl2 = sl[1].split(" ");
      //     print(sl2[1]);
      //     if (sl2[1].contains(",")) {
      //       var t1 = sl2[1].split(",");
      //       sl2[1] = "";
      //       for (var t in t1) {
      //         sl2[1] = sl2[1] + t;
      //       }
      //     }
      //     // creditAmount = creditAmount + double.parse(sl2[1].toString());
      //   }
      // if (m.body.contains("Rs.")) {
      //   print(m.date);
      //   print(m.body);
      //
      //   // var sl = m.body.split("Rs");
      //   // var sl2 = sl[1].split(" ");
      //   // print(sl2[1]);
      //   // if (sl2[1].contains(",")) {
      //   //   var t1 = sl2[1].split(",");
      //   //   sl2[1] = "";
      //   //   for (var t in t1) {
      //   //     sl2[1] = sl2[1] + t;
      //   //   }
      //   // }
      //   // creditAmount = creditAmount + double.parse(sl2[1].toString());
      // }
      // }
    }
    // print("Credited amount= $creditAmount");
  }

  @override
  void initState() {
    super.initState();
    getPageNumber();
    getSmsFuntion();
  }


  readfile()async {
    final input = new File('Downloads/file.csv').openRead();
    final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
    for(var f in fields){
      print(f.asMap().toString());
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
          body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 1, child: Container()),
            Consumer<ExpanseTrackerServices>(
              builder: (context, ets, child) {
                double percent = 0.0;
                try {
                  percent = ets.getPercentage() / 100;
                } catch (err) {
                  print(err);
                }
                return CircularPercentIndicator(
                  radius: 140,
                  percent: percent,
                  lineWidth: 15,
                  backgroundColor: Colors.grey,
                  linearGradient: LinearGradient(
                    colors: [
                      ColorsTheme.secondryColor,
                      ColorsTheme.primaryColor,
                      ColorsTheme.primaryDark
                    ],
                  ),
                  header: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Analysing your balances...",
                      style: GoogleFonts.aBeeZee(fontSize: 18),
                    ),
                  ),
                  center: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${ets.getPercentage().toString()}%",
                      style: GoogleFonts.aBeeZee(
                        color: ColorsTheme.primaryDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
            Expanded(flex: 1, child: Container()),
            Consumer<ExpanseTrackerServices>(
              builder: (context, ets, child) {
                double op = 0.0;
                if (ets.getPercentage() == 100.0) {
                  op = 1.0;
                }
                return Opacity(
                  opacity: op,
                  child: GestureDetector(
                    onTap: () {
                      ets.updatePageNumber(CorrectAccountPageState.pageNumber);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: ColorsTheme.primaryDark,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Continue",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.aBeeZee(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      )),
    );
  }
}
