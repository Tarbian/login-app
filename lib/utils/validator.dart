class Validator {
  static String? validateName(String? name) {
    if (name == null) {
      return null;
    }

    if (name.isEmpty) {
      return 'Name can\'t be empty';
    } else if (name.length < 4) {
      return 'Name must be at least 4 symbols';
    }

    return null;
  }

  static String? validateEmail(String? email) {
    RegExp emailRegExp = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

    if (email == null) {
      return null;
    }

    if (email.isEmpty) {
      return 'Email can\'t be empty';
    } else if (!emailRegExp.hasMatch(email)) {
      return 'Enter a correct email';
    }

    return null;
  }

  static String? validatePassword(String? password) {
    RegExp passwordRegex =
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_])');
    if (password == null) {
      return 'Password can\'t be empty';
    }

    if (password.isEmpty) {
      return 'Password can\'t be empty';
    } else if (password.length < 8) {
      return 'Enter a password with length at least 8 symbols';
    } else if (!passwordRegex.hasMatch(password)) {
      return 'Password must contain numbers, upper and lower case letters and a symbol';
    }

    return null;
  }

  static String? validatePasswordRepeat(
      String? passwordRepeat, String? password) {
    if (passwordRepeat == null) {
      return 'Repeat password';
    }

    if (passwordRepeat.isEmpty) {
      return 'Repeat password';
    } else if (passwordRepeat.length < 8) {
      return 'Enter a password with length at least 8 symbols';
    } else if (passwordRepeat != password) {
      return 'Passwords do not match';
    }

    return null;
  }
}
