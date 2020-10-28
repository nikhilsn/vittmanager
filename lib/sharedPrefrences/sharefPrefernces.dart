import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  String UID = "uid";
  String NAME = "name";
  String EMAIL = "email";
  String PHOTOURL = "photourl";
  String PHONE = "phone";
  String ACCID = "accid";
  String REFEREDBY = "refered_by";
  String INFOPAGE = "infopage";
  String TOTALAMT = "totalamt";
  String OPTION_PAGE = "Option Page";

  setUid(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(UID, uid);
  }

  setName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(NAME, name);
  }

  setEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(EMAIL, email);
  }

  setPhotoUrl(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PHOTOURL, url);
  }

  setPhoneNumber(String ph) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PHONE, ph);
  }

  setAccId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(ACCID, id);
  }

  setTotalAmount(String amt) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(TOTALAMT, amt);
  }

  setReferedBy(String rb) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(REFEREDBY, rb);
  }

  setInfoPage(String ip) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(INFOPAGE, ip);
  }

  setOptionalPage(bool yes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(OPTION_PAGE, yes );
  }

  Future<bool> getOptionalPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool val = prefs.getBool(OPTION_PAGE);
    return val;
  }

  Future<String> getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String val = prefs.getString(UID);
    return val;
  }

  Future<String> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(NAME);
  }

  Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(EMAIL);
  }

  Future<String> getPhotoUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(PHOTOURL);
  }

  Future<String> getPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(PHONE);
  }

  Future<String> getACCID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(ACCID);
  }

  Future<String> getTotalAmt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(TOTALAMT);
  }

  Future<String> getReferedBy() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(REFEREDBY);
  }

  Future<String> getInfoPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(INFOPAGE);
  }

  removePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(UID);
    prefs.remove(NAME);
    prefs.remove(EMAIL);
    prefs.remove(PHOTOURL);
  }
}
