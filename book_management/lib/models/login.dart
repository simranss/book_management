import 'dart:io';

import 'package:book_management/constants/shared_prefs_strings.dart';
import 'package:book_management/models/home.dart';
import 'package:book_management/pages/home.dart';
import 'package:book_management/utils/navigation_utils.dart';
import 'package:book_management/utils/shared_prefs_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:book_management/constants/api_strings.dart';
import 'package:provider/provider.dart';

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

      var body = response.body;
      var bodyMap = jsonDecode(body);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(bodyMap['message']),
        ));
      }

      if (response.statusCode == 200) {
        await SharedPrefsUtils.setBool(SharedPrefsStrings.isLoggedIn, true);
        await SharedPrefsUtils.setString(
            SharedPrefsStrings.userId, bodyMap['id']);
        await SharedPrefsUtils.setString(
            SharedPrefsStrings.userEmail, bodyMap['email']);
        await SharedPrefsUtils.setString(
            SharedPrefsStrings.userAccessGroup, bodyMap['access_group']);
        await SharedPrefsUtils.setString(
            SharedPrefsStrings.userName, bodyMap['name']);
        await SharedPrefsUtils.setString(
            SharedPrefsStrings.userPhone, bodyMap['phone']);
        await SharedPrefsUtils.setBool(
            SharedPrefsStrings.isUserVerified, bodyMap['email_verified']);
        if (context.mounted) {
          NavigationUtils.pushReplacement(
            context,
            ChangeNotifierProvider(
              create: (_) => HomeModel(),
              child: const HomePage(),
            ),
          );
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
