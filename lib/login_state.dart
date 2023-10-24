import 'package:flutter/material.dart';

class LoginState with ChangeNotifier {
  bool loggedIn = false;
  bool isLoggedIn() => loggedIn;
  void login() {
    loggedIn = true;
    notifyListeners();
  }

  void logout() {
    loggedIn = false;
    notifyListeners();
  }
}
