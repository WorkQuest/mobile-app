class Validators {
  static String? emptyValidator(dynamic text, {String? customMessage}) {
    if (text.isEmpty) {
      return customMessage ?? "Empty field";
    }
    return null;
  }

  static String? zeroValidator(dynamic text, {String? customMessage}) {
    if (text.isEmpty) {
      return customMessage ?? "Empty field";
    }
    if (double.parse(text) < 1) return "Please enter a value greater than zero";
    return null;
  }

  static String? emailValidator(String? email) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(email!.trim()) ? null : "Email invalid";
  }

  static String? mnemonicValidator(String? value) {
    if (value!.length <= 24) {
      return "Entered secret phrase is too short";
    }
    if (value.split(' ').toList().length < 12) {
      return "Incorrect mnemonic format";
    }
    return null;
  }

  static String? signUpPasswordValidator(String? text) {
    return RegExp(r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\\$&*~]).{8,}$').hasMatch(text!)
        ? null
        : "Use 8 or more characters with letters, numbers & symbols";
  }

  static String? firstNameValidator(String? text) {
    return (text?.length ?? 0) > 1
        ? text!.length > 15
            ? "First name must contain no more than 15 characters"
            : null
        : "First name must be more than 2 characters";
  }

  static String? lastNameValidator(String? text) {
    return (text?.length ?? 0) > 1
        ? text!.length > 15
            ? "Last name must contain no more than 15 characters"
            : null
        : "Last name must be more than 2 characters";
  }

  static String? phoneNumberValidator(String? text) {
    String pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    RegExp regExp = new RegExp(pattern);
    if ((text?.length ?? 0) == 0) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(text!)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  static String? descriptionValidator(String? text) {
    return (text?.length ?? 0) < 400
        ? null
        : "Too many characters ${text!.length}/400";
  }

  static String? nicknameTwitterValidator(String? text) {
    return (text?.length ?? 0) < 15
        ? null
        : "Too many characters ${text!.length}/15";
  }

  static String? nicknameFacebookValidator(String? text) {
    return (text?.length ?? 0) < 50
        ? null
        : "Too many characters ${text!.length}/50";
  }

  static String? nicknameLinkedInValidator(String? text) {
    return (text?.length ?? 0) < 30
        ? null
        : "Too many characters ${text!.length}/30";
  }
}