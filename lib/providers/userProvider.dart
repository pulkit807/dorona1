import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  User user;
  bool issignedIn = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  void registerUserChange() {
    auth.authStateChanges().listen((User user1) {
      if (user1 != null) {
        issignedIn = true;
        user = user1;
      } else {
        issignedIn = false;
      }

      notifyListeners();
    });
  }
}
