//import 'package:book_management/constants/api_strings.dart';
import 'dart:convert';

import 'package:book_management/models/login_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                keyboardType: TextInputType.text,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    var email = _emailController.text.trim();
                    var pwd = _passwordController.text.trim();
                    _login(context, email, pwd);
                  }
                },
                child: const Text('Login'),
              ),
              Consumer<LoginModel>(
                builder: (_, model, __) => Text(model.statusCode.toString()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _login(BuildContext context, String email, String password) async {
    Map<String, String> data = {
      'email': email,
      'password': password,
    };

    Map<String, String> customHeaders = {"content-type": "application/json"};

    try {
      var response = await http.post(
        Uri.parse('https://c8a3-103-38-68-253.ngrok-free.app/reader/login'),
        headers: customHeaders,
        body: jsonEncode(data),
      );
      print(response.statusCode);
      print(response.body);
      Provider.of<LoginModel>(context, listen: false)
          .updateStatusCode(response.statusCode);
    } catch (err) {
      print(err);
    }
    //print(response.body);
  }
}
