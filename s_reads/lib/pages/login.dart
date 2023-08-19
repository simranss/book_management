import 'package:s_reads/models/login.dart';
import 'package:s_reads/models/register.dart';
import 'package:s_reads/pages/register.dart';
import 'package:s_reads/utils/input_string_validator.dart';
import 'package:s_reads/utils/navigation_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 30,
            ),
            child: Consumer<LoginModel>(
              builder: (_, model, __) => Form(
                key: model.formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: model.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'E-mail',
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        if (!value.trim().isValidEmail()) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: model.passwordController,
                      keyboardType: TextInputType.text,
                      obscureText: model.obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        isDense: true,
                        suffixIcon: IconButton(
                          icon: Icon(model.obscurePassword
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded),
                          onPressed: () => model.toggleObscurePassword(),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        return value.isValidPassword();
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Text("Don't have an account?"),
                        InkWell(
                          child: const Text(
                            "Register",
                            style: TextStyle(color: Colors.blue),
                          ),
                          onTap: () => NavigationUtils.push(
                            context,
                            ChangeNotifierProvider<RegisterModel>(
                              create: (_) => RegisterModel(),
                              child: const RegisterPage(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        )),
                      ),
                      onPressed: () {
                        if (model.formKey.currentState!.validate()) {
                          model.login(context);
                        }
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
