import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vm/Resources/Color.dart';
import 'package:vm/Services/bottom_navigation_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vm/Services/expanse_tracker_services.dart';
import 'package:vm/Services/permission_services.dart';

import 'ETGetStarted.dart';

class ExpanseSMSPermissionPage extends StatefulWidget {
  @override
  ExpanseSMSPermissionPageState createState() =>
      ExpanseSMSPermissionPageState();
}

class ExpanseSMSPermissionPageState extends State<ExpanseSMSPermissionPage> {
  static final pageNumber = 1;

  getPermissions(){
    PermissionServices(context).getSmsPermission();
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Permission Required",
                textAlign: TextAlign.left,
                maxLines: 2,
                style: GoogleFonts.aBeeZee(
                  fontSize: 42,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "For the app to function property, we might need the following permissions.",
                maxLines: 2,
                style: GoogleFonts.aBeeZee(color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: ColorsTheme.primaryColor,
                    radius: 22,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.sms, color: Colors.white,),
                    )),
                title: Text("SMS", style: GoogleFonts.aBeeZee(),),
                subtitle: Text("To read your transaction SMSs and track your expanses",
                style: GoogleFonts.aBeeZee(),),
              ),
            ),
            Expanded(flex: 1,
            child: Container(),),
            GestureDetector(
              onTap: (){
                getPermissions();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: ColorsTheme.primaryDark,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text("Continue",
                    style: GoogleFonts.aBeeZee(
                      color: Colors.white
                    ),
                    textAlign: TextAlign.center,),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
