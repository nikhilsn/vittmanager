import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vm/Services/bottom_navigation_service.dart';
import 'package:vm/Services/firebase_auth_services.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {

  int _pageIndex=2;

  signOutmethod() async {
    try {
      final auth = Provider.of<FirebaseAuthService>(context, listen: false);
      await auth.signOut();
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov= Provider.of<BottomNavigationService>(context, listen: false);
    return WillPopScope(
      onWillPop: (){
          prov.gotoHomePage();
          return;
      },
      child: Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: (){
                  signOutmethod();
                } ,
                child: Text("sign out"),
              )
            ],
          ),
        )),
      ),
    );
  }
}
