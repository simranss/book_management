import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:book_management/constants/api_strings.dart';

class LoginModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  var obscurePassword = true;

  toggleObscurePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  register(BuildContext context) async {
    Map<String, String> data = {
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
      'name': nameController.text.trim(),
    };

    Map<String, String> customHeaders = {"content-type": "application/json"};

    try {
      var response = await http.post(
        Uri.parse(APIStrings.REGISTER_API),
        headers: customHeaders,
        body: jsonEncode(data),
      );
      debugPrint('status code: ${response.statusCode}');
      debugPrint(response.body);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonDecode(response.body)['message'])));
      }
    } catch (err) {
      debugPrint('error: $err');
    }
    //debugPrint(response.body);
  }
}
