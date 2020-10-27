import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vm/Resources/Color.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'HomePage.dart';
import 'InfoPage.dart';

class UserCheck extends StatefulWidget {
  @override
  UserCheckClass createState() => UserCheckClass();
}

class UserCheckClass extends State<UserCheck> {
  var dataLoaded = false;
  var userExist = false;

  check() async {

   Future<FirebaseUser> u= FirebaseAuth.instance.currentUser();
    u.then((FirebaseUser us){
      setState(() {
        if(us!=null) {
          dataLoaded = true;
          userExist = true;
        }else{
          dataLoaded = true;
          userExist = false;
        }
      });
    });
  }


  @override
  void initState() {
    check();
  }
  @override
  Widget build(BuildContext context) {
    return
      dataLoaded ? userExist? HomePage():InfoPage(): Container(
          color: ColorsTheme.primaryColor,
          child: Center(
            child: Text("Loading")
          )
      );
  }
}
