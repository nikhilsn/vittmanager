import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vm/Pages/OptionaPage.dart';
import 'package:vm/sharedPrefrences/sharefPrefernces.dart';
import 'Pages/HomePage.dart';
import 'Pages/InfoPage.dart';
import 'file:///C:/Users/Nikhil/AndroidStudioProjects/CreateWealth/vm/lib/Pages/Login.dart';
import 'package:vm/Resources/Color.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserCheck extends StatefulWidget {
  @override
  UserCheckClass createState() => UserCheckClass();
}

class UserCheckClass extends State<UserCheck> {
  var dataLoaded = false;
  var userExist = false;
  Widget page;
  bool optionalPage = false;

  getDataFromPreferences() async {
    SharedPref().getOptionalPage().then((value) {
      if (value != null) {
        setState(() {
          optionalPage = value;
        });
      }
      check();
    });
  }

  check() async {
    Future<FirebaseUser> u = FirebaseAuth.instance.currentUser();
    u.then((FirebaseUser us) {
      // setState(() {
      //   if (us != null) {
      //     dataLoaded = true;
      //     userExist = true;
      //   } else {
      //     dataLoaded = true;
      //     userExist = false;
      //   }
      // });

      if (us != null) {
        if (optionalPage) {
          setState(() {
            page = HomePage();
          });
        } else {
          setState(() {
            page = OptionPage();
          });
        }
      } else {
        setState(() {
          page = InfoPage();
        });
      }
    });
  }

  @override
  void initState() {
    page = Container(
        color: ColorsTheme.secondryColor,
        child: Center(
            child: Text(
              "Loading",
              style: TextStyle(color: Colors.black, fontSize: 18),
            )));

    getDataFromPreferences();


  }

  @override
  Widget build(BuildContext context) {
    return page;
  }
}
