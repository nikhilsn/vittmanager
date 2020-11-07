import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vm/Pages/Login.dart';
import 'package:vm/Pages/OptionaPage.dart';
import 'package:vm/Services/firebase_auth_services.dart';
import 'package:vm/sharedPrefrences/sharefPrefernces.dart';
import 'HomePage.dart';
import 'package:provider/provider.dart';

class UserCheck extends StatefulWidget {
  @override
  UserCheckClass createState() => UserCheckClass();
}

class UserCheckClass extends State<UserCheck> {
  var dataLoaded = false;
  var userExist = false;
  Widget page;
  bool optionPage = false;

  getDataSharedPreferences() async {

  }

  Widget getOption(){
    SharedPref().getOptionalPage().then((value) {
      if (value != null) {
        if (value) {
          optionPage=value;
        }
      }
      return optionPage? HomePage():OptionPage();
    });

  }

  @override
  void initState() {
    getDataSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    final _authServices =
        Provider.of<FirebaseAuthService>(context, listen: true);

    return StreamBuilder<User>(
      stream: _authServices.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          return user != null ? HomePage() : LoginPage();
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
