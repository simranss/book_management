import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:book_management/constants/api_strings.dart';

class LoginModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var obscurePassword = true;

  toggleObscurePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  login() async {
    Map<String, String> data = {
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
    };

    Map<String, String> customHeaders = {"content-type": "application/json"};

    try {
      var response = await http.post(
        Uri.parse(APIStrings.LOGIN_API),
        headers: customHeaders,
        body: jsonEncode(data),
      );
      debugPrint('status code: ${response.statusCode}');
      debugPrint(response.body);
    } catch (err) {
      debugPrint('error: $err');
    }
    //debugPrint(response.body);
  }
}
