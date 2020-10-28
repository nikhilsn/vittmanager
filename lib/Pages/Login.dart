import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vm/Pages/SignUpDetails.dart';
import 'package:vm/Resources/Color.dart';
import 'package:vm/Resources/SupportDialogs.dart';
import 'package:vm/sharedPrefrences/sharefPrefernces.dart';
import '../Resources/title_text.dart';
import 'HomePage.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  @override
  HomePageStateClass createState() => HomePageStateClass();
}

class HomePageStateClass extends State<Login> {
  var isUserLogin = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  final formKey = new GlobalKey<FormState>();
  String phoneNo, verificationId, smsCode;
  bool codeSent = false;
  String name;
  final nameFormKey = new GlobalKey<FormState>();
  bool nameExist = false;

  saveDataToPreferences(
      String uid, String name, String email, String url, String phoneNumber) {
    debugPrint("shared pref");
    SharedPref().setUid(uid);
    SharedPref().setName(name);
    SharedPref().setEmail(email);
    SharedPref().setPhotoUrl(url);
    SharedPref().setPhoneNumber(phoneNumber);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpDetails(true)));
  }

//   saveDataToserver(
//       [String uid,
//       String name,
//       String email,
//       String url,
//       String phoneNumber]) async {
//     SupportDialogs().ProcessingDialog(context);
//
//     var connection= await SupportFunctions().checkInternetConnection();
//     if(connection) {
//       var dUrl = DBURL().login;
//       Map<String, String> header = {"Content-type": "application/json"};
//       String verificationData =
//       email == null ? '{"mobile":"$phoneNumber"}' : '{"email":"$email"}';
// //    String verificationData = '{"mobile":"12345"}';
//       Response response =
//       await post(dUrl, headers: header, body: verificationData);
//       var data = json.decode(response.body);
//       debugPrint(data[DBKeywords.userdata].toString());
//       if (data[DBKeywords.userdata].toString() == DBKeywords.usernotfound) {
//         Navigator.pop(context);
//         Navigator.of(context).pushReplacement(MaterialPageRoute(
//             builder: (context) =>
//                 SignUpDetails(email !=
//                     null))); //WILL RETURN TRUE IF EMAIL IS PRESENT THEN NEXT PAGE WILL SHOW MOBILE NUMBER REGISTRATION
//       } else {
//         var userData = data[DBKeywords.userdata];
//         saveDataToPreferences(
//             userData[DBKeywords.uid].toString(),
//             userData[DBKeywords.name].toString(),
//             userData[DBKeywords.email].toString(),
//             userData[DBKeywords.photoUrl].toString(),
//             userData[DBKeywords.mobile].toString());
//         if (response.statusCode == 200) {
//           Navigator.pop(context);
//           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()),);
//         }
//       }
//     }else {
//       Navigator.pop(context);
//       SupportDialogs().NoInternetDialog(context);
//     }
//   }

  Future signInWithGoogle() async {
    SupportDialogs().ProcessingDialog(context);
    try {
      GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      AuthResult result = await _auth.signInWithCredential(credential);
      user = result.user;
      Navigator.pop(context);
      setState(() {
        isUserLogin = true;
      });
//      assert(googleSignIn.currentUser.email == user.email);
      saveDataToPreferences(user.uid, user.displayName, user.email,
          user.photoUrl, user.phoneNumber);
      // saveDataToserver(user.uid, user.displayName, user.email, user.photoUrl);
//      Navigator.push(
//          context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (err) {
      print("$err");
    }
  }

  Future signOutGoogle() async {
    await _auth.signOut().then((onValue) {
      googleSignIn.signOut();
    });
    setState(() {
      isUserLogin = false;
    });
  }

  //---------GOOGLE SIGN BUTTON---------
  Widget _signInButton() {
    return GestureDetector(
      onTap: () {
        signInWithGoogle();
      },
      child: Container(
        decoration: BoxDecoration(
            color: ColorsTheme.primaryDark,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white, width: 1),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.8),
                  offset: Offset(0, 0),
                  blurRadius: 6)
            ]),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                  image: AssetImage("assets/other/google_logo.png"),
                  height: 35.0),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Sign in with Google',
                  style: GoogleFonts.aBeeZee(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //----------PHONE SIGN IN WIDGET------------
  Widget _phoneSignin() {
    return Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                !codeSent
                    ? Container(
                        decoration: BoxDecoration(
                            // color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white, width: 1)),
                        child: Padding(
                            padding: EdgeInsets.only(left: 25.0, right: 25.0),
                            child: TextFormField(
                              style: GoogleFonts.aBeeZee(color: Colors.white),
                              cursorColor: Colors.white,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintStyle:
                                    GoogleFonts.aBeeZee(color: Colors.white),
                                fillColor: Colors.white,
                                focusColor: Colors.white,
                                hoverColor: Colors.white,
                                hintText: 'Enter phone number',
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              ),
                              onChanged: (val) {
                                setState(() {
                                  this.phoneNo = val;
                                });
                              },
                              // ignore: missing_return
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return "Enter Phone Number";
                                }
                                if (value.length != 10) {
                                  return "Please Enter 10 digit mobile number";
                                }
                              },
                            )),
                      )
                    : Container(),
                SizedBox(
                  height: 10,
                ),
                codeSent
                    ? Container(
                        decoration: BoxDecoration(
                            // color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white, width: 1)),
                        child: Padding(
                            padding: EdgeInsets.only(left: 25.0, right: 25.0),
                            child: TextFormField(
                              style: GoogleFonts.aBeeZee(color: Colors.white),
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintStyle:
                                    GoogleFonts.aBeeZee(color: Colors.white),
                                hintText: 'Enter OTP',
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                fillColor: Colors.white,
                                focusColor: Colors.white,
                                hoverColor: Colors.white,
                              ),
                              onChanged: (val) {
                                setState(() {
                                  this.smsCode = val;
                                });
                              },
                              // ignore: missing_return
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return "Enter OTP";
                                }
                                if (value.length != 6) {
                                  return "Please Enter 6 Digit OTP Number";
                                }
                              },
                            )),
                      )
                    : Container(),
                SizedBox(
                  height: 10,
                ),
                _sendButton()
              ],
            )));
  }

  //---------VERIFY/LOGIN BUTTON
  Widget _sendButton() {
    return GestureDetector(
      onTap: () {
        if (formKey.currentState.validate()) {
          codeSent
              ? signInWithOTP(smsCode, verificationId)
              : verifyPhone("+91$phoneNo");
        }
      },
      child: Container(
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: ColorsTheme.primaryDark,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white, width: 1),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.8),
                    offset: Offset(0, 0),
                    blurRadius: 6)
              ]),
          // decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: <Widget>[
              Text(
                codeSent ? "Login" : "Verify",
                style: GoogleFonts.aBeeZee(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ],
          )),
    );
  }

  //------------PHONE SIGN IN PROCESS-----------
  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      signIn(authResult);
    };

    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(minutes: 1),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }

//---------SignIn WITH PHONE----------
  Future signIn(AuthCredential authCreds) async {
    AuthResult result =
        await FirebaseAuth.instance.signInWithCredential(authCreds);
    FirebaseUser user = result.user;

    saveDataToPreferences(
        user.uid,
        user.displayName != null ? user.displayName : name,
        user.email != null ? user.email : null,
        user.photoUrl != null ? user.photoUrl : null,
        user.phoneNumber);
    // saveDataToserver(
    //     user.uid,
    //     user.displayName != null ? user.displayName : null,
    //     user.email != null ? user.email : null,
    //     user.photoUrl != null ? user.photoUrl : null,
    //     user.phoneNumber);

//    if (user.displayName == null) {
//      getDialog();
//    } else {
//      setState(() {
//        nameExist = true;
//      });
//    }
//
//    if (nameExist) {
//      Navigator.push(
//          context, MaterialPageRoute(builder: (context) => HomePage()));
//    }
  }

  //----------SIGN IN WITH OTP----------
  signInWithOTP(smsCode, verId) {
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    signIn(authCreds);
  }

  //-----------BUTTON CLOSE RECORD---------
  Widget _buSave() {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
        child: Text(
          "Save",
          // style: GoogleFonts.aBeeZee(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        decoration: BoxDecoration(
            color: ColorsTheme.primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xffb9b9b9),
                  offset: Offset(0, 0),
                  blurRadius: 10),
            ]),
      ),
      onTap: () {
        if (nameFormKey.currentState.validate()) {
          setState(() {
            nameExist = true;
          });
          SharedPref().setName(name);
          Navigator.of(context, rootNavigator: true).pop("dialog");
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        }
      },
    );
  }

  //---------NAME DIALOG WIDGET----------
//  void getDialog() {
//    var dialog = Dialog(
//        shape:
//            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
//        child: StatefulBuilder(
//            builder: (BuildContext context, StateSetter setState) {
//          return Container(
//              margin: EdgeInsets.all(20),
//              child: ListView(
//                shrinkWrap: true,
//                children: <Widget>[
//                  SizedBox(
//                    height: 10,
//                  ),
//                  Text(
//                    "Enter Your Name ",
//                    style: GoogleFonts.aBeeZee(
//                      color: LightColor.navyBlue2,
//                      fontWeight: FontWeight.w700,
//                    ),
//                    textAlign: TextAlign.center,
//                  ),
//                  SizedBox(
//                    height: 20,
//                  ),
//                  Form(
//                      key: nameFormKey,
//                      child: TextFormField(
//                        decoration: InputDecoration(
//                          hintText: 'Enter Your Name',
//                        ),
//                        onChanged: (val) {
//                          setState(() {
//                            this.name = val;
//                          });
//                        },
//                        // ignore: missing_return
//                        validator: (String value) {
//                          if (value.isEmpty) {
//                            return "Enter Your Name";
//                          }
//                        },
//                      )),
//                  SizedBox(
//                    height: 40,
//                  ),
//                  Container(
//                    padding: EdgeInsets.only(left: 40, right: 40),
//                    child: _buSave(),
//                  )
//                ],
//              ));
//        })
////
//        );
//
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        return dialog;
//      },
//    );
//  }

  @override
  void initState() {
    super.initState();
//    Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Expanded(
                        child: Text(
                          "Welcome To Vitt Manager",
                          overflow: TextOverflow.visible,
                          style: GoogleFonts.aBeeZee(
                              color: Colors.black, fontSize: 40),
                          maxLines: 4,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Image.asset(
                        "assets/vm/logo1.png",
                        height: MediaQuery.of(context).size.width / 2,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                      color: ColorsTheme.primaryDark,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, -3),
                            blurRadius: 6)
                      ]),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _phoneSignin(),
                      SizedBox(
                        height: 20,
                      ),
                      _signInButton(),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
