import 'package:flutter/material.dart';
import 'file:///C:/Users/Nikhil/AndroidStudioProjects/CreateWealth/vm/lib/Widgets/HeadText.dart';
import 'package:vm/Pages/NavigationPages/ExpanseTracker.dart';
import 'package:vm/Pages/NavigationPages/HomeScreen.dart';
import 'package:vm/Pages/NavigationPages/Profile.dart';
import 'package:vm/Pages/OptionaPage.dart';
import 'package:vm/Resources/Color.dart';
import 'package:vm/Services/bottom_navigation_service.dart';

import 'package:vm/Services/option_page_service.dart';
import 'package:vm/sharedPrefrences/sharefPrefernces.dart';
import 'package:line_icons/line_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import 'InfoPage.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> _key = GlobalKey();

  String uid;
  String name;
  String email;
  String phoneNumber;
  String photoUrl;

  int selectedIndex = 0;
  var bnbSelector;

  var pages=[
    HomeScreen(),
    ExpanseTracker(),
    ProfilePage()
  ];
  //  ------------GET DATA FROM SHARED PREFERENCES---------------
  getDataFromPreferences() async {
    SharedPref().getUid().then((String uid) {
      setState(() {
        this.uid = uid;
      });
    });
    SharedPref().getName().then((String name) {
      setState(() {
        this.name = name;
      });
      print("name==========$name");
    });
    SharedPref().getEmail().then((String email) {
      setState(() {
        this.email = email;
      });
    });
    SharedPref().getPhoneNumber().then((String num) {
      setState(() {
        this.phoneNumber = num;
      });
    });
    SharedPref().getPhotoUrl().then((String url) {
      setState(() {
        this.photoUrl = url == "null" ? "" : url;
      });
    });
    SharedPref().getOptionalPage().then((val) {
      if(val!=null) {
          OptionPageService().setTrue();
      }
    });
  }

  //----------------DRAWER NAVIGATION------------------
  Widget DrawerNavigation() {
    return Drawer(
        elevation: 16,
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(5, 5),
                                      blurRadius: 10,
                                      color: Color(0xfff1f1f3))
                                ]),
                            child: CircleAvatar(
                              radius: 35,
                              backgroundImage: NetworkImage(
                                photoUrl == null ? "" : photoUrl,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          HeadText(
                            text: name == null ? "" : name,
                          ),
                          HeadText(
                            text: email == null ? "" : email,
                          ),
                          HeadText(
                            text: phoneNumber == null ? "" : phoneNumber,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ))),
            Expanded(
              flex: 4,
              child: navigationList(),
            )
          ],
        ));
  }

//----------drawer navigation item list-------------
  Widget navigationList() {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            "Connect",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        ListTile(
          title: HeadText(
            text: "Visit Us",
          ),
          leading: Icon(
            LineIcons.globe,
            color: Colors.black,
          ),
          onTap: () {
            launch("http://rentobro.com/");
          },
        ),
        ListTile(
          title: HeadText(
            text: "Follow Us On Instagram",
          ),
          leading: Icon(
            LineIcons.instagram,
            color: Colors.black,
          ),
          onTap: () {
            launch("https://instagram.com/rentobro?igshid=g7xo9zuch31y");
          },
        ),
        ListTile(
          title: HeadText(
            text: "Help",
          ),
          leading: Icon(
            Icons.help,
            color: Colors.black,
          ),
          onTap: () {
            launch("http://rentobro.com/contact");
          },
        ),
        Divider(
          color: Colors.grey,
        ),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            "Other",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        ListTile(
          title: HeadText(
            text: "FAQs",
          ),
          leading: Icon(
            LineIcons.question,
            color: Colors.black,
          ),
          onTap: () {
            launch("http://rentobro.com/faq");
          },
        ),
        ListTile(
          title: HeadText(
            text: "Terms of Use",
          ),
          leading: Icon(
            LineIcons.newspaper_o,
            color: Colors.black,
          ),
          onTap: () {
            launch("http://rentobro.com/tnc");
          },
        ),
        ListTile(
          title: HeadText(
            text: "Privacy Policy",
          ),
          leading: Icon(
            LineIcons.newspaper_o,
            color: Colors.black,
          ),
          onTap: () {
            launch("http://rentobro.com/privacy_policy");
          },
        ),
        ListTile(
          onTap: () {
            signOut();
          },
          title: HeadText(
            text: "Logout",
          ),
          leading: Icon(
            LineIcons.sign_out,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget bnb() {
    return  BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: false,
        backgroundColor: ColorsTheme.primaryColor,
        elevation: 5,
        currentIndex: bnbSelector.getPage(),
        fixedColor: Colors.white,
        unselectedItemColor: Colors.white,
        onTap: (int index) {
          Provider.of<BottomNavigationService>(context, listen: false).setPageNumber(index);
        },
        items: [
          BottomNavigationBarItem(
              label: "Home",
              icon: Icon(
                Icons.home,
              )),
          BottomNavigationBarItem(
              label: "Expanse Tracker",
              icon: Icon(
                LineIcons.rupee,
              )),
          BottomNavigationBarItem(label: "Profile", icon: Icon(Icons.person))
        ]);
  }

  //-----------ON TAP DRAWER NAVIGATION ITEMS---------
  Future signOut() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut();
    SharedPref().removePref();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => InfoPage()));
  }

  @override
  void initState() {
    super.initState();
    getDataFromPreferences();
  }
  //
  // return optionPage?  Scaffold(
  // key: _key,
  // bottomNavigationBar: bnb(),
  // body: pages[selectedIndex] ,
  // ): OptionPage();

  // Consumer<OptionPageService>(
  // builder: (context, ops, child){
  // return ops.get()?pages[selectedIndex]: OptionPage();
  // },
  // );

  @override
  Widget build(BuildContext context) {

    final opsp=Provider.of<OptionPageService>(context, listen: true);
    bnbSelector= Provider.of<BottomNavigationService>(context, listen: true);
  return  opsp.get()?Scaffold(
      key: _key,
      bottomNavigationBar: bnb(),
      body: pages[bnbSelector.getPage()] ,
      ): OptionPage();
  }
}
