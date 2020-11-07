import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vm/Resources/Color.dart';
import 'package:vm/Resources/Strings.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vm/sharedPrefrences/sharefPrefernces.dart';


class HomeScreen extends StatefulWidget{
  @override
  HomeScreenState createState() =>HomeScreenState();

}

class HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{

  int _pageIndex=0;
  TabController _tabController;
  bool _optionPage=false;

  getDataFromPreferences()async {
    SharedPref().getOptionalPage().then((value) {
      if(value!=null){
        setState(() {
          _optionPage=value;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 1, vsync: this);
    getDataFromPreferences();

  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsTheme.primaryColor,
          // leading: GestureDetector(
          //   onTap: () {
          //     _key.currentState.openDrawer();
          //   },
          //   child: Icon(
          //     Icons.menu,
          //     color: Colors.white,
          //   ),
          // ),
          title: Text(
            Strings.appName,
            textAlign: TextAlign.center,
            style: GoogleFonts.aBeeZee(color: Colors.white, fontSize: 22),
          ),
          bottom: TabBar(
            unselectedLabelColor: ColorsTheme.secondryColor,
            labelColor: Colors.white,
            controller: _tabController,
            tabs: [
              Tab(
                child: Text(Strings.personalFinanceManagement,textAlign: TextAlign.start,),
              ),
              // Tab(
              //   text: Strings.expenseTracker,
              // ),
            ],
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
        ),
        body: TabBarView(controller: _tabController, children: [
          Text(
            Strings.personalFinanceManagement,
            textAlign: TextAlign.center,
            maxLines: 3,
            style: GoogleFonts.aBeeZee(),
          ),
          // Text(
          //   Strings.expenseTracker,
          //   textAlign: TextAlign.center,
          //   maxLines: 3,
          //   style: GoogleFonts.aBeeZee(),
          // ),
        ]),
      ),
    );
  }

}