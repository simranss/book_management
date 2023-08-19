extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,5}))$')
        .hasMatch(this);
  }
}

extension PasswordValidator on String {
  // bool isValidPassword() {
  //   String pattern =
  //       r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  //   RegExp regExp = RegExp(pattern);
  //   return regExp.hasMatch(this);
  // }

  String? isValidPassword() {
    if (length < 8 || length > 16) {
      return 'Password must be of minimum 8 characters and maximum 16 characters';
    }
    if (!contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least 1 uppercase character [A-Z]';
    }
    if (!contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least 1 lowercase character [a-z]';
    }
    if (!contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least 1 numeric value [0-9]';
    }
    if (!contains(RegExp(r'[!@#$&*~]'))) {
      return 'Password must contain at least 1 special character [!, @, #, \$, &, *, ~]';
    }
    return null;
  }
}
