import 'dart:io';

import 'package:book_management/pages/home.dart';
import 'package:book_management/utils/navigation_utils.dart';
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

  login(BuildContext context) async {
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
      debugPrint('response body: ${response.body}');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonDecode(response.body)['message'])));
      }

      if (response.statusCode == 200) {
        if (context.mounted) {
          NavigationUtils.pushReplacement(context, const HomePage());
        }
      }
    } on SocketException {
      debugPrint('error: No internet');
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('No Internet')));
      }
    } catch (err) {
      debugPrint('error: $err');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Something went wrong')));
      }
    }
    //debugPrint(response.body);
  }
}
