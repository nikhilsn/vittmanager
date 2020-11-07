import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vm/Pages/HomePage.dart';
import 'package:vm/Resources/Color.dart';
import 'package:vm/Resources/Strings.dart';
import 'package:vm/Services/option_page_service.dart';
import 'package:vm/sharedPrefrences/sharefPrefernces.dart';
import 'package:provider/provider.dart';

class OptionPage extends StatefulWidget {
  @override
  OptionPageState createState() => OptionPageState();
}

class OptionPageState extends State<OptionPage> {
  String uName = "";
  bool optionPage = false;

  getDataSharedPreferences() async {
    SharedPref().getName().then((value) {
      setState(() {
        uName = value;
      });
    });
  }

  Widget getButton(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: ColorsTheme.primaryDark,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(color: Colors.grey, offset: Offset(0, 0), blurRadius: 3)
            ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: GoogleFonts.aBeeZee(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget getSkipButton() {
    return GestureDetector(
      onTap: () {
        Provider.of<OptionPageService>(context, listen: false).setTrue();
        print("onclick");
      },
      child: Padding(
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey, offset: Offset(0, 0), blurRadius: 3)
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              "Skip",
              textAlign: TextAlign.center,
              maxLines: 2,
              style: GoogleFonts.aBeeZee(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    getDataSharedPreferences();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Welcome to Vitt Manager, ${uName}",
                maxLines: 3,
                style: GoogleFonts.aBeeZee(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width / 5,
                backgroundColor: Colors.grey.shade200,
                child: Image.asset(
                  "assets/vm/logo1.png",
                  width: MediaQuery.of(context).size.width / 4,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "What would you like to do first?",
                maxLines: 3,
                style: GoogleFonts.aBeeZee(
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            GestureDetector(
                onTap: () {
                  SharedPref().setOptionalPage(true);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: getButton(Strings.personalFinanceManagement)),
            getButton(Strings.expenseTracker),
            getSkipButton()
          ],
        ),
      )),
    );
  }
}
