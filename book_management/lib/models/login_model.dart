import 'package:flutter/material.dart';

class LoginModel extends ChangeNotifier {
  int statusCode = 0;

  updateStatusCode(int val) {
    statusCode = val;
    notifyListeners();
  }
}
