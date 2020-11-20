import 'package:flutter/cupertino.dart';

class FloatingActionButtonProvider extends ChangeNotifier{
  bool isShowFloatingButton=false;
  void changeButton(bool newVal){
    isShowFloatingButton=newVal;
    notifyListeners();
  }
}