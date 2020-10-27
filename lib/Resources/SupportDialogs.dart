import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


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
              child: Text("Loading..."),
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

}
