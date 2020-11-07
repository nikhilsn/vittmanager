import 'package:flutter/foundation.dart';

class OptionPageService with ChangeNotifier{
  bool _skip=false;

  bool get()=> _skip;

  setTrue(){
    _skip= true;
    notifyListeners();
  }

  setFalse(){
    _skip=false;
    notifyListeners();
  }
}