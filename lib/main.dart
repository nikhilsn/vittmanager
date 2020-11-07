import 'package:flutter/material.dart';
import 'package:vm/Resources/Color.dart';
import 'package:vm/Services/bottom_navigation_service.dart';
import 'package:vm/Services/firebase_auth_services.dart';
import 'package:vm/Services/option_page_service.dart';

import 'Pages/UserCheck.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(
          create: (_)=>FirebaseAuthService(),
        ),
        ChangeNotifierProvider(
          create: (_)=>OptionPageService(),
        ),
        ChangeNotifierProvider(
          create: (_)=>BottomNavigationService(),
        )
      ],
      child: MaterialApp(
        title: 'Vitt Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: ColorsTheme.primaryColor,
          accentColor: ColorsTheme.secondryColor,
          primaryColorDark: ColorsTheme.primaryDark,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: UserCheck(),
      ),
    );
  }
}
