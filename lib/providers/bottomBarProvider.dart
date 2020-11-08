import 'dart:async';

import 'package:flutter/cupertino.dart';

class BottomBarProvider extends ChangeNotifier {
  bool isShowBottom = false;
  void changeBottom(bool value) {
    isShowBottom = value;
    notifyListeners();
  }
}
