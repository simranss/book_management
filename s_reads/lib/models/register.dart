import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constants/api_strings.dart';
import '../utils/navigation_utils.dart';


class RegisterModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  var countryCode = '+91';

  var obscurePassword = true;

  toggleObscurePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  setCountryCode(String val) {
    countryCode = val;
  }

  register(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      Map<String, String> data = {
        'email': emailController.text.trim(),
        'password': passwordController.text.trim(),
        'name': nameController.text.trim(),
        'phone': countryCode + phoneController.text.trim(),
      };

      Map<String, String> customHeaders = {"content-type": "application/json"};

      try {
        var response = await http.post(
          Uri.parse(APIStrings.REGISTER_API),
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
            NavigationUtils.pop(context);
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
    }
  }
}
