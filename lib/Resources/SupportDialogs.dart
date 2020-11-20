import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vm/Resources/Color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:android_intent/android_intent.dart';
import 'package:vm/Services/permission_services.dart';



class SupportDialogs {
  Dialog dialog;

  ProcessingDialog(BuildContext cont){
    dialog= Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState){
          return Container(
            height: 150,
            width: MediaQuery.of(context).size.width / 2,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20)
            ),
            child: Center(
              child:SpinKitDoubleBounce(
                color: ColorsTheme.primaryDark,
                size: 32,
              ),
            ),
          );
        },
      ),
    );

    showDialog(context: cont,
    builder: (BuildContext context)=>dialog,
    barrierDismissible: false);
  }

  NoInternetDialog(BuildContext cont){
    dialog= Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState){
          return Container(
            height: 150,
            width: MediaQuery.of(context).size.width / 2,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20)
            ),
            child: Center(
              child: Text(
                "No Internet Connection\n Please Connect To Internet To Continue",
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );

    showDialog(context: cont,
        builder: (BuildContext context)=>dialog,
        barrierDismissible: false);
  }

  PermisssionPermanentlyDeniedDialog(BuildContext cont) {
    dialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
              height: 180,
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "To use application allow Rentobro to use your location and storage. Tap Settings > Permissions and allow permissions",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.aBeeZee(),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          PermissionServices(context).updatePage();
                        },
                        child: Text(
                          "Done",
                          textAlign: TextAlign.end,
                          style: GoogleFonts.prozaLibre(color: Colors.black),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          AndroidIntent intent = AndroidIntent(
                            action:
                            "android.settings.APPLICATION_DETAILS_SETTINGS",
                            package: "com.createwealth.vm",
                            data: "package:com.createwealth.vm",
                          );
                          intent.launch().whenComplete((){
                            Navigator.pop(context);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorsTheme.primaryDark,
                            borderRadius: BorderRadius.circular(6)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Settings",
                              textAlign: TextAlign.end,
                              style: GoogleFonts.prozaLibre(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ));
        },
      ),
    );

    showDialog(
        context: cont,
        builder: (BuildContext context) => dialog,
        barrierDismissible: false);
  }


}
