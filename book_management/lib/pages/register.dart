import 'package:book_management/utils/input_string_validator.dart';
import 'package:book_management/utils/navigation_utils.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/register.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<RegisterModel>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 30,
          ),
          child: Form(
            key: model.formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: model.nameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: 'Name',
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
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: model.emailController,
                  keyboardType: TextInputType.emailAddress,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(' '),
                  ],
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
                Row(
                  children: [
                    CountryCodePicker(
                      onChanged: (val) {
                        debugPrint(val.dialCode);
                        model.setCountryCode(val.dialCode.toString().trim());
                      },
                      initialSelection: 'IN',
                      //favorite: ['+39', 'FR'],
                      // optional. Shows only country name and flag
                      showCountryOnly: false,
                      // optional. Shows only country name and flag when popup is closed.
                      showOnlyCountryWhenClosed: false,
                      // optional. aligns the flag and the Text left
                      alignLeft: false,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: model.phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                        ],
                        decoration: InputDecoration(
                          hintText: 'Phone',
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
                          if (value.length != 10) {
                            return 'Invalid number';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Consumer<RegisterModel>(
                  builder: (_, model, __) => TextFormField(
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
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Text("Already have an account?"),
                    InkWell(
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.blue),
                      ),
                      onTap: () => NavigationUtils.pop(context),
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
                    model.register(context);
                  },
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
