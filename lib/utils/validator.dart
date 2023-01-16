class Validators {
  static String? emptyValidator(dynamic text) {
    if (text.isEmpty) {
      return "Empty field";
    }
    return null;
  }

  static String? zeroValidator(dynamic text) {
    if (text.isEmpty) {
      return "Empty field";
    }
    return double.parse(text) < 1 ? "Must be 1 or more" : null;
  }

  static String? emailValidator(String? email) {
    String p = r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$";

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(email!.trim()) ? null : "Email invalid";
  }

  static String? signInPasswordValidator(String? text) {
    if (text!.length < 8) {
      return "Password must contain at least 8 characters";
    } else {
      return null;
    }
  }

  static String? mnemonicValidator(String? value) {
    if (value!.length <= 24) {
      return "A small number of words";
    }
    if (value.split(' ').toList().length < 12) {
      return "Incorrect mnemonic format";
    }
    return null;
  }

  static String? signUpPasswordValidator(String? text) {
    return RegExp(r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(text!)
        ? null
        : "Use 8 or more characters with letters, numbers & symbols";
  }

  static String? firstNameValidator(String? text) {
    return (text?.length ?? 0) > 1 ? null : "First name must be more than 2 characters";
  }

  static String? lastNameValidator(String? text) {
    return (text?.length ?? 0) > 1 ? null : "Last name must be more than 2 characters";
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
    return (text?.length ?? 0) < 400 ? null : "Too many characters ${text!.length}/400";
  }

  static String? nicknameTwitterValidator(String? text) {
    return (text?.length ?? 0) < 400 ? null : "Too many characters ${text!.length}/15";
  }

  static String? nicknameFacebookValidator(String? text) {
    return (text?.length ?? 0) < 400 ? null : "Too many characters ${text!.length}/50";
  }

  static String? nicknameLinkedInValidator(String? text) {
    return (text?.length ?? 0) < 400 ? null : "Too many characters ${text!.length}/30";
  }
}
