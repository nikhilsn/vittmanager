import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:vm/Resources/Color.dart';
import 'package:vm/sharedPrefrences/sharefPrefernces.dart';

import 'HomePage.dart';
import 'Resources/SupportDialogs.dart';
import 'Resources/title_text.dart';


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
    try {
      GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      AuthResult result = await _auth.signInWithCredential(credential);
      user = result.user;
//      setState(() {
//        isUserLogin=true;
//      });
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
    return RaisedButton(
      color: Colors.white,
      // splashColor: LightColor.navyBlue1,
      elevation: 3,
      onPressed: () {
        signInWithGoogle();
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //----------PHONE SIGN IN WIDGET------------
  Widget _phoneSignin() {
    return Card(
        elevation: 6,
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        color: Colors.white,
        child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                !codeSent
                    ? Card(
                        margin: EdgeInsets.only(left: 25, right: 25),
                        elevation: 0,
                        color: Colors.white,
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: 'Enter phone number',
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
                        ))
                    : Container(),
                SizedBox(
                  height: 10,
                ),
                codeSent
                    ? Padding(
                        padding: EdgeInsets.only(left: 25.0, right: 25.0),
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(hintText: 'Enter OTP'),
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
                        ))
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
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: <Widget>[
              TitleText(
                text: codeSent ? "Login" : "Verify",
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
        resizeToAvoidBottomInset : false,
     body: Container(
        color: ColorsTheme.primaryColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned(
              left: -100,
              right: -100,
              top: -120,
              child: CircleAvatar(
                  radius: 230,
                  backgroundColor: ColorsTheme.secondryColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 100),
                        child: Text(
                          "Welcome To Vitt Manager",
                          style: TextStyle(
                              color: Colors.white, fontSize: 40),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20,),
                _phoneSignin(),
                SizedBox(
                  height: 20,
                ),
                _signInButton(),
              ],
            ),
          ],
        )));
  }
}
