class Validators {
  static String? emptyValidator(dynamic text) {
    if (text.isEmpty) {
      return "Empty field";
    }
    return null;
  }

  static String? emailValidator(String? email) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(email!) ? null : "Email invalid";
  }
}