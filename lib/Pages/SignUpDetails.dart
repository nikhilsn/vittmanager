import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:vm/Pages/HomePage.dart';
import 'package:vm/Pages/OptionaPage.dart';
import 'package:vm/Resources/Color.dart';
import 'package:vm/sharedPrefrences/sharefPrefernces.dart';

import 'Login.dart';
import '../Resources/SupportDialogs.dart';
import '../Resources/title_text.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpDetails extends StatefulWidget {
  bool email;

  SignUpDetails(this.email);

  @override
  SignUpDetailsState createState() => SignUpDetailsState(email);
}

class SignUpDetailsState extends State<SignUpDetails> {
  FirebaseMessaging _fcm = FirebaseMessaging();
  bool emailb;

  String uid;
  String name;
  String email;
  String phoneNumber;
  String referedBy;
  String photoUrl;

  GlobalKey<ScaffoldState> _scaffold = GlobalKey();
  final referalForm = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();
  final emailformKey = GlobalKey<FormState>();

  String phoneNo, verificationId, smsCode;
  bool codeSent = false;
  var referByController = TextEditingController();

  bool verified = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  SignUpDetailsState(this.emailb);

  //  ------------GET DATA FROM SHARED PREFERENCES---------------
  getDataFromPreferences() async {
    SharedPref().getUid().then((String uid) {
      setState(() {
        this.uid = uid;
        debugPrint(uid);
      });
    });
    SharedPref().getName().then((String name) {
      setState(() {
        this.name = name;
        debugPrint(name);
      });
    });
    SharedPref().getEmail().then((String email) {
      setState(() {
        this.email = email;
        debugPrint(email);
      });
    });
    SharedPref().getPhoneNumber().then((String num) {
      setState(() {
        this.phoneNumber = num;
        debugPrint(num);
      });
    });
    SharedPref().getPhotoUrl().then((String url) {
      setState(() {
        this.photoUrl = url;
      });
    });
  }

  // sendDataToServer() async {
  //   debugPrint("send data to server");
  //   SupportDialogs().ProcessingDialog(context);
  //   var connection = await SupportFunctions().checkInternetConnection();
  //   if (connection) {
  //     var dUrl = DBURL().register;
  //     Map<String, String> header = {"Content-type": "application/json"};
  //     debugPrint(uid);
  //
  //     String userData =
  //         '{"${DBKeywords.mobile}":"$phoneNumber" , "${DBKeywords.email}":"$email", "${DBKeywords.uid}":"$uid" , "${DBKeywords.name}":"$name" , "${DBKeywords.photoUrl}":"${photoUrl == null ? "" : photoUrl}","${DBKeywords.code}":"$referedBy"}';
  //     Response response = await post(dUrl, headers: header, body: userData);
  //     debugPrint(response.body.toString());
  //     debugPrint(response.statusCode.toString());
  //     if (response.statusCode == 200) {
  //       try {
  //         var data = json.decode(response.body);
  //         if (data[DBKeywords.msg].toString() ==
  //             "Email or Mobile already exist") {
  //           Navigator.pop(context);
  //           _scaffold.currentState.showSnackBar(SnackBar(
  //             content: Text(
  //                 "${emailb ? "Mobile Number Is Already In Use" : "Email Is Already In Use"}"),
  //           ));
  //           await Future.delayed(Duration(seconds: 1));
  //           Navigator.pushReplacement(
  //               context, MaterialPageRoute(builder: (context) => Login()));
  //         } else if (data[DBKeywords.msg].toString() ==
  //             "Invalid referral code") {
  //           Navigator.pop(context);
  //           _scaffold.currentState.showSnackBar(SnackBar(
  //             content: Text("${"Invalid Referral Code"}"),
  //           ));
  //         } else {
  //           Navigator.pop(context);
  //           setState(() {
  //             verified = true;
  //           });
  //           Navigator.pushReplacement(
  //               context, MaterialPageRoute(builder: (context) => HomePage()));
  //         }
  //       } catch (e) {}
  //     } else {
  //       Navigator.pop(context);
  //       _scaffold.currentState.showSnackBar(SnackBar(
  //         content: Text("Some Error Occurred, Please try After Sometime"),
  //       ));
  //     }
  //   } else {
  //     Navigator.pop(context);
  //     SupportDialogs().NoInternetDialog(context);
  //   }
  // }

  Widget appBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TitleText(
          text: "Complete SignUp Process",
        )
      ],
    );
  }

  Future getImage() async {
    // var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
//      _imageFile = image;
    });
  }

  Future<String> verifyEmail(String email, String password) async {
    SupportDialogs().ProcessingDialog(context);
    print("verify hua");
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      print("try m aya hai");
      FirebaseUser user = result.user;
      await user.sendEmailVerification();
      SharedPref().setEmail(user.email);
      SharedPref().setName(user.displayName);
      Navigator.pop(context);
      setState(() {
        verified = true;
      });

      return user.uid;
    } on PlatformException catch (e) {
      print("An error occured while trying to send email verification");
      print(e.message);
      switch (e.code) {
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          _scaffold.currentState.showSnackBar(
              SnackBar(content: Text("Email Already In Use By Other User")));
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Login()));
          break;
      }
      Navigator.pop(context);
    }
  }

  //---------VERIFY/LOGIN BUTTON
  Widget _emailSendButton() {
    return GestureDetector(
      onTap: () {
        if (emailformKey.currentState.validate()) {
          SupportDialogs().ProcessingDialog(context);
          verifyEmail(email, "password");
        }
      },
      child: Container(
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
              color: ColorsTheme.secondryColor,
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

  Widget emailVerificationField() {
    return verified
        ? Container(
            padding: EdgeInsets.all(70),
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.done,
                    size: 30,
                    color: ColorsTheme.secondryColor,
                  ),
                ),
                Text(
                  "A Verification Email Is Sent to $email",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ],
            ))
        : Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Stack(fit: StackFit.loose, children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: new BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(
                                  photoUrl == null ? "" : photoUrl),
                              fit: BoxFit.cover,
                            ),
                          )),
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 70.0, right: 90.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            child: CircleAvatar(
                              backgroundColor: Colors.yellow,
                              radius: 25.0,
                              child: Icon(
                                Icons.photo_library,
                                color: Colors.white,
                              ),
                            ),
                            onTap: () {
                              getImage();
                            },
                          )
                        ],
                      )),
                ]),
                SizedBox(
                  height: 20,
                ),
                Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Form(
                        key: emailformKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: "Enter Your Name",
                              ),
                              onChanged: (val) {
                                setState(() {
                                  this.name = val;
                                });
                              },
                              // ignore: missing_return
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return "Enter Your Name";
                                }
                              },
                            ),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: "Enter Email Id",
                              ),
                              onChanged: (val) {
                                setState(() {
                                  this.email = val;
                                });
                              },
                              // ignore: missing_return
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return "Enter Email Id";
                                }
                                if (!value.contains("@") &&
                                    !value.contains(".")) {
                                  return "Please Enter Correct Email Id";
                                }
                              },
                            )
                          ],
                        ))),
                SizedBox(
                  height: 20,
                ),
                _emailSendButton()
              ],
            ),
          );
  }

  //-----------------MOBILE VERIFICATION FIELDS----------------

  Widget mobileVerificationField() {
    return verified
        ? Container(
            padding: EdgeInsets.all(70),
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.done,
                    size: 30,
                    color: ColorsTheme.primaryColor,
                  ),
                ),
                Text(
                  "Phone Number Verified",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ],
            ))
        : Expanded(
            child: Container(
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
                                    border: Border.all(
                                        color: Colors.white, width: 1)),
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0),
                                    child: TextFormField(
                                      style: GoogleFonts.aBeeZee(
                                          color: Colors.white),
                                      cursorColor: Colors.white,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        hintStyle: GoogleFonts.aBeeZee(
                                            color: Colors.white),
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
                                    border: Border.all(
                                        color: Colors.white, width: 1)),
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0),
                                    child: TextFormField(
                                      style: GoogleFonts.aBeeZee(
                                          color: Colors.white),
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        hintText: 'Enter OTP',
                                        hintStyle: GoogleFonts.aBeeZee(
                                            color: Colors.white),
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
                    ))),
          );
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
              color: ColorsTheme.primaryDark,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white, width: 1),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.8),
                    offset: Offset(0, 0),
                    blurRadius: 6)
              ]),
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
      phoneData(authResult);
    };

    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      _scaffold.currentState.showSnackBar(SnackBar(
        content: Text(
          "${authException.message}",
        ),
      ));
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

  //----------SIGN IN WITH OTP----------
  signInWithOTP(smsCode, verId) {
    SupportDialogs().ProcessingDialog(context);
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    Navigator.pop(context);
    phoneData(authCreds);
  }

  phoneData(authCreds) async {
    if (authCreds != null) {
      SupportDialogs().ProcessingDialog(context);
      phoneNumber = "+91$phoneNo";
      SharedPref().setPhoneNumber(phoneNumber);
      Navigator.pop(context);
      setState(() {
        verified = true;
      });
      callNextPage();
    }
  }

  Widget referalCodeField() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Text(
              "Have A Referal Code? Enter Here",
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  decoration: BoxDecoration(
                      color: Color(0xfff1f1f3),
                      borderRadius: BorderRadius.circular(10)),
                  child: Form(
                    key: referalForm,
                    child: TextFormField(
                      controller: referByController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "Referal Code",
                        disabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                      ),
                      onChanged: (val) {
                        setState(() {
                          this.referedBy = val;
                        });
                      },
                      // ignore: missing_return
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Please Enter Code Before Proceeding";
                        }
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 0,
                child: GestureDetector(
                  child: Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: ColorsTheme.primaryColor),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Proceed",
                            style: TextStyle(
                              color: ColorsTheme.primaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      )),
                  onTap: () {
                    if (referalForm.currentState.validate()) {
                      if (verified) {
                        // sendDataToServer();
                      } else {
                        _scaffold.currentState.showSnackBar(SnackBar(
                          content: Text("Complete SignUp To Continue"),
                        ));
                      }
                    }
                  },
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                "Skip->",
                style: TextStyle(
                    color: Colors.grey, decoration: TextDecoration.underline),
                textAlign: TextAlign.center,
              ),
            ),
            onTap: () async {
              referedBy = null;
              if (verified) {
                // sendDataToServer();
              } else {
                _scaffold.currentState.showSnackBar(SnackBar(
                  content: Text("Complete SignUp To Continue"),
                ));
              }
            },
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  callNextPage(){
    SharedPref().getOptionalPage().then((value){
      if(value==null || value==false){
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => OptionPage()));
      }else{
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }

    });

  }

  @override
  void initState() {
    super.initState();

    _fcm.subscribeToTopic("test");
    getDataFromPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: ColorsTheme.primaryDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                appBar(),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Please Fill Missing Details",
                  style: GoogleFonts.aBeeZee(
                      color: Colors.white, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
//                email == null
//                    ? emailVerificationField()
//                    :
                emailb ? mobileVerificationField() : emailVerificationField(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
